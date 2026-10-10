import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/expense_controller.dart';
import 'widgets/empty_state.dart';
import 'widgets/expense_tile.dart';
import 'widgets/primary_header.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ExpenseController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const PrimaryHeader(title: 'Transaction History'),
          Expanded(
            child: Obx(() {
              if (c.transactions.isEmpty) {
                return const EmptyState(message: 'No transactions yet');
              }
              return ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 60),
                itemCount: c.transactions.length,
                itemBuilder: (_, i) => ExpenseTile(item: c.transactions[i]),
              );
            }),
          ),
        ],
      ),
    );
  }
}
