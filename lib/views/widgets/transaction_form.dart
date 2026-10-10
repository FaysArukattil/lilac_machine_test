import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/expense_controller.dart';
import '../../models/expense_model.dart';
import '../../utils/app_categories.dart';
import '../../utils/app_colors.dart';
import '../../utils/formatters.dart';
import '../../utils/snackbar_helper.dart';
import '../../utils/validators.dart';
import 'app_dropdown.dart';
import 'app_text_field.dart';
import 'primary_button.dart';

/// Shared by Add and Edit screens. Pass [initial] to edit.
class TransactionForm extends StatefulWidget {
  final ExpenseModel? initial;

  const TransactionForm({super.key, this.initial});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  static const _types = ['Expense', 'Income'];

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  String _type = 'Expense';
  late String _category;
  late DateTime _date;

  bool get _isEdit => widget.initial != null;
  bool get _isIncome => _type == 'Income';
  List<String> get _categories => AppCategories.forType(_isIncome);

  @override
  void initState() {
    super.initState();
    final e = widget.initial;
    if (e != null) {
      _nameCtrl.text = e.title;
      _amountCtrl.text = e.amount.toString();
      _descCtrl.text = e.description ?? '';
      _type = e.isIncome ? 'Income' : 'Expense';
      _date = e.date;
      _category = _categories.contains(e.category)
          ? e.category
          : _categories.first;
    } else {
      _date = DateTime.now();
      _category = _categories.first;
    }
    _dateCtrl.text = Formatters.formDate(_date);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _amountCtrl.dispose();
    _dateCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _date = picked;
        _dateCtrl.text = Formatters.formDate(picked);
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = Get.find<ExpenseController>();
    final desc = _descCtrl.text.trim();

    final model = ExpenseModel(
      id: widget.initial?.id,
      title: _nameCtrl.text.trim(),
      amount: double.parse(_amountCtrl.text.trim()),
      type: _isIncome ? TransactionType.income : TransactionType.expense,
      category: _category,
      date: _date,
      description: desc.isEmpty ? null : desc,
    );

    final ok = _isEdit
        ? await controller.updateTransaction(model)
        : await controller.addTransaction(model);

    if (ok) {
      Get.back();
      AppSnack.show(
        'Success',
        _isEdit ? 'Transaction updated' : 'Transaction added',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    AppDropdown(
                      label: 'Transaction Type',
                      value: _type,
                      items: _types,
                      onChanged: (v) => setState(() {
                        _type = v;
                        _category = _categories.first;
                      }),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Name',
                      controller: _nameCtrl,
                      validator: (v) => Validators.required(v, 'Name'),
                    ),
                    const SizedBox(height: 16),
                    AppDropdown(
                      label: 'Category',
                      value: _category,
                      items: _categories,
                      onChanged: (v) => setState(() => _category = v),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Amount',
                      controller: _amountCtrl,
                      prefixText: '₹ ',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}'),
                        ),
                      ],
                      validator: Validators.amount,
                      suffix: TextButton(
                        onPressed: _amountCtrl.clear,
                        child: const Text(
                          'Clear',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textLight,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Date',
                      controller: _dateCtrl,
                      readOnly: true,
                      onTap: _pickDate,
                      validator: (v) => Validators.required(v, 'Date'),
                      suffix: const Icon(
                        Icons.calendar_month_outlined,
                        size: 20,
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Description (optional)',
                      controller: _descCtrl,
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: PrimaryButton(text: 'Save', onPressed: _save),
          ),
        ),
      ],
    );
  }
}
