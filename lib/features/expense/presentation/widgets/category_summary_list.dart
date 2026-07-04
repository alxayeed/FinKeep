import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finkeep/core/extensions/double_ext.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/currency_provider.dart';
import '../../../../core/utils/app_localizations.dart';
import '../controllers/expense_category_controller.dart';
import '../../domain/entities/expense_category_entity.dart';

class CategorySummaryList extends StatelessWidget {
  final Map<String, double> spentByCategory;
  final Map<String, double> budgetsByCategory;
  final ValueChanged<String>? onCategoryTap;
  final bool isCompact;

  const CategorySummaryList.detailed({
    super.key,
    required this.spentByCategory,
    required this.budgetsByCategory,
    this.onCategoryTap,
  }) : isCompact = false;

  const CategorySummaryList.compact({
    super.key,
    required this.spentByCategory,
    this.onCategoryTap,
  }) : budgetsByCategory = const {},
       isCompact = true;

  Color _getColorForCategory(String label) {
    switch (label.toLowerCase()) {
      case 'food':
        return Colors.orange.shade600;
      case 'transport':
        return const Color(0xFF059669);
      case 'family':
        return Colors.blue.shade600;
      case 'personal':
        return Colors.purple.shade600;
      case 'clothing':
        return Colors.pink.shade600;
      case 'travelling':
      case 'hangout':
        return Colors.amber.shade700;
      case 'utilities':
        return Colors.indigo.shade600;
      default:
        return AppColors.primaryTeal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ExpenseCategoryController categoryController = Get.find();

    // Get active categories
    final List<ExpenseCategoryEntity> categories = categoryController.categories
        .where((c) => !c.isDeleted)
        .toList();

    // Sort categories by spending descending
    categories.sort((a, b) {
      final spentA = spentByCategory[a.id] ?? 0.0;
      final spentB = spentByCategory[b.id] ?? 0.0;
      return spentB.compareTo(spentA);
    });

    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isCompact
                      ? "Summary by Category"
                      : AppLocalizations.translate('spending_by_category'),
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                    letterSpacing: 1.2,
                  ),
                ),
                if (!isCompact)
                  Text(
                    AppLocalizations.translate('spent_budget'),
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white30 : const Color(0xFF94A3B8),
                    ),
                  ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            separatorBuilder: (context, index) => SizedBox(height: 6.h),
            itemBuilder: (context, index) {
              final category = categories[index];
              final spent = spentByCategory[category.id] ?? 0.0;
              final itemColor = _getColorForCategory(category.displayLabel);

              if (isCompact) {
                final totalSpentSum = spentByCategory.values.fold(
                  0.0,
                  (sum, val) => sum + val,
                );
                final percent = totalSpentSum > 0
                    ? (spent / totalSpentSum) * 100
                    : 0.0;

                return GestureDetector(
                  onTap: () => onCategoryTap?.call(category.displayLabel),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Row(
                      children: [
                        // Bullet point (category-colored dot)
                        Container(
                          width: 8.r,
                          height: 8.r,
                          decoration: BoxDecoration(
                            color: itemColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        // Dynamic emoji Text
                        Text(category.emoji, style: TextStyle(fontSize: 12.sp)),
                        SizedBox(width: 8.w),
                        // Category Name & Percentage
                        Expanded(
                          child: Text(
                            "${category.displayLabel} (${percent.toStringAsFixed(0)}%)",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.9)
                                  : const Color(0xFF334155),
                            ),
                          ),
                        ),
                        // Total Amount
                        Text(
                          '${spent.toCurrency()} ${context.currency.symbol}',
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
                  ),
                );
              }

              // Detailed variant
              final double? budget = budgetsByCategory[category.id];
              final hasBudget = budget != null && budget > 0;
              final percent = hasBudget ? (spent / budget) : 0.0;
              final percentText = '${(percent * 100).toStringAsFixed(0)}%';
              final isOverBudget = hasBudget && spent > budget;

              return GestureDetector(
                onTap: () => onCategoryTap?.call(category.displayLabel),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Row(
                    children: [
                      // Emoji Container
                      Container(
                        width: 28.r,
                        height: 28.r,
                        decoration: BoxDecoration(
                          color: itemColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(category.emoji, style: TextStyle(fontSize: 14.sp)),
                      ),
                      SizedBox(width: 10.w),
                      // Content
                      Expanded(
                        child: Column(
                          children: [
                            // Header line (Label & Amount)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  category.displayLabel,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontFamily: 'Manrope',
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.9)
                                        : const Color(0xFF334155),
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      '${spent.toCurrency()} ${context.currency.symbol}',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontFamily: 'Manrope',
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.white
                                            : const Color(0xFF0F172A),
                                      ),
                                    ),
                                    if (hasBudget)
                                      Text(
                                        ' / ${budget.toCurrency()} ${context.currency.symbol}',
                                        style: TextStyle(
                                          fontSize: 9.sp,
                                          fontFamily: 'Manrope',
                                          fontWeight: FontWeight.w600,
                                          color: isDark
                                              ? Colors.white30
                                              : const Color(0xFF94A3B8),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            if (hasBudget) ...[
                              SizedBox(height: 4.h),
                              // Progress Bar & Percentage
                              Row(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(9999.r),
                                      child: SizedBox(
                                        height: 4.h,
                                        child: LinearProgressIndicator(
                                          value: percent.clamp(0.0, 1.0),
                                          backgroundColor: isDark
                                              ? const Color(0xFF1E293B)
                                              : const Color(0xFFF1F5F9),
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                isOverBudget
                                                    ? Colors.red.shade600
                                                    : itemColor,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (isOverBudget) ...[
                                        Icon(
                                          Icons.warning_amber_rounded,
                                          color: Colors.red.shade600,
                                          size: 11.sp,
                                        ),
                                        SizedBox(width: 2.w),
                                      ],
                                      Text(
                                        percentText,
                                        style: TextStyle(
                                          fontSize: 9.sp,
                                          fontFamily: 'Manrope',
                                          fontWeight: FontWeight.bold,
                                          color: isOverBudget
                                              ? Colors.red.shade600
                                              : (isDark
                                                    ? Colors.white38
                                                    : const Color(0xFF94A3B8)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
