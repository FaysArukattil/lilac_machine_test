import 'package:flutter/material.dart';

import '../../models/expense_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import '../../utils/formatters.dart';

/// One row in a transaction list.
class ExpenseCard extends StatelessWidget {
  final ExpenseModel item;

  const ExpenseCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final color = item.isIncome ? AppColors.income : AppColors.expense;
    final sign = item.isIncome ? '+' : '-';
    final hasDesc = item.description != null && item.description!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.title.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.category} • ${Formatters.listDate(item.date)}',
                  style: AppStyles.subtitle,
                ),
                if (hasDesc) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.description!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.subtitle,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$sign ${Formatters.currency(item.amount)}',
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
