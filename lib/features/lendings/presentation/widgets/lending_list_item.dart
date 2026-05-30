import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spendly/core/extensions/double_ext.dart';
import 'package:spendly/core/responsive/responsive.dart';
import 'package:spendly/core/styles/app_colors.dart';
import 'package:spendly/core/styles/app_text_styles.dart';
import 'package:spendly/core/routes/app_router.dart';
import 'package:intl/intl.dart';

import '../../domain/entity/lending/lending_entity.dart';

class LendingListItem extends StatelessWidget {
  final LendingEntity lending;

  const LendingListItem({
    super.key,
    required this.lending,
  });

  /// Generate initials from name
  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length.clamp(0, 2)).toUpperCase();
  }

  /// Avatar background color based on name hash
  Color _avatarColor(String name, LendingStatus status, bool isDark) {
    switch (status) {
      case LendingStatus.overdue:
        return isDark ? const Color(0xFF3B1515) : const Color(0xFFFFE4E4);
      case LendingStatus.partial:
        return isDark ? const Color(0xFF1E293B) : const Color(0xFFE0EAFF);
      case LendingStatus.due:
        return isDark ? const Color(0xFF2D2008) : const Color(0xFFFFF8E1);
      case LendingStatus.paid:
        return isDark ? const Color(0xFF022C22) : const Color(0xFFECFDF5);
    }
  }

  Color _avatarTextColor(LendingStatus status) {
    switch (status) {
      case LendingStatus.overdue:
        return const Color(0xFFEF4444);
      case LendingStatus.partial:
        return const Color(0xFF3B82F6);
      case LendingStatus.due:
        return const Color(0xFFF59E0B);
      case LendingStatus.paid:
        return const Color(0xFF059669);
    }
  }

  (String label, Color color, Color bgColor) _statusChip(
      LendingStatus status, bool isDark) {
    switch (status) {
      case LendingStatus.overdue:
        return (
          'OVERDUE',
          const Color(0xFFEF4444),
          isDark ? const Color(0xFF3B0F0F) : const Color(0xFFFFEEEE),
        );
      case LendingStatus.partial:
        return (
          'PARTIAL',
          const Color(0xFF3B82F6),
          isDark ? const Color(0xFF1E2D4D) : const Color(0xFFEFF6FF),
        );
      case LendingStatus.due:
        return (
          'DUE',
          const Color(0xFFF59E0B),
          isDark ? const Color(0xFF2D1F05) : const Color(0xFFFFFBEB),
        );
      case LendingStatus.paid:
        return (
          'CLEARED',
          const Color(0xFF059669),
          isDark ? const Color(0xFF022C22) : const Color(0xFFECFDF5),
        );
    }
  }

  String _formatDueDate(DateTime? dueDate) {
    if (dueDate == null) return '';
    final now = DateTime.now();
    final diff = dueDate.difference(DateTime(now.year, now.month, now.day));
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Tomorrow';
    if (diff.inDays == -1) return 'Yesterday';
    return DateFormat('MMM dd, yyyy').format(dueDate);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final status = lending.smartStatus;
    final (chipLabel, chipColor, chipBg) = _statusChip(status, isDark);
    final avatarBg = _avatarColor(lending.person.name, status, isDark);
    final avatarFg = _avatarTextColor(status);
    final isPaid = status == LendingStatus.paid;
    final dateText = lending.dueDate != null
        ? _formatDueDate(lending.dueDate)
        : DateFormat('MMM dd, yyyy').format(lending.createdDate);

    // Paid/cleared cards use muted colours and a strikethrough across name + amount
    final Color cardBg = isPaid
        ? (isDark ? const Color(0xFF111C2B) : const Color(0xFFF8FAFC))
        : (isDark ? AppColors.cardDark : AppColors.cardLight);
    final Color cardBorder = isPaid
        ? (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0))
        : (isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9));

    return GestureDetector(
      onTap: () => context.pushNamed(AppRoutes.lendingDetails, extra: lending),
      child: Opacity(
        opacity: isPaid ? 0.65 : 1.0,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: cardBorder, width: 1),
            boxShadow: isPaid
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8.r,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            children: [
              // Avatar with initials
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 46.r,
                    height: 46.r,
                    decoration: BoxDecoration(
                      color: avatarBg,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _initials(lending.person.name),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                        color: avatarFg,
                      ),
                    ),
                  ),
                  // Overdue indicator dot
                  if (status == LendingStatus.overdue)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        width: 10.r,
                        height: 10.r,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEF4444),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 13.w),

              // Name + status chip + date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lending.person.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.cardTitle(context).copyWith(
                        decoration: isPaid
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: isDark
                            ? Colors.white54
                            : const Color(0xFF94A3B8),
                        decorationThickness: 1.5,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      children: [
                        // Status chip
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 7.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: chipBg,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            chipLabel,
                            style: TextStyle(
                              fontSize: 9.sp,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.bold,
                              color: chipColor,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        // Date
                        if (dateText.isNotEmpty)
                          Text(
                            dateText,
                            style: AppTextStyles.cardSubtitle(context),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(width: 10.w),

              // Amount + chevron/check
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${lending.amount.toCurrency()} ৳',
                    style: AppTextStyles.cardAmount(context).copyWith(
                      decoration: isPaid
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationColor: isDark
                          ? Colors.white54
                          : const Color(0xFF94A3B8),
                      decorationThickness: 1.5,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Icon(
                    isPaid
                        ? Icons.check_circle_outline_rounded
                        : Icons.chevron_right_rounded,
                    size: 16.sp,
                    color: isPaid
                        ? const Color(0xFF059669)
                        : (isDark ? Colors.white24 : const Color(0xFFCBD5E1)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
