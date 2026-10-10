import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';

class EmptyState extends StatelessWidget {
  final String message;

  const EmptyState({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long_outlined,
                size: 56, color: AppColors.primary.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            Text(message, style: AppStyles.subtitle),
          ],
        ),
      ),
    );
  }
}
