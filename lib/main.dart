import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'controllers/auth_controller.dart';
import 'translations/localization.dart';

// ===== Views =====
import 'views/login_screen.dart';
import 'views/register_screen.dart';
import 'views/home_screen.dart';
import 'views/details_screen.dart';
import 'views/add_painting.dart';
import 'views/MyOrder_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ===== Supabase init =====
  await Supabase.initialize(
    url: 'https://oxvxtimlvwunkcztbiyf.supabase.co',
    anonKey:
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94dnh0aW1sdnd1bmtjenRiaXlmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njk5MzA0OTcsImV4cCI6MjA4NTUwNjQ5N30.-yDrMyqBfoxV8zjZ2kHM4ZrT3v1PJhrxF3R3hzd2dkQ',
  );

  // ===== Controllers =====
  Get.put(AuthController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      // Localization
      translations: Localization(),
      locale: const Locale('ar'),
      fallbackLocale: const Locale('en'),

      // ===== Routes =====
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginView()),
        GetPage(name: '/register', page: () => RegisterView()),
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(
            name: '/painting-details',
            page: () => PaintingDetailsScreen()),
        GetPage(name: '/orders', page: () => OrdersView()),
        GetPage(name: '/add-painting', page: () => AddPaintingView()),
      ],
    );
  }
}