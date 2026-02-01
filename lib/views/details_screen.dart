import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaintingDetailsScreen extends StatelessWidget {
  PaintingDetailsScreen({super.key});

  final supabase = Supabase.instance.client;

  // البيانات القادمة من الهوم
  final Map painting = Get.arguments;

  Future<void> orderPainting() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      Get.snackbar(
        'error'.tr,
        'login_required'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      await supabase.from('orders').insert({
        'user_id': user.id, // مهم جدًا
        'painting_id': painting['id'],
        'title': painting['title'],
        'price': painting['price'],
        'image_url': painting['image_url'],
        'status': 'pending',
      });

      Get.snackbar(
        'success'.tr,
        'order_success'.tr,
        backgroundColor: const Color(0xFF6B4F4F),
        colorText: const Color(0xFFF5EFE6),
      );

      Get.offNamed('/orders'); // يروح لصفحة الطلبات
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'order_failed'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6),

      appBar: AppBar(
        backgroundColor: const Color(0xFF6B4F4F),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFF5EFE6)),
        title: Text(
          'painting_details'.tr,
          style: const TextStyle(color: Color(0xFFF5EFE6)),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== صورة اللوحة =====
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(28),
              ),
              child: Image.network(
                painting['image_url'],
                width: double.infinity,
                height: 320,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== العنوان (وصف) =====
                  Text(
                    painting['title'],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A2C2A),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ===== السعر =====
                  Text(
                    '${painting['price']} ${'currency'.tr}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B4F4F),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ===== التصنيف =====
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      painting['category'], style: const TextStyle(color: Color(0xFF6B4F4F), fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ===== وصف اللوحة =====
                  Text(
                    'description'.tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A2C2A),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    painting['title'], // نعتبر العنوان هو الوصف
                    style: const TextStyle(
                      fontSize: 15, height: 1.7, color: Colors.black87,
                    ),),

                  const SizedBox(height: 40),
                  // ===== زر الطلب =====
                  SizedBox(
                    width: double.infinity, height: 54,
                    child: ElevatedButton(
                      onPressed: orderPainting,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6B4F4F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'order_painting'.tr, style: const TextStyle(fontSize: 18, color: Color(0xFFF5EFE6),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],),
            ),],),),);}}