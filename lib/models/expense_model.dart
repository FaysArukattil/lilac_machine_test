class TransactionType {
  static const String income = 'income';
  static const String expense = 'expense';
}

class ExpenseModel {
  final int? id;
  final String title;
  final double amount;
  final String type; // 'income' or 'expense'
  final String category;
  final DateTime date;
  final String? description; // optional

  const ExpenseModel({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.description,
  });

  bool get isIncome => type == TransactionType.income;

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'title': title,
    'amount': amount,
    'type': type,
    'category': category,
    'date': date.toIso8601String(),
    'description': description,
  };

  factory ExpenseModel.fromMap(Map<String, dynamic> map) => ExpenseModel(
    id: map['id'] as int?,
    title: map['title'] as String,
    amount: (map['amount'] as num).toDouble(),
    type: map['type'] as String,
    category: (map['category'] as String?) ?? 'Other',
    date: DateTime.parse(map['date'] as String),
    description: map['description'] as String?,
  );
}
