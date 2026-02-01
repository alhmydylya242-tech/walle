import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final AuthController controller = Get.find();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> handleRegister() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar('تنبيه', 'جميع الحقول مطلوبة');
      return;
    }

    if (password.length < 6) {
      Get.snackbar('خطأ', 'كلمة المرور 6 أحرف على الأقل');
      return;
    }

    setState(() => isLoading = true);
    await controller.register(
      name: name,
      email: email,
      password: password,
    );
    setState(() => isLoading = false);
  }

  InputDecoration _decoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF6B4F4F)),
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
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF5EFE6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'إنشاء حساب',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A2C2A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'أنشئ حسابك واستمتع بالفن ',
                style: TextStyle(color: Colors.brown),
              ),
              const SizedBox(height: 40),

              TextField(
                controller: nameController,
                decoration: _decoration('الاسم', Icons.person),
              ),
              const SizedBox(height: 18),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration:
                _decoration('البريد الإلكتروني', Icons.email),
              ),
              const SizedBox(height: 18),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration:
                _decoration('كلمة المرور', Icons.lock),
              ),
              const SizedBox(height: 36),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : handleRegister,
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
                    'إنشاء حساب',
                    style: TextStyle(color: Colors.white),
                  ),),),

              const SizedBox(height: 24),

              Center(
                child: TextButton(
                  onPressed: () => Get.offNamed('/login'),
                  child: const Text(
                    'لديك حساب؟ تسجيل الدخول',
                    style: TextStyle(
                      color: Color(0xFF6B4F4F),
                      fontWeight: FontWeight.bold,
                    ),),),),],
          ),),),);}}