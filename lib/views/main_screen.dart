import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/nav_controller.dart';
import '../utils/app_colors.dart';
import 'add_transaction_screen.dart';
import 'credit_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'transaction_history_screen.dart';

/// Shell with the bottom nav bar. Tabs: Home, History, Credit, Profile.
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = Get.find<NavController>();

    const pages = [
      HomeScreen(),
      TransactionHistoryScreen(),
      CreditScreen(),
      ProfileScreen(),
    ];

    Widget item(IconData icon, int index) {
      return Expanded(
        child: Obx(() => IconButton(
              onPressed: () => nav.changeTab(index),
              icon: Icon(
                icon,
                size: 28,
                color: nav.index.value == index
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.5),
              ),
            )),
      );
    }

    return Scaffold(
      body: Obx(() => IndexedStack(index: nav.index.value, children: pages)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddTransactionScreen()),
        backgroundColor: AppColors.primary,
        elevation: 4,
        shape: const CircleBorder(
          side: BorderSide(color: Colors.white, width: 5),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.primary,
        surfaceTintColor: Colors.transparent,
        height: 70,
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            item(Icons.home_outlined, 0),
            item(Icons.history, 1),
            const SizedBox(width: 72), // space for the + button
            item(Icons.account_balance_wallet_outlined, 2),
            item(Icons.person_outline, 3),
          ],
        ),
      ),
    );
  }
}
