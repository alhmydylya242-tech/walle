import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final AuthController controller = Get.find();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('تنبيه', 'الرجاء إدخال البريد وكلمة المرور');
      return;
    }

    setState(() => isLoading = true);
    await controller.login(email: email, password: password);
    setState(() => isLoading = false);
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF6B4F4F)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 18),
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
                'تسجيل الدخول',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A2C2A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'مرحبًا بك إلى Walle Gallery ',
                style: TextStyle(color: Colors.brown),
              ),

              const SizedBox(height: 40),

              // ===== Email =====
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration:
                _inputDecoration('البريد الإلكتروني', Icons.email),
              ),

              const SizedBox(height: 18),

              // ===== Password =====
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration:
                _inputDecoration('كلمة المرور', Icons.lock),
              ),

              const SizedBox(height: 36),

              // ===== Login Button =====
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : handleLogin,
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
                    'تسجيل الدخول',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Register
              Center(
                child: TextButton(
                  onPressed: () => Get.toNamed('/register'),
                  child: const Text(
                    'ليس لديك حساب؟ إنشاء حساب جديد',
                    style: TextStyle(
                      color: Color(0xFF6B4F4F),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}