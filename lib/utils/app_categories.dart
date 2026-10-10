class AppCategories {
  static const List<String> expense = [
    'Food',
    'Travel',
    'Shopping',
    'Bills',
    'Health',
    'Entertainment',
    'Other',
  ];

  static const List<String> income = [
    'Salary',
    'Freelance',
    'Investment',
    'Gift',
    'Other',
  ];

  static List<String> forType(bool isIncome) => isIncome ? income : expense;
}
