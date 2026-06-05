import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spendly/core/common/widgets/no_data_widget.dart';
import 'package:spendly/core/extensions/double_ext.dart';
import 'package:spendly/core/responsive/responsive.dart';
import 'package:spendly/core/styles/app_colors.dart';
import 'package:spendly/features/expense/domain/entities/expense_entity.dart';
import 'package:spendly/features/expense/presentation/controllers/expense_controller.dart';
import 'package:spendly/features/expense/presentation/widgets/category_filter_pills.dart';
import '../../../../core/enums/expense_category.dart';
import '../../../../core/common/widgets/loader_widget.dart';
import '../widgets/expense_card_widget.dart';

class ExpenseReportListScreen extends StatelessWidget {
  final ExpenseController controller;

  const ExpenseReportListScreen({
    super.key,
    required this.controller,
  });

  Future<void> _handleRefresh() async {
    if (controller.startDate.value != null && controller.endDate.value != null) {
      await controller.fetchExpensesInRange(
        controller.startDate.value!,
        controller.endDate.value!,
      );
    }
  }

  Widget _buildDateHeader(BuildContext context, DateTime date, double dailyTotal) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final formattedDate = DateFormat('EEEE, MMM dd').format(date);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            formattedDate,
            style: TextStyle(
              fontSize: 10.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white30 : const Color(0xFF94A3B8),
              letterSpacing: 0.5,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                dailyTotal.toCurrency(),
                style: TextStyle(
                  fontSize: 10.sp,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white30 : const Color(0xFF64748B),
                ),
              ),
              SizedBox(width: 2.w),
              FaIcon(
                FontAwesomeIcons.bangladeshiTakaSign,
                size: 8.sp,
                color: isDark ? Colors.white30 : const Color(0xFF64748B),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Category Filter Pills
        Obx(() {
          final selectedCategoryStr = controller.selectedCategory.value;
          final selectedCategory = selectedCategoryStr == 'All'
              ? null
              : ExpenseCategoryExtension.fromString(selectedCategoryStr);

          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: CategoryFilterPills(
              selectedCategory: selectedCategory,
              onCategorySelected: (cat) {
                controller.updateSelectedCategory(cat?.displayName ?? 'All');
              },
            ),
          );
        }),

        // Refreshable transaction list
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: LoaderWidget());
            }

            final itemsList = controller.getGroupedReportExpenses();

            if (itemsList.isEmpty) {
              return RefreshIndicator(
                onRefresh: _handleRefresh,
                color: AppColors.primaryTeal,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 150.h),
                    const Center(child: NoDataWidget()),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _handleRefresh,
              color: AppColors.primaryTeal,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(bottom: 100.h),
                itemCount: itemsList.length,
                itemBuilder: (context, index) {
                  final item = itemsList[index];

                  if (item is Map<String, dynamic>) {
                    return _buildDateHeader(
                      context,
                      item['date'] as DateTime,
                      item['total'] as double,
                    );
                  }

                  return ExpenseCardWidget(expense: item as ExpenseEntity);
                },
              ),
            );
          }),
        ),
      ],
    );
  }
}
