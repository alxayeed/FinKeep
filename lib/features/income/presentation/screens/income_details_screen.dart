import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/styles/app_colors.dart';
import 'package:finkeep/core/extensions/double_ext.dart';
import 'package:finkeep/core/styles/currency_provider.dart';
import '../../domain/entities/income/income_entity.dart';
import '../controllers/income_controller.dart';
import '../controllers/income_category_controller.dart';

class IncomeDetailsScreen extends StatefulWidget {
  final IncomeEntity income;

  const IncomeDetailsScreen({super.key, required this.income});

  @override
  State<IncomeDetailsScreen> createState() => _IncomeDetailsScreenState();
}

class _IncomeDetailsScreenState extends State<IncomeDetailsScreen> {
  final IncomeController controller = Get.find();
  final IncomeCategoryController categoryController = Get.find();
  late IncomeEntity _currentIncome;

  @override
  void initState() {
    super.initState();
    _currentIncome = widget.income;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Find category metadata dynamically
    final category = categoryController.categories.firstWhereOrNull((c) => c.id == _currentIncome.categoryId);
    final categoryLabel = category?.displayLabel ?? 'Other';
    final categoryEmoji = category?.emoji ?? '💰';

    final formattedDate = DateFormat('MMMM dd, yyyy').format(_currentIncome.date);
    final formattedTime = DateFormat('hh:mm a').format(_currentIncome.date);

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.cardDark : Colors.white,
        elevation: 0,
        leadingWidth: 80.w,
        leading: TextButton.icon(
          onPressed: () => context.pop(),
          icon: Icon(Icons.chevron_left, size: 24.sp, color: AppColors.primaryTeal),
          label: Text(
            'Back',
            style: TextStyle(
              fontSize: 15.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTeal,
            ),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
        ),
        title: Text(
          'Income Details',
          style: TextStyle(
            fontSize: 16.sp,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final updated = await context.pushNamed<IncomeEntity>(
                AppRoutes.editIncome,
                extra: _currentIncome,
              );
              if (updated != null && mounted) {
                setState(() {
                  _currentIncome = updated;
                });
              }
            },
            child: Text(
              'Edit',
              style: TextStyle(
                fontSize: 15.sp,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTeal,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Center Header Panel
            Padding(
              padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 24.w),
              child: Column(
                children: [
                  Container(
                    width: 64.r,
                    height: 64.r,
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColors.primaryTeal.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      categoryEmoji,
                      style: TextStyle(fontSize: 32.sp),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    category?.isDeleted == true ? '$categoryLabel (Deleted)'.toUpperCase() : categoryLabel.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      fontStyle: category?.isDeleted == true ? FontStyle.italic : FontStyle.normal,
                      color: category?.isDeleted == true
                          ? Colors.red.shade400
                          : (isDark ? Colors.white38 : const Color(0xFF64748B)),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '+ ${_currentIncome.amount.toCurrency()}',
                        style: TextStyle(
                          fontSize: 40.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          color: AppColors.success, // Positive/success color
                        ),
                      ),
                      SizedBox(width: 3.w),
                      FaIcon(
                        context.currency.icon,
                        size: 18.sp,
                        color: AppColors.success,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '$formattedDate at $formattedTime',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),

            // Metadata Cards
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  // Status card
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : AppColors.cardLight,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildRowItem(
                          context,
                          'Status',
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8.r,
                                height: 8.r,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.success,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                'Received',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Notes card
                  if (_currentIncome.description.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : AppColors.cardLight,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NOTE',
                            style: TextStyle(
                              fontSize: 9.sp,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                              color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            _currentIncome.description,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w600,
                              height: 1.4.h,
                              color: isDark ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF334155),
                            ),
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: 24.h),

                  // Delete button
                  Column(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => _confirmDelete(context),
                        icon: Icon(Icons.delete_rounded, size: 18.sp, color: Colors.red.shade600),
                        label: Text(
                          'Delete Transaction',
                          style: TextStyle(color: Colors.red.shade600),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red.shade100, width: 1),
                          backgroundColor: Colors.red.shade50.withValues(alpha: 0.1),
                          minimumSize: Size(double.infinity, 48.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildRowItem(BuildContext context, String label, Widget trailing, {bool showDivider = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        border: showDivider
            ? Border(
                bottom: BorderSide(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                  width: 1,
                ),
              )
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white38 : const Color(0xFF64748B),
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Income'),
        content: const Text('Are you sure you want to delete this income log?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await controller.removeIncome(
        _currentIncome.id,
        onSuccess: () {
          if (!mounted) return;
          context.pop(); // Pop details screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Income successfully deleted.'),
              backgroundColor: Colors.green,
            ),
          );
        },
        onError: (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete income: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    }
  }
}
