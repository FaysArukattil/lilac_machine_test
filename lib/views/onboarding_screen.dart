// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_keys.dart';
import '../utils/app_colors.dart';
import 'main_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              color: AppColors.onboardingBg,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Image.asset(
                    'assets/images/asset_onboarding.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.person,
                      size: 120,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Spend Smarter\nSave More',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        height: 1.15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool(AppKeys.onboardingSeen, true);
                          Get.off(() => const MainScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 6,
                          shadowColor: AppColors.primary.withValues(alpha: 0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
