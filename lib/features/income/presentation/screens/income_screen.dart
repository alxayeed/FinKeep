import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:finkeep/core/routes/app_router.dart';
import '../../../../core/common/widgets/custom_fab.dart';
import '../../../../core/styles/app_colors.dart';
import 'package:finkeep/features/expense/presentation/widgets/widgets.dart'; // Import SegmentedTabBar and MonthSelector
import '../controllers/income_controller.dart';
import 'income_list_screen.dart';
import 'income_summary_screen.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final IncomeController controller = Get.find();
  int _selectedTab = 0; // 0 for Summary, 1 for Details

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      body: SafeArea(
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Month Selector Header
              MonthSelector(
                showSearchButton: false, // We use inline filter pill search
                onMonthChanged: (selectedMonth) {
                  controller.updateSelectedMonth(selectedMonth);
                },
                onSettingsPressed: () {
                  context.pushNamed(AppRoutes.settings);
                },
              ),

              // 2. Sliding Segmented Tab Switcher (Summary & Details)
              SegmentedTabBar(
                selectedIndex: _selectedTab,
                onTabChanged: (index) {
                  setState(() {
                    _selectedTab = index;
                  });
                },
              ),

              // 3. Tab Contents
              Expanded(
                child: _selectedTab == 0
                    ? (controller.isLoading.value
                        ? const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal))
                        : IncomeSummaryScreen(controller: controller))
                    : IncomeListScreen(controller: controller),
              ),
            ],
          );
        }),
      ),
      floatingActionButton: CustomFAB(
        onPressed: () {
          context.pushNamed(AppRoutes.addIncome);
        },
      ),
    );
  }
}
