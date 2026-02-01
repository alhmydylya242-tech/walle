import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final supabase = Supabase.instance.client;

  var userName = ''.obs;
  var userRole = 'user'.obs;

  // ===== Register =====
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          'role': 'user', // افتراضي
        },
      );

      if (res.user != null) {
        userName.value = name;
        userRole.value = 'user';

        Get.snackbar('نجاح', 'تم إنشاء الحساب بنجاح');
        Get.offAllNamed('/home');
      }
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    }
  }

  // ===== Login =====
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = res.user;

      if (user != null) {
        userName.value = user.userMetadata?['name'] ?? '';
        userRole.value = user.userMetadata?['role'] ?? 'user';

        Get.offAllNamed('/home');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'بيانات الدخول غير صحيحة');
    }
  }

  // ===== Logout =====
  Future<void> logout() async {
    await supabase.auth.signOut();
    userName.value = '';
    userRole.value = 'user';
  }
}