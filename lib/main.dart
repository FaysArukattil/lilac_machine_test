import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lilac_machine_test/utils/app_colors.dart';
import 'package:lilac_machine_test/views/splash_screen.dart';

import 'controllers/expense_controller.dart';
import 'controllers/nav_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(NavController());
  Get.put(ExpenseController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Expenzia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
      home: const SplashScreen(),
    );
  }
}
