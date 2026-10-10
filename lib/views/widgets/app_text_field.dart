import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/app_styles.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? prefixText;
  final Widget? suffix;
  final int maxLines;

  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.readOnly = false,
    this.onTap,
    this.prefixText,
    this.suffix,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: AppStyles.label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          readOnly: readOnly,
          onTap: onTap,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 14),
          decoration: AppStyles.input(prefixText: prefixText, suffix: suffix),
        ),
      ],
    );
  }
}
