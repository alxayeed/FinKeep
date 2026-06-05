import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spendly/core/extensions/double_ext.dart';
import 'package:spendly/core/responsive/responsive.dart';
import 'package:spendly/core/styles/app_colors.dart';


import 'package:spendly/core/common/widgets/widgets.dart';

import '../../../auth/presentation/controller/auth_controller.dart';
import '../../domain/entity/lending/lending_entity.dart';
import '../../domain/entity/repayment/repayment_entity.dart';
import '../controllers/lendings_controller.dart';
import '../widgets/repayment_shimmer_list.dart';

class RepaymentListWidget extends StatefulWidget {
  final LendingEntity lending;

  const RepaymentListWidget({super.key, required this.lending});

  @override
  State<RepaymentListWidget> createState() => _RepaymentListWidgetState();
}

class _RepaymentListWidgetState extends State<RepaymentListWidget> {
  final LendingsController controller = Get.find<LendingsController>();

  @override
  void initState() {
    super.initState();
    controller.fetchRepayments(widget.lending.id);
  }


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header ──────────────────────────────────────
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Repayment History',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              // Plus button for adding repayments
              GestureDetector(
                onTap: () => _showRepaymentSheet(context),
                child: Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    color: AppColors.primaryTeal,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryTeal.withValues(alpha: 0.2),
                        blurRadius: 4.r,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.add_rounded,
                    size: 20.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── List ────────────────────────────────────────────────
        Obx(() {
          if (controller.isRepaymentsLoading.value) {
            return const RepaymentShimmerList();
          }
          if (controller.repaymentsList.isEmpty) {
            return _buildEmptyState(isDark);
          }

          // Show origin record at bottom + repayments sorted newest first
          final repayments = controller.repaymentsList.toList()
            ..sort((a, b) => b.paidDate.compareTo(a.paidDate));

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: repayments.length + 1, // +1 for origin row
            itemBuilder: (context, index) {
              // Last item = origin/created row
              if (index == repayments.length) {
                return _buildOriginTile(isDark, repayments.length + 1);
              }
              final repayment = repayments[index];
              return _buildRepaymentTile(repayment, index, repayments.length + 1, isDark);
            },
          );
        }),

        SizedBox(height: 24.h),
      ],
    );
  }

  // ── Helper functions for Timeline ─────────────────────────────
  String _ordinal(int number) {
    if (number <= 0) return '';
    final remainder10 = number % 10;
    final remainder100 = number % 100;
    if (remainder10 == 1 && remainder100 != 11) {
      return '${number}st';
    }
    if (remainder10 == 2 && remainder100 != 12) {
      return '${number}nd';
    }
    if (remainder10 == 3 && remainder100 != 13) {
      return '${number}rd';
    }
    return '${number}th';
  }

  Widget _buildTimelineRow({
    required int index,
    required int totalItems,
    required bool isDark,
    required Widget indicator,
    required Widget child,
  }) {
    final showTopLine = index > 0;
    final showBottomLine = index < totalItems - 1;
    final lineColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left timeline column
          SizedBox(
            width: 48.w,
            child: Column(
              children: [
                // Top line
                Expanded(
                  child: Container(
                    width: 2.w,
                    color: showTopLine ? lineColor : Colors.transparent,
                  ),
                ),
                // Indicator dot
                indicator,
                // Bottom line
                Expanded(
                  child: Container(
                    width: 2.w,
                    color: showBottomLine ? lineColor : Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
          // Right details card
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  // ── Individual repayment tile ─────────────────────────────────
  Widget _buildRepaymentTile(
      RepaymentEntity repayment, int index, int totalItems, bool isDark) {
    final dateText =
        DateFormat('MMM dd, yyyy').format(repayment.paidDate);

    final tileContent = GestureDetector(
      onTap: () => _showRepaymentSheet(context, repayment: repayment),
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDark
                ? const Color(0xFF334155)
                : const Color(0xFFF1F5F9),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    repayment.notes?.isNotEmpty == true
                        ? repayment.notes!
                        : 'Repayment',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    dateText,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? Colors.white38
                          : const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '+',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryTeal,
                  ),
                ),
                Text(
                  '${repayment.amount.toCurrency()} ৳',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryTeal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    final totalRepayments = totalItems - 1;
    final chronoIndex = totalRepayments - index;
    final text = _ordinal(chronoIndex);

    final indicator = Container(
      width: 28.r,
      height: 28.r,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F2D2A) : const Color(0xFFECFDF5),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primaryTeal.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9.sp,
          fontFamily: 'Manrope',
          fontWeight: FontWeight.bold,
          color: AppColors.primaryTeal,
        ),
      ),
    );

    return Dismissible(
      key: ValueKey(repayment.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.only(right: 20.w),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(16.r),
        ),
        alignment: Alignment.centerRight,
        child: Icon(Icons.delete_outline_rounded,
            color: Colors.white, size: 22.sp),
      ),
      confirmDismiss: (dir) async {
        final confirmed = await _confirmDeleteRepayment(repayment);
        if (confirmed != true) return false;

        bool deleteSuccess = false;
        await controller.deleteRepayment(
          repayment,
          onSuccess: () {
            deleteSuccess = true;
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Repayment deleted successfully!'),
                backgroundColor: AppColors.success,
              ),
            );
          },
          onError: (err) {
            deleteSuccess = false;
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to delete repayment: $err'),
                backgroundColor: AppColors.error,
              ),
            );
          },
        );
        return deleteSuccess;
      },
      onDismissed: (_) {},
      child: _buildTimelineRow(
        index: index,
        totalItems: totalItems,
        isDark: isDark,
        indicator: indicator,
        child: tileContent,
      ),
    );
  }

  // ── Origin / created tile ─────────────────────────────────────
  Widget _buildOriginTile(bool isDark, int totalItems) {
    final tileContent = Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111C2B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lending Record Created',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  DateFormat('MMM dd, yyyy')
                      .format(widget.lending.createdDate),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontFamily: 'Manrope',
                    color: isDark
                        ? Colors.white24
                        : const Color(0xFFCBD5E1),
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Originated',
            style: TextStyle(
              fontSize: 11.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white24 : const Color(0xFFCBD5E1),
            ),
          ),
        ],
      ),
    );

    final indicator = Container(
      width: 28.r,
      height: 28.r,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.flag_rounded,
        size: 13.sp,
        color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
      ),
    );

    return _buildTimelineRow(
      index: totalItems - 1,
      totalItems: totalItems,
      isDark: isDark,
      indicator: indicator,
      child: tileContent,
    );
  }

  // ── Empty state ───────────────────────────────────────────────
  Widget _buildEmptyState(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined,
                size: 48.sp,
                color: isDark ? Colors.white10 : Colors.black12),
            SizedBox(height: 12.h),
            Text(
              'No repayments yet',
              style: TextStyle(
                fontSize: 13.sp,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Tap "Add Repayment" below to record a payment',
              style: TextStyle(
                fontSize: 11.sp,
                fontFamily: 'Manrope',
                color: isDark ? Colors.white24 : const Color(0xFFCBD5E1),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ── Delete confirmation ───────────────────────────────────────
  Future<bool> _confirmDeleteRepayment(RepaymentEntity repayment) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.cardDark : Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text('Delete Repayment?',
            style: TextStyle(
                fontSize: 16.sp,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A))),
        content: Text(
          'Remove this repayment of ${repayment.amount.toCurrency()} ৳?',
          style: TextStyle(
              fontSize: 13.sp,
              fontFamily: 'Manrope',
              color: isDark ? Colors.white60 : const Color(0xFF64748B)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel',
                style: TextStyle(
                    color: isDark ? Colors.white54 : const Color(0xFF64748B),
                    fontFamily: 'Manrope')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Delete',
                style: TextStyle(
                    color: AppColors.error,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  // ── Add / Edit repayment bottom sheet ─────────────────────────
  void _showRepaymentSheet(BuildContext context,
      {RepaymentEntity? repayment}) {
    final isEdit = repayment != null;
    final amountCtrl =
        TextEditingController(text: repayment?.amount.toString() ?? '');
    final notesCtrl =
        TextEditingController(text: repayment?.notes ?? '');
    final dateObs = Rx<DateTime?>(repayment?.paidDate ?? DateTime.now());
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        final isDark =
            Theme.of(modalContext).brightness == Brightness.dark;

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(modalContext).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            padding: EdgeInsets.only(
              left: 24.w,
              right: 24.w,
              top: 0,
              bottom: MediaQuery.of(modalContext).padding.bottom + 32.h,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 38.w,
                      height: 4.h,
                      margin: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),

                  // Title
                  Text(
                    isEdit ? 'Edit Repayment' : 'Add Repayment',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Amount input field
                  StyledAmountField(
                    controller: amountCtrl,
                    labelText: 'Amount Paid',
                    autofocus: !isEdit,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Enter an amount';
                      }
                      if (double.tryParse(val) == null ||
                          double.parse(val) <= 0) {
                        return 'Enter a valid positive amount';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),

                  // Date picker
                  Obx(() => StyledDatePickerButton(
                        labelText: 'Payment Date',
                        selectedDate: dateObs.value,
                        onDateSelected: (date) => dateObs.value = date,
                        validator: (value) =>
                            value == null ? 'This field is required' : null,
                      )),
                  SizedBox(height: 16.h),

                  // Notes
                  StyledTextFormField(
                    controller: notesCtrl,
                    labelText: 'Notes (Optional)',
                    hintText: 'e.g. Paid early as promised…',
                    prefixIcon: Icons.notes_rounded,
                  ),

                  SizedBox(height: 24.h),

                  // Save button
                  ElevatedButton(
                    onPressed: () => _saveRepayment(
                      modalContext,
                      formKey: formKey,
                      amountCtrl: amountCtrl,
                      notesCtrl: notesCtrl,
                      dateObs: dateObs,
                      existing: repayment,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryTeal,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 52.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      isEdit ? 'Update Repayment' : 'Save Repayment',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveRepayment(
    BuildContext modalContext, {
    required GlobalKey<FormState> formKey,
    required TextEditingController amountCtrl,
    required TextEditingController notesCtrl,
    required Rx<DateTime?> dateObs,
    RepaymentEntity? existing,
  }) async {
    debugPrint('=== _saveRepayment called ===');
    debugPrint('Amount entered: ${amountCtrl.text}');
    debugPrint('Date selected: ${dateObs.value}');
    
    final isValid = formKey.currentState?.validate() ?? false;
    debugPrint('Form validation result: $isValid');
    if (!isValid) {
      debugPrint('Form validation failed! Returning early.');
      return;
    }

    final isEdit = existing != null;
    final enteredAmount = double.parse(amountCtrl.text);

    // Overpayment guards
    final totalPaid = controller.repaymentsList.fold<double>(
        0, (s, r) => s + (r.id == existing?.id ? 0 : r.amount));
    final dueAmount = widget.lending.amount - totalPaid;

    if (!isEdit && dueAmount <= 0) {
      if (!mounted) return;
      showDialog(
        context: modalContext,
        builder: (ctx) => AlertDialog(
          title: const Text('Already Fully Repaid'),
          content: const Text(
              'This lending has already been fully repaid.'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK')),
          ],
        ),
      );
      return;
    }

    if (!isEdit && enteredAmount > dueAmount) {
      final proceed = await showDialog<bool>(
        context: modalContext,
        builder: (ctx) => AlertDialog(
          title: const Text('Overpayment Warning'),
          content: Text(
            'Due amount is ${dueAmount.toCurrency()} ৳ but you entered '
            '${enteredAmount.toCurrency()} ৳. Proceed?',
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel')),
            TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Proceed')),
          ],
        ),
      );
      if (proceed != true) return;
    }

    if (!mounted) return;

    final AuthController authController = Get.find();
    final newRepayment = RepaymentEntity(
      id: existing?.id ?? UniqueKey().toString(),
      lendingId: widget.lending.id,
      userId: authController.user?.email ?? 'unknown_user',
      amount: enteredAmount,
      paidDate: dateObs.value ?? DateTime.now(),
      notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
    );

    if (isEdit) {
      await controller.updateRepayment(
        newRepayment,
        onSuccess: () {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Repayment updated successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
          if (modalContext.mounted) Navigator.pop(modalContext);
        },
        onError: (err) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update repayment: $err'),
              backgroundColor: AppColors.error,
            ),
          );
        },
      );
    } else {
      await controller.addRepayment(
        newRepayment,
        onSuccess: () {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Repayment added successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
          if (modalContext.mounted) Navigator.pop(modalContext);
        },
        onError: (err) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add repayment: $err'),
              backgroundColor: AppColors.error,
            ),
          );
        },
      );
    }
  }
}
