import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:spendly/core/extensions/double_ext.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/styles/app_colors.dart';
import '../../domain/entities/expense_entity.dart';

class ExpenseCardWidget extends StatelessWidget {
  final ExpenseEntity expense;
  final VoidCallback? onDismissed;

  const ExpenseCardWidget({
    super.key,
    required this.expense,
    this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    Color categoryColor;
    IconData categoryIcon;

    switch (expense.category.toLowerCase()) {
      case 'food':
        categoryColor = Colors.orange.shade600;
        categoryIcon = Icons.restaurant_rounded;
        break;
      case 'transport':
        categoryColor = const Color(0xFF059669);
        categoryIcon = Icons.directions_car_rounded;
        break;
      case 'family':
        categoryColor = Colors.blue.shade600;
        categoryIcon = Icons.family_restroom_rounded;
        break;
      case 'personal':
        categoryColor = Colors.purple.shade600;
        categoryIcon = Icons.person_rounded;
        break;
      case 'lend':
        categoryColor = Colors.teal.shade600;
        categoryIcon = Icons.handshake_rounded;
        break;
      case 'clothing':
        categoryColor = Colors.pink.shade600;
        categoryIcon = Icons.shopping_bag_rounded;
        break;
      case 'hangout':
        categoryColor = Colors.amber.shade700;
        categoryIcon = Icons.local_activity_rounded;
        break;
      case 'utilities':
        categoryColor = Colors.indigo.shade600;
        categoryIcon = Icons.bolt_rounded;
        break;
      default:
        categoryColor = const Color(0xFF475569);
        categoryIcon = Icons.category_rounded;
    }

    final formattedTime = DateFormat('hh:mm a').format(expense.date);
    final String label = expense.description.isNotEmpty
        ? expense.description
        : expense.category;

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
                child: Icon(
                  categoryIcon,
                  color: categoryColor,
                  size: 20.sp,
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
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '${expense.category} • $formattedTime',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                      ),
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
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  FaIcon(
                    FontAwesomeIcons.bangladeshiTakaSign,
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
