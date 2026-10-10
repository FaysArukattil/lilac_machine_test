import 'package:intl/intl.dart';

class Formatters {
  static final NumberFormat _currency = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static String currency(double value) => _currency.format(value);

  /// Form fields: Tue, 22 Feb 2026
  static String formDate(DateTime d) => DateFormat('EEE, dd MMM yyyy').format(d);

  /// Lists: Today / Yesterday / Jan 30, 2022
  static String listDate(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(d.year, d.month, d.day);
    final diff = today.difference(day).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return DateFormat('MMM d, yyyy').format(d);
  }

  static bool isToday(DateTime d) {
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }

  /// Credit list: Due Today / Due On 10/12/26
  static String dueDate(DateTime d) =>
      isToday(d) ? 'Due Today' : 'Due On ${DateFormat('dd/MM/yy').format(d)}';
}
