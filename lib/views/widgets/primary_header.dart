import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_colors.dart';

/// Teal top bar used on every inner screen.
/// Pass [onBack] to show the back arrow.
class PrimaryHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;

  const PrimaryHeader({super.key, required this.title, this.onBack});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        width: double.infinity,
        color: AppColors.primary,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: SizedBox(
          height: 80,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (onBack != null)
                Positioned(
                  left: 8,
                  child: IconButton(
                    onPressed: onBack,
                    icon: const Icon(Icons.chevron_left,
                        color: Colors.white, size: 30),
                  ),
                ),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
