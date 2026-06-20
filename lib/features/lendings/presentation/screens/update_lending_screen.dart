import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:spendly/core/responsive/responsive.dart';
import 'package:spendly/core/styles/app_colors.dart';
import 'package:spendly/core/enums/payment_type.dart';

import '../../../../core/routes/app_router.dart';
import '../../domain/entity/lending/lending_entity.dart';
import '../controllers/lendings_controller.dart';
import '../widgets/lending_form_widget.dart';

class UpdateLendingScreen extends StatefulWidget {
  final LendingEntity lending;

  const UpdateLendingScreen({super.key, required this.lending});

  @override
  State<UpdateLendingScreen> createState() => _UpdateLendingScreenState();
}

class _UpdateLendingScreenState extends State<UpdateLendingScreen> {
  final LendingsController controller = Get.find<LendingsController>();

  Future<void> _update(
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
    final updated = LendingEntity(
      id: widget.lending.id,
      personId: widget.lending.person.id,
      person: widget.lending.person,
      amount: amount,
      repaidAmount: widget.lending.repaidAmount,
      description: description,
      type: type,
      status: status,
      createdDate: createdDate,
      dueDate: dueDate,
      paymentMethod: paymentMethod,
      repayments: widget.lending.repayments,
    );

    await controller.updateLending(
      updated,
      onSuccess: () {
        if (!mounted) return;
        _showSnack('Lending record updated!');
        context.pop();
        context.pushReplacementNamed(AppRoutes.lendings);
      },
      onError: (e) {
        if (!mounted) return;
        _showSnack('Failed to update: $e', isError: true);
      },
    );
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.cardDark : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          title: Text(
            'Delete Record?',
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          content: Text(
            'This will permanently remove the lending record for ${widget.lending.person.name}. This action cannot be undone.',
            style: TextStyle(
              fontSize: 13.sp,
              fontFamily: 'Manrope',
              color: isDark ? Colors.white60 : const Color(0xFF64748B),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDark ? Colors.white54 : const Color(0xFF64748B),
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(
                'Delete',
                style: TextStyle(
                  color: AppColors.error,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    await controller.deleteLending(
      widget.lending.id,
      onSuccess: () {
        if (!mounted) return;
        _showSnack('Record deleted.');
        context.pop();
        context.pushReplacementNamed(AppRoutes.lendings);
      },
      onError: (e) {
        if (!mounted) return;
        _showSnack('Failed to delete: $e', isError: true);
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
                    'Edit Record',
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
                child: Obx(() => Column(
                      children: [
                        LendingFormWidget(
                          initialLending: widget.lending,
                          submitButtonText: 'Update Record',
                          isLoading: controller.isLoading.value,
                          onSubmit: (amount, personName, contact, type, status, createdDate, dueDate, description, paymentMethod) {
                            _update(amount, personName, contact, type, status, createdDate, dueDate, description, paymentMethod);
                          },
                        ),
                        // ── Delete Record button ──
                        GestureDetector(
                          onTap: _confirmDelete,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.delete_outline_rounded, size: 18.sp, color: AppColors.error),
                                SizedBox(width: 6.w),
                                Text(
                                  'Delete Record',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontFamily: 'Manrope',
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 32.h),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
