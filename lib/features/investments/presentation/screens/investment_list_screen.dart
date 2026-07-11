import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:finkeep/core/config/app_config.dart';
import 'package:finkeep/core/common/widgets/no_data_widget.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/routes/app_router.dart';
import 'package:finkeep/core/styles/app_colors.dart';

import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../../../core/common/widgets/custom_fab.dart';
import '../../../../core/common/widgets/error_widget.dart';
import '../../../expense/presentation/widgets/segmented_tab_bar.dart';
import '../controller/investment_controller.dart';
import '../widgets/investment_item.dart';
import '../widgets/investment_shimmer_list.dart';
import '../widgets/investment_summary_shimmer.dart';
import 'investment_summary_screen.dart';

class InvestmentListScreen extends StatefulWidget {
  const InvestmentListScreen({super.key});

  @override
  State<InvestmentListScreen> createState() => _InvestmentListScreenState();
}

class _InvestmentListScreenState extends State<InvestmentListScreen> {
  int _selectedTab = 0; // 0 for Summary, 1 for Details (List)

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InvestmentController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: CustomAppBar(
        title: 'Investments',
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => context.pushNamed(AppRoutes.settings),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primaryTeal,
        onRefresh: () async {
          await controller.fetchInvestments();
        },
        notificationPredicate: (notification) =>
            AppConfig.useRemote &&
            defaultScrollNotificationPredicate(notification),
        child: Column(
          children: [
            SegmentedTabBar(
              selectedIndex: _selectedTab,
              onTabChanged: (index) {
                setState(() {
                  _selectedTab = index;
                });
              },
            ),
            Expanded(
              child: Obx(() {
                // Read reactive variables at the beginning of Obx to register listener
                final isLoading = controller.isLoading.value;
                final isInvestmentsEmpty = controller.investments.isEmpty;
                final hasError = controller.errorMessage.isNotEmpty;

                if (isLoading && isInvestmentsEmpty) {
                  return _selectedTab == 0
                      ? const InvestmentSummaryShimmer()
                      : const InvestmentShimmerList();
                }

                if (hasError) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: 120.h),
                      Center(
                        child: ErrorIndicatorWidget(
                          errorMessage: controller.errorMessage.value,
                          onRetry: () async {
                            await controller.fetchInvestments();
                          },
                        ),
                      ),
                    ],
                  );
                }

                if (_selectedTab == 0) {
                  return InvestmentSummaryScreen(controller: controller);
                }

                if (isInvestmentsEmpty) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: 150.h),
                      const Center(child: NoDataWidget()),
                    ],
                  );
                }

                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  itemCount: controller.investments.length + 1,
                  itemBuilder: (context, index) {
                    if (index == controller.investments.length) {
                      return SizedBox(height: 100.h);
                    }
                    final investment = controller.investments[index];
                    return InvestmentItem(
                      investment: investment,
                      onTap: () {
                        context.pushNamed(
                          AppRoutes.investmentDetails,
                          extra: investment,
                        );
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFAB(
        onPressed: () {
          context.pushNamed(AppRoutes.addInvestment);
        },
      ),
    );
  }
}
