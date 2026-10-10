import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/expense_model.dart';
import 'widgets/primary_header.dart';
import 'widgets/transaction_form.dart';

class EditTransactionScreen extends StatelessWidget {
  final ExpenseModel transaction;

  const EditTransactionScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          PrimaryHeader(title: 'Edit Transaction', onBack: () => Get.back()),
          Expanded(child: TransactionForm(initial: transaction)),
        ],
      ),
    );
  }
}
