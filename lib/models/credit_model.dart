class CreditModel {
  final int? id;
  final String creditType; // Subscriptions, Bills, Loan, Other
  final String toName;
  final double amount;
  final String planType; // Monthly or One-Time
  final DateTime date; // due date

  const CreditModel({
    this.id,
    required this.creditType,
    required this.toName,
    required this.amount,
    required this.planType,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'credit_type': creditType,
        'to_name': toName,
        'amount': amount,
        'plan_type': planType,
        'date': date.toIso8601String(),
      };

  factory CreditModel.fromMap(Map<String, dynamic> map) => CreditModel(
        id: map['id'] as int?,
        creditType: map['credit_type'] as String,
        toName: map['to_name'] as String,
        amount: (map['amount'] as num).toDouble(),
        planType: map['plan_type'] as String,
        date: DateTime.parse(map['date'] as String),
      );
}
