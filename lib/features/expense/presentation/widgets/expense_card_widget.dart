import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:finkeep/core/extensions/double_ext.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import 'package:finkeep/core/styles/currency_provider.dart';
import '../../domain/entities/expense_entity.dart';
import '../controllers/expense_category_controller.dart';

class ExpenseCardWidget extends StatelessWidget {
  final ExpenseEntity expense;
  final VoidCallback? onDismissed;

  const ExpenseCardWidget({
    super.key,
    required this.expense,
    this.onDismissed,
  });

  Color _getCategoryColor(String label) {
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

    final category = categoryController.resolveCategory(expense.category);
    final Color categoryColor = _getCategoryColor(category.displayLabel);
    final String categoryEmoji = category.emoji;
    final bool isDeleted = category.isDeleted;

    final formattedTime = DateFormat('hh:mm a').format(expense.date);
    final String displayCategoryLabel = isDeleted ? '${category.displayLabel} (Deleted)' : category.displayLabel;
    final String label = expense.description.isNotEmpty
        ? expense.description
        : displayCategoryLabel;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: GestureDetector(
        onTap: () {
          context.pushNamed(
            AppRoutes.expenseDetails,
            extra: expense,
          );
        },
        child: Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(16.r),
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
              // Beautiful mockup container for icon
              Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  categoryEmoji,
                  style: TextStyle(fontSize: 18.sp),
                ),
              ),
              SizedBox(width: 14.w),
              // Name and Time/Subtitles
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.cardTitle(context),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '$displayCategoryLabel • $formattedTime',
                      style: AppTextStyles.cardSubtitle(context),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              // Transaction amount
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    expense.amount.toCurrency(),
                    style: AppTextStyles.cardAmount(context),
                  ),
                  SizedBox(width: 2.w),
                  FaIcon(
                    context.currency.icon,
                    size: 11.sp,
                    color: isDark ? Colors.white70 : const Color(0xFF0F172A),
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
