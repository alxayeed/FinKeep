import 'package:flutter/material.dart';
import '../../../../core/enums/expense_category.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/utils/app_localizations.dart';
import 'package:spendly/core/extensions/double_ext.dart';

class CategorySpendingList extends StatelessWidget {
  final Map<ExpenseCategory, double> spentByCategory;
  final Map<ExpenseCategory, double> budgetsByCategory;

  const CategorySpendingList({
    super.key,
    required this.spentByCategory,
    required this.budgetsByCategory,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Filter categories that have spending or a budget
    final categories = ExpenseCategory.values.toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.translate('spending_by_category'),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  AppLocalizations.translate('spent_budget'),
                  style: TextStyle(
                    fontSize: 10.sp,
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
            separatorBuilder: (context, index) => SizedBox(height: 8.h),
            itemBuilder: (context, index) {
              final category = categories[index];
              final spent = spentByCategory[category] ?? 0.0;
              final budget = budgetsByCategory[category] ?? 1000.0; // Fallback budget allocation
              final percent = budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0.0;
              final percentText = '${(percent * 100).toStringAsFixed(0)}%';

              final iconData = _getIconForCategory(category);
              final itemColor = _getColorForCategory(category);

              return Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFF8FAFC),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.01),
                      blurRadius: 4.r,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Icon Container
                    Container(
                      width: 36.r,
                      height: 36.r,
                      decoration: BoxDecoration(
                        color: itemColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        iconData,
                        color: itemColor,
                        size: 18.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Content
                    Expanded(
                      child: Column(
                        children: [
                          // Header line (Label & Amount)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                category.displayName,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF334155),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    '${spent.toCurrency()} ৳',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    ),
                                  ),
                                  Text(
                                    ' / ${budget.toCurrency()} ৳',
                                    style: TextStyle(
                                      fontSize: 9.sp,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? Colors.white30 : const Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          // Progress Bar & Percentage
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(9999.r),
                                  child: SizedBox(
                                    height: 5.h,
                                    child: LinearProgressIndicator(
                                      value: percent,
                                      backgroundColor: isDark
                                          ? const Color(0xFF1E293B)
                                          : const Color(0xFFF1F5F9),
                                      valueColor: AlwaysStoppedAnimation<Color>(itemColor),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              SizedBox(
                                width: 26.w,
                                child: Text(
                                  percentText,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                    fontFamily: 'Manrope',
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  IconData _getIconForCategory(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return Icons.restaurant_rounded;
      case ExpenseCategory.transport:
        return Icons.directions_car_rounded;
      case ExpenseCategory.family:
        return Icons.family_restroom_rounded;
      case ExpenseCategory.personal:
        return Icons.person_rounded;
      case ExpenseCategory.lend:
        return Icons.handshake_rounded;
      case ExpenseCategory.clothing:
        return Icons.shopping_bag_rounded;
      case ExpenseCategory.hangout:
        return Icons.local_activity_rounded;
      case ExpenseCategory.utilities:
        return Icons.bolt_rounded;
      case ExpenseCategory.other:
        return Icons.category_rounded;
    }
  }

  Color _getColorForCategory(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return Colors.orange.shade600;
      case ExpenseCategory.transport:
        return const Color(0xFF059669);
      case ExpenseCategory.family:
        return Colors.blue.shade600;
      case ExpenseCategory.personal:
        return Colors.purple.shade600;
      case ExpenseCategory.lend:
        return Colors.teal.shade600;
      case ExpenseCategory.clothing:
        return Colors.pink.shade600;
      case ExpenseCategory.hangout:
        return Colors.amber.shade700;
      case ExpenseCategory.utilities:
        return Colors.indigo.shade600;
      case ExpenseCategory.other:
        return const Color(0xFF475569);
    }
  }
}
