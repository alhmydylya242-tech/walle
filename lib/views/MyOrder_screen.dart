import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrdersView extends StatelessWidget {
  OrdersView({super.key});

  final supabase = Supabase.instance.client;

  Future<List<dynamic>> fetchOrders() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    return await supabase
        .from('orders')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);
  }

  Future<void> deleteOrder(String orderId) async {
    await supabase.from('orders').delete().eq('id', orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6),

      appBar: AppBar(
        backgroundColor: const Color(0xFF6B4F4F),
        title: Text('orders'.tr),
        centerTitle: true,
      ),

      body: FutureBuilder<List<dynamic>>(
        future: fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'no_orders'.tr,
                style: const TextStyle(fontSize: 16),
              ),
            );
          }

          final orders = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final o = orders[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

                  // ===== صورة اللوحة =====
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: o['image_url'] == null ||
                        o['image_url'].toString().isEmpty
                        ? Container(
                      width: 60, height: 60, color: Colors.grey.shade300,
                      child: const Icon(Icons.image_not_supported),
                    )
                        : Image.network(
                      o['image_url'], width: 60, height: 60, fit: BoxFit.cover,
                    ),),

                  // ===== اسم اللوحة =====
                  title: Text(
                    o['title'] ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // ===== السعر =====
                  subtitle: Text(
                    '${o['price']} ${'price_currency'.tr}', style: const TextStyle(
                      color: Color(0xFF6B4F4F), fontWeight: FontWeight.w600,
                    ),
                  ),

                  // ===== الحالة + حذف =====
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        o['status'],
                        style: const TextStyle(fontSize: 12, color: Colors.grey,
                        ),),
                      const SizedBox(height: 6),

                      // حذف فقط إذا pending
                      if (o['status'] == 'pending')
                        GestureDetector(
                          onTap: () {
                            Get.defaultDialog(
                              title: 'delete_order'.tr,
                              middleText: 'delete_order_confirm'.tr,
                              backgroundColor:
                              const Color(0xFFF5EFE6),
                              titleStyle: const TextStyle(
                                color: Color(0xFF6B4F4F),
                                fontWeight: FontWeight.bold,
                              ),
                              textCancel: 'cancel'.tr,
                              textConfirm: 'delete'.tr,
                              confirmTextColor: Colors.white,
                              cancelTextColor:
                              const Color(0xFF6B4F4F),
                              buttonColor:
                              const Color(0xFF6B4F4F),
                              onConfirm: () async {
                                await deleteOrder(o['id']);
                                Get.back();
                                Get.snackbar(
                                  'done'.tr,
                                  'order_deleted'.tr,
                                  backgroundColor:
                                  const Color(0xFF6B4F4F), colorText:
                                  const Color(0xFFF5EFE6),
                                );},);},
                          child: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                            size: 20,
                          ),),],),),
              );},);},),);}}