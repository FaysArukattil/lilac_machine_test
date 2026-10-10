import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/expense_controller.dart';
import '../controllers/nav_controller.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../utils/formatters.dart';
import 'widgets/empty_state.dart';
import 'widgets/expense_tile.dart';
import 'widgets/total_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  Widget _statBox(String label, double amount) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppStyles.label),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                Formatters.currency(amount),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ExpenseController>();
    final nav = Get.find<NavController>();

    return SafeArea(
      bottom: false,
      child: Obx(() {
        final recent = c.transactions.take(5).toList();

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
          children: [
            Text('${_greeting()},', style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 2),
            Text(
              c.userName.value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            TotalCard(
              balance: c.balance,
              income: c.totalIncome,
              expense: c.totalExpense,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                _statBox('DAILY AVERAGE', c.dailyAverage),
                const SizedBox(width: 16),
                _statBox('WEEKLY', c.weeklyExpense),
              ],
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Transactions History',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                  onTap: () => nav.changeTab(1),
                  child: const Text('See all', style: AppStyles.subtitle),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (recent.isEmpty)
              const EmptyState(message: 'No transactions yet')
            else
              ...recent.map((t) => ExpenseTile(item: t, horizontalPadding: 0)),
          ],
        );
      }),
    );
  }
}
