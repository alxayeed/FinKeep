import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/styles/app_colors.dart';

class MissingBudgetDialog extends StatefulWidget {
  final List<DateTime> missingMonths;
  final ValueChanged<double> onSave;

  const MissingBudgetDialog({
    super.key,
    required this.missingMonths,
    required this.onSave,
  });

  @override
  State<MissingBudgetDialog> createState() => _MissingBudgetDialogState();
}

class _MissingBudgetDialogState extends State<MissingBudgetDialog> {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final monthNames = widget.missingMonths.map((m) => DateFormat('MMMM yyyy').format(m)).join(', ');

    return Dialog(
      backgroundColor: isDark ? AppColors.cardDark : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.amber,
                  size: 24.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Missing Budgets Detected',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              'The following previous months have expenses but no budget set:\n\n$monthNames\n\nWould you like to set a budget for these months?',
              style: TextStyle(
                fontSize: 13.sp,
                fontFamily: 'Manrope',
                color: isDark ? Colors.white70 : const Color(0xFF475569),
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: textController,
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: 14.sp,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
              decoration: InputDecoration(
                hintText: 'Enter budget amount (e.g. 20000)',
                hintStyle: TextStyle(
                  color: isDark ? Colors.white30 : const Color(0xFF94A3B8),
                ),
                filled: true,
                fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 10.h,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: isDark ? Colors.white60 : const Color(0xFF475569),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                ElevatedButton(
                  onPressed: () {
                    final double? amount = double.tryParse(textController.text);
                    if (amount != null && amount > 0) {
                      Navigator.pop(context);
                      widget.onSave(amount);
                    } else {
                      Get.snackbar(
                        'Invalid Amount',
                        'Please enter a valid budget amount.',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: const Text('Save Budget'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
