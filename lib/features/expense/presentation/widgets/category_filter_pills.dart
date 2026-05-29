import 'package:flutter/material.dart';
import '../../../../core/enums/expense_category.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/utils/app_localizations.dart';

class CategoryFilterPills extends StatelessWidget {
  final ExpenseCategory? selectedCategory;
  final ValueChanged<ExpenseCategory?> onCategorySelected;

  const CategoryFilterPills({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Add "All" to the list of choices
    final List<ExpenseCategory?> categories = [null, ...ExpenseCategory.values];

    return SizedBox(
      height: 38.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: categories.length,
        separatorBuilder: (context, index) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = selectedCategory == cat;
          final String displayName = cat == null 
              ? AppLocalizations.translate('all') 
              : cat.displayName;

          return GestureDetector(
            onTap: () => onCategorySelected(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark ? AppColors.primaryTeal : const Color(0xFF0F172A))
                    : (isDark ? const Color(0xFF1E293B) : Colors.white),
                borderRadius: BorderRadius.circular(9999.r),
                border: Border.all(
                  color: isSelected
                      ? (isDark ? AppColors.primaryTeal : const Color(0xFF0F172A))
                      : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: isDark 
                              ? AppColors.primaryTeal.withValues(alpha: 0.3) 
                              : Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4.r,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  displayName,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.white70 : const Color(0xFF475569)),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
