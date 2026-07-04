import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:finkeep/core/extensions/double_ext.dart';
import 'package:finkeep/core/styles/currency_provider.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../domain/entities/income/income_entity.dart';
import '../controllers/income_category_controller.dart';
import 'package:get/get.dart';

class IncomeCard extends StatelessWidget {
  final IncomeEntity income;

  const IncomeCard({
    super.key,
    required this.income,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final IncomeCategoryController categoryController = Get.find();
    
    // Find category metadata dynamically
    final category = categoryController.categories.firstWhereOrNull((c) => c.id == income.categoryId);
    final categoryLabel = category?.displayLabel ?? 'Other';
    final categoryEmoji = category?.emoji ?? '💰';

    final formattedTime = DateFormat('hh:mm a').format(income.date);
    final String label = income.description.isNotEmpty
        ? income.description
        : categoryLabel;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: GestureDetector(
        onTap: () {
          context.pushNamed(
            AppRoutes.incomeDetails,
            extra: income,
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
              // Emoji Avatar Container
              Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  categoryEmoji,
                  style: TextStyle(fontSize: 20.sp),
                ),
              ),
              SizedBox(width: 14.w),
              // Name and Subtitle
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
                      '${category?.isDeleted == true ? "$categoryLabel (Deleted)" : categoryLabel} • $formattedTime',
                      style: AppTextStyles.cardSubtitle(context).copyWith(
                        fontStyle: category?.isDeleted == true ? FontStyle.italic : FontStyle.normal,
                        color: category?.isDeleted == true
                            ? (isDark ? Colors.white38 : const Color(0xFF94A3B8))
                            : AppTextStyles.cardSubtitle(context).color,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              // Positive transaction amount
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '+ ${income.amount.toCurrency()}',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                      color: AppColors.success, // Emerald green for positive values
                    ),
                  ),
                  SizedBox(width: 3.w),
                  FaIcon(
                    context.currency.icon,
                    size: 11.sp,
                    color: AppColors.success,
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
