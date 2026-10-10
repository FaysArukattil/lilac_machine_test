import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../../controllers/expense_controller.dart';
import '../../models/expense_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/snackbar_helper.dart';
import '../edit_transaction_screen.dart';
import 'confirm_dialog.dart';
import 'expense_card.dart';

class ExpenseTile extends StatelessWidget {
  final ExpenseModel item;
  final double horizontalPadding;

  const ExpenseTile({
    super.key,
    required this.item,
    this.horizontalPadding = 20,
  });

  void _edit() => Get.to(() => EditTransactionScreen(transaction: item));

  Future<void> _delete() async {
    final ok = await showConfirmDialog(
      title: 'Delete transaction',
      message: 'Are you sure you want to delete "${item.title}"?',
    );
    if (!ok) return;
    final done = await Get.find<ExpenseController>().deleteTransaction(
      item.id!,
    );
    if (done) AppSnack.show('Deleted', 'Transaction removed');
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(item.id),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: 0.3,
        children: [
          SlidableAction(
            onPressed: (_) => _edit(),
            backgroundColor: const Color(0xFFEEEEEE),
            foregroundColor: AppColors.textDark,
            icon: Icons.edit,
          ),
          SlidableAction(
            onPressed: (_) => _delete(),
            backgroundColor: AppColors.expense,
            foregroundColor: Colors.white,
            icon: Icons.delete,
          ),
        ],
      ),
      child: InkWell(
        onTap: _edit,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: ExpenseCard(item: item),
        ),
      ),
    );
  }
}
