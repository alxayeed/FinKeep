import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:finkeep/core/extensions/double_ext.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/styles/app_colors.dart';
import 'package:finkeep/features/lendings/presentation/controllers/lendings_controller.dart';
import 'package:finkeep/features/lendings/presentation/screens/repayment_list_widget.dart';

import '../../../../core/routes/app_router.dart';
import '../../domain/entity/lending/lending_entity.dart';

class LendingDetailsScreen extends StatefulWidget {
  final LendingEntity lending;

  const LendingDetailsScreen({super.key, required this.lending});

  @override
  State<LendingDetailsScreen> createState() => _LendingDetailsScreenState();
}

class _LendingDetailsScreenState extends State<LendingDetailsScreen> {
  final LendingsController controller = Get.find<LendingsController>();

  @override
  void initState() {
    super.initState();
    controller.fetchRepayments(widget.lending.id);
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.cardDark : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
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
            'This will permanently remove the lending record for ${widget.lending.person.name}.',
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lending record deleted.'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      },
      onError: (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Obx(() {
      final lending = controller.lendingsList.firstWhere(
        (l) => l.id == widget.lending.id,
        orElse: () => widget.lending,
      );
      final status = lending.status;
      final isGiven = lending.type == LendingType.given;
      final isPaid = status == LendingStatus.paid;

      // Status appearance
      final (statusLabel, statusColor, statusBg) = _statusAppearance(
        status,
        isDark,
      );

      // Avatar colour
      _avatarBg(status, isDark);
      _avatarFg(status);

      return Scaffold(
        backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
        body: SafeArea(
          child: Column(
            children: [
              // ── App bar ──────────────────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(8.w, 4.h, 8.w, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.chevron_left,
                        size: 26.sp,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                      onPressed: () => context.pop(),
                    ),
                    const Spacer(),
                    Text(
                      'Lending Details',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const Spacer(),
                    // Edit button
                    IconButton(
                      icon: Icon(
                        Icons.edit_rounded,
                        size: 20.sp,
                        color: AppColors.primaryTeal,
                      ),
                      onPressed: () => context.pushNamed(
                        AppRoutes.updateLending,
                        extra: lending,
                      ),
                    ),
                    // Delete button
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        size: 20.sp,
                        color: AppColors.error,
                      ),
                      onPressed: _confirmDelete,
                    ),
                  ],
                ),
              ),

              // ── Scrollable body ───────────────────────────────────
              Expanded(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          SizedBox(height: 10.h),

                          // ── Name + status badge ──────────
                          Text(
                            lending.person.name,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: statusBg,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              statusLabel,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),

                          SizedBox(height: 12.h),

                          // ── Amount card with repayment progress ───
                          Builder(
                            builder: (context) {
                              final paid = lending.repaidAmount;
                              final total = lending.amount;
                              final remaining = (total - paid).clamp(
                                0.0,
                                total,
                              );
                              final progress = total == 0
                                  ? 0.0
                                  : (paid / total).clamp(0.0, 1.0);

                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Container(
                                  padding: EdgeInsets.all(20.r),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.cardDark
                                        : AppColors.cardLight,
                                    borderRadius: BorderRadius.circular(20.r),
                                    border: Border.all(
                                      color: isDark
                                          ? const Color(0xFF334155)
                                          : const Color(0xFFE2E8F0),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.04,
                                        ),
                                        blurRadius: 12.r,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Type chip
                                      Row(
                                        mainAxisAlignment: .spaceBetween,
                                        children: [
                                          Text(
                                            'Total Amount ${isGiven ? 'Lent' : 'Borrowed'}',
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              fontFamily: 'Manrope',
                                              fontWeight: FontWeight.w500,
                                              color: isDark
                                                  ? Colors.white38
                                                  : const Color(0xFF94A3B8),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8.w,
                                              vertical: 3.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isGiven
                                                  ? const Color(0xFFFFEEEE)
                                                  : const Color(0xFFECFDF5),
                                              borderRadius:
                                                  BorderRadius.circular(6.r),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  isGiven
                                                      ? Icons
                                                            .arrow_upward_rounded
                                                      : Icons
                                                            .arrow_downward_rounded,
                                                  size: 11.sp,
                                                  color: isGiven
                                                      ? AppColors.error
                                                      : AppColors.success,
                                                ),
                                                SizedBox(width: 3.w),
                                                Text(
                                                  isGiven ? 'GIVEN' : 'TAKEN',
                                                  style: TextStyle(
                                                    fontSize: 9.sp,
                                                    fontFamily: 'Manrope',
                                                    fontWeight: FontWeight.bold,
                                                    color: isGiven
                                                        ? AppColors.error
                                                        : AppColors.success,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      // SizedBox(height: 10.h),

                                      // Big amount
                                      Row(
                                        crossAxisAlignment: .center,
                                        children: [
                                          Text(
                                            total.toCurrency(),
                                            style: TextStyle(
                                              fontSize: 32.sp,
                                              fontFamily: 'Manrope',
                                              fontWeight: FontWeight.bold,
                                              color: isDark
                                                  ? Colors.white
                                                  : const Color(0xFF0F172A),
                                            ),
                                          ),
                                          SizedBox(width: 4.w),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              bottom: 3.h,
                                            ),
                                            child: FaIcon(
                                              FontAwesomeIcons
                                                  .bangladeshiTakaSign,
                                              size: 18.sp,
                                              color: isDark
                                                  ? Colors.white38
                                                  : const Color(0xFF94A3B8),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Progress label row
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Repayment Progress',
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              fontFamily: 'Manrope',
                                              fontWeight: FontWeight.w500,
                                              color: isDark
                                                  ? Colors.white54
                                                  : const Color(0xFF64748B),
                                            ),
                                          ),
                                          Text(
                                            '${(progress * 100).toStringAsFixed(0)}%',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontFamily: 'Manrope',
                                              fontWeight: FontWeight.bold,
                                              color: isDark
                                                  ? Colors.white
                                                  : const Color(0xFF0F172A),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.h),

                                      // Progress bar
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                        child: LinearProgressIndicator(
                                          value: progress,
                                          minHeight: 8.h,
                                          backgroundColor: isDark
                                              ? const Color(0xFF334155)
                                              : const Color(0xFFE2E8F0),
                                          valueColor: AlwaysStoppedAnimation(
                                            statusColor,
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 16.h),

                                      // Received / Remaining row
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  isGiven
                                                      ? 'RECEIVED'
                                                      : 'PAID BACK',
                                                  style: TextStyle(
                                                    fontSize: 9.sp,
                                                    fontFamily: 'Manrope',
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0.8,
                                                    color: isDark
                                                        ? Colors.white38
                                                        : const Color(
                                                            0xFF94A3B8,
                                                          ),
                                                  ),
                                                ),
                                                SizedBox(height: 3.h),
                                                Text(
                                                  '${paid.toCurrency()} ৳',
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontFamily: 'Manrope',
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        AppColors.primaryTeal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            height: 36.h,
                                            color: isDark
                                                ? const Color(0xFF334155)
                                                : const Color(0xFFE2E8F0),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                left: 16.w,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'REMAINING',
                                                    style: TextStyle(
                                                      fontSize: 9.sp,
                                                      fontFamily: 'Manrope',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 0.8,
                                                      color: isDark
                                                          ? Colors.white38
                                                          : const Color(
                                                              0xFF94A3B8,
                                                            ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 3.h),
                                                  Text(
                                                    '${remaining.toCurrency()} ৳',
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontFamily: 'Manrope',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: isPaid
                                                          ? AppColors.success
                                                          : (isDark
                                                                ? Colors.white
                                                                : const Color(
                                                                    0xFF0F172A,
                                                                  )),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          SizedBox(height: 10.h),

                          // ── Meta info row ─────────────────────────
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _metaTile(
                                    isDark: isDark,
                                    icon: Icons.calendar_today_rounded,
                                    label: 'Transaction Date',
                                    value: DateFormat(
                                      'MMM dd, yyyy',
                                    ).format(lending.createdDate),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: _metaTile(
                                    isDark: isDark,
                                    icon: Icons.event_rounded,
                                    label: 'Due Date',
                                    value: lending.dueDate != null
                                        ? DateFormat(
                                            'MMM dd, yyyy',
                                          ).format(lending.dueDate!)
                                        : 'Not set',
                                    valueColor:
                                        lending.dueDate != null &&
                                            DateTime.now().isAfter(
                                              lending.dueDate!,
                                            ) &&
                                            !isPaid
                                        ? AppColors.error
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (lending.description != null &&
                              lending.description!.isNotEmpty) ...[
                            SizedBox(height: 10.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(14.r),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF1E293B)
                                      : const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(14.r),
                                  border: Border.all(
                                    color: isDark
                                        ? const Color(0xFF334155)
                                        : const Color(0xFFE2E8F0),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.description_outlined,
                                      size: 16.sp,
                                      color: isDark
                                          ? Colors.white38
                                          : const Color(0xFF94A3B8),
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Text(
                                        lending.description!,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontFamily: 'Manrope',
                                          fontStyle: FontStyle.italic,
                                          color: isDark
                                              ? Colors.white60
                                              : const Color(0xFF64748B),
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],

                          SizedBox(height: 8.h),
                        ],
                      ),
                    ),

                    // ── Repayment history section ─────────────────
                    SliverToBoxAdapter(
                      child: RepaymentListWidget(lending: lending),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // ── Helpers ──────────────────────────────────────────────────

  Widget _metaTile({
    required bool isDark,
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 14.sp,
                color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
              ),
              SizedBox(width: 5.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.bold,
              color:
                  valueColor ??
                  (isDark ? Colors.white : const Color(0xFF0F172A)),
            ),
          ),
        ],
      ),
    );
  }

  (String label, Color color, Color bgColor) _statusAppearance(
    LendingStatus status,
    bool isDark,
  ) {
    final displayLabel = status.label.toUpperCase();
    switch (status) {
      case LendingStatus.overdue:
        return (
          displayLabel,
          const Color(0xFFEF4444),
          isDark ? const Color(0xFF3B0F0F) : const Color(0xFFFFEEEE),
        );
      case LendingStatus.partial:
        return (
          displayLabel,
          const Color(0xFF3B82F6),
          isDark ? const Color(0xFF1E2D4D) : const Color(0xFFEFF6FF),
        );
      case LendingStatus.due:
        return (
          displayLabel,
          AppColors.primaryTeal,
          isDark ? const Color(0xFF022C22) : const Color(0xFFECFDF5),
        );
      case LendingStatus.paid:
        return (
          displayLabel,
          const Color(0xFF059669),
          isDark ? const Color(0xFF022C22) : const Color(0xFFECFDF5),
        );
    }
  }

  Color _avatarBg(LendingStatus status, bool isDark) {
    switch (status) {
      case LendingStatus.overdue:
        return isDark ? const Color(0xFF3B1515) : const Color(0xFFFFE4E4);
      case LendingStatus.partial:
        return isDark ? const Color(0xFF1E293B) : const Color(0xFFE0EAFF);
      case LendingStatus.due:
        return isDark ? const Color(0xFF022C22) : const Color(0xFFECFDF5);
      case LendingStatus.paid:
        return isDark ? const Color(0xFF022C22) : const Color(0xFFECFDF5);
    }
  }

  Color _avatarFg(LendingStatus status) {
    switch (status) {
      case LendingStatus.overdue:
        return const Color(0xFFEF4444);
      case LendingStatus.partial:
        return const Color(0xFF3B82F6);
      case LendingStatus.due:
        return AppColors.primaryTeal;
      case LendingStatus.paid:
        return const Color(0xFF059669);
    }
  }
}
