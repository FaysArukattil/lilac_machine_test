import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';

Future<bool> showConfirmDialog({
  required String title,
  required String message,
  String confirmText = 'Delete',
}) async {
  final result = await Get.dialog<bool>(
    AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Get.back(result: true),
          child: Text(confirmText,
              style: const TextStyle(color: AppColors.expense)),
        ),
      ],
    ),
  );
  return result ?? false;
}
