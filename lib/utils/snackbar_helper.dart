import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_colors.dart';

class AppSnack {
  static void show(String title, String message, {bool error = false}) {
    if (Get.overlayContext == null) return; // app not ready yet
    try {
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: error ? AppColors.expense : AppColors.primary,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
    } catch (_) {}
  }
}
