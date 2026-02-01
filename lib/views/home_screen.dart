import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../controllers/auth_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final supabase = Supabase.instance.client;
  final AuthController auth = Get.find();

  String selectedCategory = 'الكل';

  final List<String> categories = [
    'الكل',
    'أبيض وأسود',
    'طبيعة',
    'مجموعات',
    'عربية',
  ];


  Stream<List<dynamic>> paintingsStream() {
    return supabase
        .from('paintings')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false);
  }

  void _confirmDelete(Map painting) {
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFFF5EFEA),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.delete_forever,
                size: 48,
                color: Color(0xFF6F4E37),
              ),
              const SizedBox(height: 12),
              const Text(
                'حذف اللوحة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6F4E37),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'هل أنت متأكد من حذف هذه اللوحة؟',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF6F4E37),
                        side: const BorderSide(color: Color(0xFF6F4E37)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Get.back(),
                      child: const Text('إلغاء'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6F4E37),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        Get.back();

                        await supabase
                            .from('paintings')
                            .delete()
                            .eq('id', painting['id']);

                        Get.snackbar(
                          'تم الحذف',
                          'تم حذف اللوحة بنجاح',
                          backgroundColor: const Color(0xFF6F4E37),
                          colorText: Colors.white,
                        );}, child: const Text('حذف'),
                    ),),],),],),),),);}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFEA),

      //  AppBar
      appBar: AppBar(
        backgroundColor: const Color(0xFF6F4E37),
        title: const Text('Walle Gallery'),
        centerTitle: true,
      ),

      // Drawer
      drawer: Drawer(
        backgroundColor: const Color(0xFFF5EFEA),
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF6F4E37)),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Color(0xFFF5EFEA),
                child: Icon(Icons.person, color: Color(0xFF6F4E37)),
              ),
              accountName: Obx(() => Text(auth.userName.value)),
              accountEmail:
              Text(auth.supabase.auth.currentUser?.email ?? ''),
            ),

            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text('طلباتي'),
              onTap: () => Get.toNamed('/orders'),
            ),

            Obx(
                  () => auth.userRole.value == 'admin'
                  ? ListTile(
                leading: const Icon(Icons.add_photo_alternate),
                title: const Text('إضافة لوحة'),
                onTap: () => Get.toNamed('/add-painting'),
              )
                  : const SizedBox(),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text('change_language'.tr),
              onTap: () {
                Get.defaultDialog(
                  title: 'change_language'.tr,
                  content: Column(
                    children: [
                      ListTile(
                        title: const Text('العربية'),
                        onTap: () {
                          Get.updateLocale(const Locale('ar'));
                          Get.back(); // يقفل الديالوج
                        },
                      ),
                      ListTile(
                        title: const Text('English'),
                        onTap: () {
                          Get.updateLocale(const Locale('en'));
                          Get.back();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),

            const Spacer(),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'تسجيل الخروج',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                await auth.logout();
                Get.offAllNamed('/login');
              },
            ),
          ],
        ),
      ),

      // Body
      body: Column(
        children: [
          // فلترة
          SizedBox(
            height: 50,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = selectedCategory == cat;

                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      selectedCategory = cat;
                    });
                  },
                  selectedColor: const Color(0xFF6F4E37),
                  backgroundColor: const Color(0xFFEDE6DF),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ),

          // ===== Grid =====
          Expanded(
            child: StreamBuilder<List<dynamic>>(
              stream: paintingsStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final allPaintings = snapshot.data!;
                final filteredPaintings =
                selectedCategory == 'الكل'
                    ? allPaintings
                    : allPaintings
                    .where((p) =>
                p['category'] == selectedCategory)
                    .toList();

                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filteredPaintings.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.65,
                  ),
                  itemBuilder: (context, index) {
                    final p = filteredPaintings[index];

                    return GestureDetector(
                      onTap: () {
                        Get.toNamed('/painting-details', arguments: p);
                      },
                      onLongPress: () {
                        if (auth.userRole.value == 'admin') {
                          _confirmDelete(p);
                        }
                      },
                      child: PaintingCard(
                        title: p['title'] ?? '',
                        price: p['price'] ?? 0,
                        imageUrl: p['image_url'],
                      ),);},);},),),],),);}}

//  Painting Card
class PaintingCard extends StatelessWidget {
  final String title;
  final num price;
  final String? imageUrl;

  const PaintingCard({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEDE6DF),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(20)),
              child: imageUrl == null || imageUrl!.isEmpty
                  ? Container(
                color: Colors.grey.shade300,
                child: const Icon(Icons.image_not_supported),
              )
                  : Image.network(
                imageUrl!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$price YER',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6F4E37),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
