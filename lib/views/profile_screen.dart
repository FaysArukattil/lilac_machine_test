import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/expense_controller.dart';
import '../controllers/nav_controller.dart';
import '../utils/app_colors.dart';
import '../utils/snackbar_helper.dart';
import 'widgets/confirm_dialog.dart';
import 'widgets/edit_name_dialog.dart';
import 'widgets/primary_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _editName(ExpenseController c) async {
    final newName = await Get.dialog<String>(
      EditNameDialog(initial: c.userName.value),
    );
    if (newName != null && newName.isNotEmpty) {
      await c.updateName(newName);
    }
  }

  void _choosePhoto(ExpenseController c) {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Get.back();
                  c.pickProfileImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Take a photo'),
                onTap: () {
                  Get.back();
                  c.pickProfileImage(ImageSource.camera);
                },
              ),
              if (c.profileImagePath.value != null)
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline,
                    color: AppColors.expense,
                  ),
                  title: const Text(
                    'Remove photo',
                    style: TextStyle(color: AppColors.expense),
                  ),
                  onTap: () {
                    Get.back();
                    c.removeProfileImage();
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _clearStorage(ExpenseController c) async {
    final ok = await showConfirmDialog(
      title: 'Clear storage',
      message: 'This will delete all transactions and credits. Continue?',
      confirmText: 'Clear',
    );
    if (!ok) return;
    if (await c.clearStorage()) {
      AppSnack.show('Done', 'All data cleared');
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ExpenseController>();
    final nav = Get.find<NavController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          PrimaryHeader(title: 'Profile', onBack: () => nav.changeTab(0)),
          const SizedBox(height: 60),
          GestureDetector(
            onTap: () => _choosePhoto(c),
            child: Stack(
              children: [
                Obx(() {
                  final path = c.profileImagePath.value;
                  return CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade400,
                    backgroundImage: path != null
                        ? FileImage(File(path))
                        : null,
                    child: path == null
                        ? const Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.white,
                          )
                        : null,
                  );
                }),
                Positioned(
                  right: 0,
                  bottom: 4,
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.photo_camera,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  c.userName.value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => _editName(c),
                  child: const Icon(
                    Icons.edit,
                    size: 16,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => _clearStorage(c),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textLight,
              side: const BorderSide(color: AppColors.border),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text('Clear Storage'),
          ),
        ],
      ),
    );
  }
}
