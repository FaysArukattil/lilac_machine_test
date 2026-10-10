import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import '../controllers/expense_controller.dart';
import '../models/credit_model.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../utils/formatters.dart';
import '../utils/snackbar_helper.dart';
import '../utils/validators.dart';
import 'widgets/app_dropdown.dart';
import 'widgets/app_text_field.dart';
import 'widgets/confirm_dialog.dart';
import 'widgets/empty_state.dart';
import 'widgets/primary_button.dart';
import 'widgets/primary_header.dart';

class CreditScreen extends StatefulWidget {
  const CreditScreen({super.key});

  @override
  State<CreditScreen> createState() => _CreditScreenState();
}

class _CreditScreenState extends State<CreditScreen> {
  static const _creditTypes = ['Subscriptions', 'Bills', 'Loan', 'Other'];
  static const _planTypes = ['Monthly', 'One-Time'];

  final _formKey = GlobalKey<FormState>();
  final _toCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();

  String _creditType = _creditTypes.first;
  String _planType = _planTypes.first;
  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    _dateCtrl.text = Formatters.formDate(_date);
  }

  @override
  void dispose() {
    _toCtrl.dispose();
    _amountCtrl.dispose();
    _dateCtrl.dispose();
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
    FocusScope.of(context).unfocus();

    final ok = await Get.find<ExpenseController>().addCredit(
      CreditModel(
        creditType: _creditType,
        toName: _toCtrl.text.trim(),
        amount: double.parse(_amountCtrl.text.trim()),
        planType: _planType,
        date: _date,
      ),
    );

    if (ok) {
      _toCtrl.clear();
      _amountCtrl.clear();
      _formKey.currentState!.reset();
      setState(() {
        _creditType = _creditTypes.first;
        _planType = _planTypes.first;
        _date = DateTime.now();
        _dateCtrl.text = Formatters.formDate(_date);
      });
      AppSnack.show('Success', 'Credit saved');
    }
  }

  Future<void> _delete(CreditModel c) async {
    final ok = await showConfirmDialog(
      title: 'Delete credit',
      message: 'Are you sure you want to delete "${c.toName}"?',
    );
    if (!ok) return;
    final done = await Get.find<ExpenseController>().deleteCredit(c.id!);
    if (done) AppSnack.show('Deleted', 'Credit removed');
  }

  Widget _savedItem(CreditModel c) {
    final due = Formatters.dueDate(c.date);
    final isToday = Formatters.isToday(c.date);

    return Slidable(
      key: ValueKey(c.id),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: 0.18,
        children: [
          SlidableAction(
            onPressed: (_) => _delete(c),
            backgroundColor: AppColors.expense,
            foregroundColor: Colors.white,
            icon: Icons.delete,
          ),
        ],
      ),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.toName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.title.copyWith(fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(
                    due,
                    style: AppStyles.subtitle.copyWith(
                        color: isToday ? AppColors.expense : null),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(c.planType, style: AppStyles.subtitle),
                const SizedBox(height: 2),
                Text(
                  Formatters.currency(c.amount),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ExpenseController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const PrimaryHeader(title: 'Credit'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AppDropdown(
                          label: 'Credit Type',
                          value: _creditType,
                          items: _creditTypes,
                          onChanged: (v) => setState(() => _creditType = v),
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: 'To',
                          controller: _toCtrl,
                          validator: (v) => Validators.required(v, 'Name'),
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: 'Amount',
                          controller: _amountCtrl,
                          prefixText: '₹ ',
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          validator: Validators.amount,
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: 'Date',
                          controller: _dateCtrl,
                          readOnly: true,
                          onTap: _pickDate,
                          validator: (v) => Validators.required(v, 'Date'),
                          suffix: const Icon(Icons.calendar_month_outlined,
                              size: 20, color: AppColors.textLight),
                        ),
                        const SizedBox(height: 16),
                        AppDropdown(
                          label: 'Plan Type',
                          value: _planType,
                          items: _planTypes,
                          onChanged: (v) => setState(() => _planType = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(text: 'Save', onPressed: _save),
                  const SizedBox(height: 28),
                  const Text('Your Saved Lists', style: AppStyles.title),
                  const SizedBox(height: 8),
                  Obx(() {
                    if (c.credits.isEmpty) {
                      return const EmptyState(message: 'No saved credits yet');
                    }
                    return Column(
                      children: c.credits.map(_savedItem).toList(),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
