import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:finkeep/core/config/app_config.dart';
import '../../../../core/common/widgets/loader_widget.dart';
import '../../../../core/common/widgets/no_data_widget.dart';
import '../../../../core/extensions/double_ext.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/currency_provider.dart';
import '../../domain/entities/income/income_entity.dart';
import '../controllers/income_controller.dart';
import '../widgets/income_card.dart';
import '../widgets/income_category_filter_pills.dart';

class IncomeListScreen extends StatelessWidget {
  final IncomeController controller;

  const IncomeListScreen({
    super.key,
    required this.controller,
  });

  Future<void> _handleRefresh() async {
    controller.shouldRefresh = true;
    await controller.fetchMonthlyIncomes();
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
                '+ ${dailyTotal.toCurrency()}',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                ),
              ),
              SizedBox(width: 2.w),
              FaIcon(
                context.currency.icon,
                size: 8.sp,
                color: AppColors.success,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Premium monthly total card
        Obx(() {
          final total = controller.totalIncome.value;
          final count = controller.filteredIncomes.length;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TOTAL INCOME',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white30 : const Color(0xFF94A3B8),
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              total.toCurrency(),
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.bold,
                                color: AppColors.success, // Positive/green success color
                              ),
                            ),
                            SizedBox(width: 4.w),
                            FaIcon(
                              context.currency.icon,
                              size: 14.sp,
                              color: AppColors.success,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1.w,
                    height: 40.h,
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                  ),
                  SizedBox(width: 16.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'TRANSACTIONS',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white30 : const Color(0xFF94A3B8),
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        '$count logs',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),

        // Category Filter Pills
        Obx(() {
          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: IncomeCategoryFilterPills(
              selectedCategoryId: controller.selectedCategory.value == 'All'
                  ? null
                  : controller.selectedCategory.value,
              onCategorySelected: (catId) {
                controller.updateSelectedCategory(catId ?? 'All');
              },
              searchQuery: controller.searchQuery.value,
              onSearchQueryChanged: (query) {
                controller.updateSearchQuery(query);
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

            final itemsList = controller.groupedIncomes;

            if (itemsList.isEmpty) {
              return RefreshIndicator(
                onRefresh: _handleRefresh,
                color: AppColors.primaryTeal,
                notificationPredicate: (notification) =>
                    AppConfig.useRemote &&
                    defaultScrollNotificationPredicate(notification),
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
              notificationPredicate: (notification) =>
                  AppConfig.useRemote &&
                  defaultScrollNotificationPredicate(notification),
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

                  return IncomeCard(income: item as IncomeEntity);
                },
              ),
            );
          }),
        ),
      ],
    );
  }
}
