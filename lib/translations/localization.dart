import 'package:get/get.dart';

class Localization extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    // ================= العربية =================
    'ar': {
      // ===== عامة =====
      'home_title': 'معرض والي',
      'orders': 'طلباتي',
      'add_painting': 'إضافة لوحة',
      'logout': 'تسجيل الخروج',
      'login': 'تسجيل الدخول',
      'register': 'إنشاء حساب',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'success': 'نجاح',
      'error': 'خطأ',

      // ===== اللغة =====
      'change_language': 'تغيير اللغة',
      'arabic': 'العربية',
      'english': 'الإنجليزية',

      // ===== اللوحات =====
      'no_paintings': 'لا توجد لوحات',
      'painting_details': 'تفاصيل اللوحة',
      'description': 'وصف اللوحة',
      'order_painting': 'طلب اللوحة',

      // ===== الطلبات =====
      'Arabiah':'عربية',
      'no_orders': 'لا توجد طلبات',
      'order_success': 'تم إرسال الطلب بنجاح',
      'order_failed': 'فشل إرسال الطلب',
      'delete_order': 'حذف الطلب',
      'delete_order_confirm': 'هل أنت متأكد من حذف الطلب؟',
      'order_deleted': 'تم حذف الطلب',

      // ===== أزرار =====
      'delete': 'حذف',
      'cancel': 'إلغاء',
      'logout':'تسجيل الخروج',

      // ===== السعر =====
      'price_currency': 'ر.ي',
      'currency': 'ر.ي',
    },

    // ================= English =================
    'en': {
      // ===== General =====
      'home_title': 'Walle Gallery',
      'orders': 'My Orders',
      'add_painting': 'Add Painting',
      'logout': 'Logout',
      'login': 'Login',
      'register': 'Create Account',
      'email': 'Email',
      'password': 'Password',
      'success': 'Success',
      'error': 'Error',

      // ===== Language =====
      'change_language': 'Change Language',
      'arabic': 'Arabic',
      'english': 'English',

      // ===== Paintings =====
      'no_paintings': 'No paintings yet',
      'painting_details': 'Painting Details',
      'description': 'Description',
      'order_painting': 'Order Painting',

      // ===== Orders =====
      'no_orders': 'No orders yet',
      'order_success': 'Order sent successfully',
      'order_failed': 'Order failed',
      'delete_order': 'Delete Order',
      'delete_order_confirm':
      'Are you sure you want to delete this order?',
      'order_deleted': 'Order deleted',

      // ===== Buttons =====
      'delete': 'Delete',
      'cancel': 'Cancel',

      // ===== Price =====
      'price_currency': 'YER',
      'currency': 'YER',
    },
  };
}