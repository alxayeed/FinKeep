import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spendly/core/extensions/double_ext.dart';
import 'package:spendly/core/responsive/responsive.dart';
import 'package:spendly/core/styles/app_colors.dart';

import '../../domain/entities/return_entry.dart';
import '../controller/investment_controller.dart';
import '../screens/add_roi_bottom_sheet.dart';

class ReturnEntryItem extends StatelessWidget {
  final String investmentId;
  final ReturnEntry entry;
  final int index;
  final int totalItems;

  const ReturnEntryItem({
    super.key,
    required this.investmentId,
    required this.entry,
    required this.index,
    required this.totalItems,
  });

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

  Future<bool> _confirmDeleteReturn(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.cardDark : Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text('Delete Return Entry?',
            style: TextStyle(
                fontSize: 16.sp,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A))),
        content: Text(
          'Remove this return entry of ${entry.amountReceived.toCurrency()} ৳?',
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dateText = DateFormat('MMM dd, yyyy').format(entry.date);
    final controller = Get.find<InvestmentController>();

    final tileContent = Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
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
                  entry.notes.isNotEmpty ? entry.notes : 'Return Received',
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
                  'Date: $dateText • ${entry.medium}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
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
                '${entry.amountReceived.toCurrency()} ৳',
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
    );

    final totalReturns = totalItems - 1;
    final chronoIndex = totalReturns - index;
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

    final mainContent = GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
          builder: (context) => AddReturnBottomSheet(
            investmentId: investmentId,
            returnEntry: entry,
          ),
        );
      },
      child: tileContent,
    );

    return Dismissible(
      key: ValueKey(entry.id),
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
        final confirmed = await _confirmDeleteReturn(context);
        if (confirmed != true) return false;

        bool deleteSuccess = false;
        await controller.deleteReturnEntry(
          investmentId,
          entry.id,
          onSuccess: () {
            deleteSuccess = true;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Return entry deleted successfully!'),
                backgroundColor: AppColors.success,
              ),
            );
          },
          onError: (err) {
            deleteSuccess = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to delete return: $err'),
                backgroundColor: AppColors.error,
              ),
            );
          },
        );
        return deleteSuccess;
      },
      onDismissed: (_) {},
      child: _buildTimelineRow(
        isDark: isDark,
        indicator: indicator,
        child: mainContent,
      ),
    );
  }
}
