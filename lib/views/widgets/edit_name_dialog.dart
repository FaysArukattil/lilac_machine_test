import 'package:flutter/material.dart';

class EditNameDialog extends StatefulWidget {
  final String initial;

  const EditNameDialog({super.key, required this.initial});

  @override
  State<EditNameDialog> createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<EditNameDialog> {
  late final TextEditingController _ctrl = TextEditingController(
    text: widget.initial,
  );

  @override
  void dispose() {
    _ctrl.dispose(); // safe: the dialog widget owns it
    super.dispose();
  }

  void _save() {
    final name = _ctrl.text.trim();
    if (name.isEmpty) return;
    Navigator.of(context).pop(name);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit name'),
      content: TextField(
        controller: _ctrl,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(hintText: 'Your name'),
        onSubmitted: (_) => _save(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
