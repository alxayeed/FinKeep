import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/styles/app_colors.dart';
import 'package:finkeep/features/lendings/presentation/controllers/lendings_controller.dart';
import 'package:finkeep/core/enums/payment_type.dart';

import '../../domain/entity/lending/lending_entity.dart';
import '../../domain/entity/lending_person/lending_person_entity.dart';
import '../widgets/lending_form_widget.dart';

class AddLendingScreen extends StatefulWidget {
  const AddLendingScreen({super.key});

  @override
  State<AddLendingScreen> createState() => _AddLendingScreenState();
}

class _AddLendingScreenState extends State<AddLendingScreen> {
  final LendingsController controller = Get.find();

  Future<void> _saveLending(
    double amount,
    String personName,
    String contact,
    LendingType type,
    LendingStatus status,
    DateTime createdDate,
    DateTime? dueDate,
    String? description,
    PaymentType paymentMethod,
  ) async {
    final lending = LendingEntity(
      id: '',
      personId: '',
      person: LendingPersonEntity(
        id: '',
        name: personName,
        contactNumber: contact.isEmpty ? null : contact,
      ),
      amount: amount,
      repaidAmount: 0.0,
      description: description,
      type: type,
      status: status,
      dueDate: dueDate,
      createdDate: createdDate,
      paymentMethod: paymentMethod,
    );

    await controller.addLending(
      lending,
      onSuccess: () {
        if (!mounted) return;
        _showSnack('Lending record saved!');
        context.pop();
      },
      onError: (e) {
        if (!mounted) return;
        _showSnack('Failed to save: $e', isError: true);
      },
    );
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? AppColors.error : AppColors.success,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Drag handle ──
            Center(
              child: Container(
                width: 38.w,
                height: 4.h,
                margin: EdgeInsets.only(top: 10.h, bottom: 8.h),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),

            // ── App bar row ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Row(
                      children: [
                        Icon(Icons.chevron_left, size: 22.sp, color: AppColors.primaryTeal),
                        Text(
                          'Back',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTeal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'New Record',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(width: 60.w),
                ],
              ),
            ),

            // ── Form ──
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Obx(() => LendingFormWidget(
                      submitButtonText: 'Save Record',
                      isLoading: controller.isLoading.value,
                      onSubmit: (amount, personName, contact, type, status, createdDate, dueDate, description, paymentMethod) {
                        _saveLending(amount, personName, contact, type, status, createdDate, dueDate, description, paymentMethod);
                      },
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
