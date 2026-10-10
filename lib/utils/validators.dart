class Validators {
  static String? required(String? value, String field) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    return null;
  }

  static String? amount(String? value) {
    if (value == null || value.trim().isEmpty) return 'Amount is required';
    final number = double.tryParse(value.trim());
    if (number == null) return 'Enter a valid number';
    if (number <= 0) return 'Amount must be greater than 0';
    return null;
  }
}
