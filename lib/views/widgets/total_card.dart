import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/formatters.dart';

class TotalCard extends StatelessWidget {
  final double balance;
  final double income;
  final double expense;

  const TotalCard({
    super.key,
    required this.balance,
    required this.income,
    required this.expense,
  });

  Widget _stat(IconData icon, String label, double amount,
      {bool alignEnd = false}) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white70),
              ),
              child: Icon(icon, size: 12, color: Colors.white),
            ),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          Formatters.currency(amount),
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Total Balance',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              Formatters.currency(balance),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _stat(Icons.arrow_downward, 'Income', income),
              _stat(Icons.arrow_upward, 'Expenses', expense, alignEnd: true),
            ],
          ),
        ],
      ),
    );
  }
}
