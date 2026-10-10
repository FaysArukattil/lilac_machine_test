import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/database_helper.dart';
import '../models/credit_model.dart';
import '../models/expense_model.dart';
import '../utils/app_keys.dart';
import '../utils/snackbar_helper.dart';

class ExpenseController extends GetxController {
  static const _defaultName = 'Sahal Muhammed';

  final DatabaseHelper _db = DatabaseHelper.instance;

  final transactions = <ExpenseModel>[].obs;
  final credits = <CreditModel>[].obs;
  final userName = _defaultName.obs;
  final profileImagePath = RxnString(); // null = no photo
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAll();
  }

  // ---------- Totals (read inside Obx) ----------
  double get totalIncome => transactions
      .where((t) => t.isIncome)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => transactions
      .where((t) => !t.isIncome)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get balance => totalIncome - totalExpense;

  double get dailyAverage {
    final expenses = transactions.where((t) => !t.isIncome).toList();
    if (expenses.isEmpty) return 0;
    final first = expenses
        .map((t) => t.date)
        .reduce((a, b) => a.isBefore(b) ? a : b);
    final start = DateTime(first.year, first.month, first.day);
    final days = DateTime.now().difference(start).inDays + 1;
    return totalExpense / (days < 1 ? 1 : days);
  }

  double get weeklyExpense {
    final from = DateTime.now().subtract(const Duration(days: 7));
    return transactions
        .where((t) => !t.isIncome && t.date.isAfter(from))
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  // ---------- Load ----------
  Future<void> loadAll() async {
    isLoading.value = true;
    try {
      transactions.assignAll(await _db.getTransactions());
      credits.assignAll(await _db.getCredits());

      final prefs = await SharedPreferences.getInstance();
      userName.value = prefs.getString(AppKeys.userName) ?? _defaultName;

      // Profile photo: only the file name is stored, because the app
      // folder path can change between runs on iOS.
      final fileName = prefs.getString(AppKeys.profileImage);
      if (fileName != null) {
        final dir = await getApplicationDocumentsDirectory();
        final file = File(p.join(dir.path, fileName));
        profileImagePath.value = await file.exists() ? file.path : null;
      }
    } catch (_) {
      AppSnack.show('Error', 'Could not load data', error: true);
    } finally {
      isLoading.value = false;
    }
  }

  // ---------- Transactions ----------
  Future<bool> addTransaction(ExpenseModel e) async {
    try {
      await _db.insertTransaction(e);
      transactions.assignAll(await _db.getTransactions());
      return true;
    } catch (_) {
      AppSnack.show('Error', 'Could not save transaction', error: true);
      return false;
    }
  }

  Future<bool> updateTransaction(ExpenseModel e) async {
    try {
      await _db.updateTransaction(e);
      transactions.assignAll(await _db.getTransactions());
      return true;
    } catch (_) {
      AppSnack.show('Error', 'Could not update transaction', error: true);
      return false;
    }
  }

  Future<bool> deleteTransaction(int id) async {
    try {
      await _db.deleteTransaction(id);
      transactions.assignAll(await _db.getTransactions());
      return true;
    } catch (_) {
      AppSnack.show('Error', 'Could not delete transaction', error: true);
      return false;
    }
  }

  // ---------- Credits ----------
  Future<bool> addCredit(CreditModel c) async {
    try {
      await _db.insertCredit(c);
      credits.assignAll(await _db.getCredits());
      return true;
    } catch (_) {
      AppSnack.show('Error', 'Could not save credit', error: true);
      return false;
    }
  }

  Future<bool> deleteCredit(int id) async {
    try {
      await _db.deleteCredit(id);
      credits.assignAll(await _db.getCredits());
      return true;
    } catch (_) {
      AppSnack.show('Error', 'Could not delete credit', error: true);
      return false;
    }
  }

  // ---------- Profile ----------
  Future<void> updateName(String name) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppKeys.userName, name);
      userName.value = name;
    } catch (_) {
      AppSnack.show('Error', 'Could not save name', error: true);
    }
  }

  Future<void> pickProfileImage(ImageSource source) async {
    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        imageQuality: 85,
      );
      if (picked == null) return; // user cancelled

      final dir = await getApplicationDocumentsDirectory();
      final fileName =
          'profile_${DateTime.now().millisecondsSinceEpoch}${p.extension(picked.path)}';
      final saved = await File(picked.path).copy(p.join(dir.path, fileName));

      await _deleteOldImage();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppKeys.profileImage, fileName);
      profileImagePath.value = saved.path;
    } catch (_) {
      AppSnack.show('Error', 'Could not set profile photo', error: true);
    }
  }

  Future<void> removeProfileImage() async {
    try {
      await _deleteOldImage();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppKeys.profileImage);
      profileImagePath.value = null;
    } catch (_) {
      AppSnack.show('Error', 'Could not remove photo', error: true);
    }
  }

  Future<void> _deleteOldImage() async {
    final old = profileImagePath.value;
    if (old != null) {
      final f = File(old);
      if (await f.exists()) await f.delete();
    }
  }

  Future<bool> clearStorage() async {
    try {
      await _db.clearAll();
      await _deleteOldImage();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppKeys.userName);
      await prefs.remove(AppKeys.profileImage);
      transactions.clear();
      credits.clear();
      userName.value = _defaultName;
      profileImagePath.value = null;
      return true;
    } catch (_) {
      AppSnack.show('Error', 'Could not clear storage', error: true);
      return false;
    }
  }
}
