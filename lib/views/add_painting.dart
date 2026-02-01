import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

class AddPaintingView extends StatefulWidget {
  const AddPaintingView({super.key});

  @override
  State<AddPaintingView> createState() => _AddPaintingViewState();
}

class _AddPaintingViewState extends State<AddPaintingView> {
  final titleController = TextEditingController();
  final priceController = TextEditingController();

  File? selectedImage;
  bool isLoading = false;

  String selectedCategory = 'عربية';

  final List<String> categories = [
    'عربية',
    'أبيض وأسود',
    'طبيعة',
    'مجموعات',
  ];

  final supabase = Supabase.instance.client;

  // ===== Pick Image =====
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });}}

  // Save Painting
  Future<void> savePainting() async {
    if (selectedImage == null) {
      Get.snackbar('تنبيه', 'يرجى اختيار صورة للوحة');
      return;
    }

    if (titleController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty) {
      Get.snackbar('تنبيه', 'جميع الحقول مطلوبة');
      return;
    }

    final price = double.tryParse(priceController.text);
    if (price == null) {
      Get.snackbar('خطأ', 'السعر يجب أن يكون رقم');
      return;
    }

    try {
      setState(() => isLoading = true);

      // ===== Upload image =====
      final bytes = await selectedImage!.readAsBytes();
      final fileName =
          'images/${DateTime.now().millisecondsSinceEpoch}.jpg';

      await supabase.storage.from('paintings').uploadBinary(
        fileName,
        bytes,
        fileOptions: const FileOptions(contentType: 'image/jpeg'),
      );

      final imageUrl =
      supabase.storage.from('paintings').getPublicUrl(fileName);

      // ===== Insert painting =====
      await supabase.from('paintings').insert({
        'title': titleController.text.trim(),
        'price': price,
        'category': selectedCategory,
        'image_url': imageUrl,
      });

      Get.snackbar('تم', 'تمت إضافة اللوحة بنجاح 🎨');
      Get.back(); // الرجوع للهوم
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B4F4F),
        title: const Text('إضافة لوحة'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ===== Image Picker =====
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: selectedImage == null
                    ? const Center(
                  child: Text(
                    'اضغط لاختيار صورة',
                    style: TextStyle(color: Colors.brown),
                  ),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.file(
                    selectedImage!,
                    fit: BoxFit.cover,
                  ),),),),

            const SizedBox(height: 20),
            //  Title
            TextField(
              controller: titleController,
              decoration: _decoration('وصف اللوحة'),
              maxLines: 3,
            ),

            const SizedBox(height: 15),

            //  Price
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: _decoration('السعر'),
            ),

            const SizedBox(height: 15),

            //  Category
            DropdownButtonFormField<String>(
              value: selectedCategory,
              dropdownColor: Colors.white,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Color(0xFF6B4F4F),
              ),
              items: categories
                  .map(
                    (cat) => DropdownMenuItem(
                  value: cat,
                  child: Text(cat),
                ),)
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });},
              decoration: _decoration('اختر القسم'),
            ),

            const SizedBox(height: 30),

            //  Save Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isLoading ? null : savePainting,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B4F4F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text(
                  'حفظ اللوحة',
                  style: TextStyle(color: Colors.white),
                ),),),],),),);}}