import 'package:flutter/material.dart';
import '../../utils/app_styles.dart';

class AppDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const AppDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: AppStyles.label),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          // ignore: deprecated_member_use
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down, size: 20),
          style: const TextStyle(fontSize: 14, color: Colors.black),
          decoration: AppStyles.input(),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ],
    );
  }
}
