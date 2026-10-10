import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppStyles {
  static const TextStyle label = TextStyle(
    fontSize: 11,
    letterSpacing: 0.8,
    fontWeight: FontWeight.w500,
    color: AppColors.textLight,
  );

  static const TextStyle title = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 12,
    color: AppColors.textLight,
  );

  static OutlineInputBorder _border(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: color, width: width),
      );

  static InputDecoration input({String? prefixText, Widget? suffix}) =>
      InputDecoration(
        prefixText: prefixText,
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: _border(AppColors.border),
        enabledBorder: _border(AppColors.border),
        focusedBorder: _border(AppColors.primary, 1.5),
        errorBorder: _border(AppColors.expense),
        focusedErrorBorder: _border(AppColors.expense, 1.5),
      );
}
