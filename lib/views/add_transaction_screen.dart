import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/primary_header.dart';
import 'widgets/transaction_form.dart';

class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          PrimaryHeader(title: 'Transaction', onBack: () => Get.back()),
          const Expanded(child: TransactionForm()),
        ],
      ),
    );
  }
}
