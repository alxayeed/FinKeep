import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:spendly/core/common/widgets/no_data_widget.dart';
import 'package:spendly/core/responsive/responsive.dart';
import 'package:spendly/core/routes/app_router.dart';
import 'package:spendly/core/styles/app_colors.dart';

import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../../../core/common/widgets/custom_fab.dart';
import '../../../../core/common/widgets/error_widget.dart';
import '../controller/investment_controller.dart';
import '../widgets/investment_item.dart';
import '../widgets/investment_shimmer_list.dart';
import 'add_investment_screen.dart';

class InvestmentListScreen extends StatelessWidget {
  const InvestmentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InvestmentController>();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Investments'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const InvestmentShimmerList();
        }

        return RefreshIndicator(
          color: AppColors.primaryTeal,
          onRefresh: () async {
            await controller.fetchInvestments();
          },
          child: Builder(
            builder: (context) {
              if (controller.errorMessage.isNotEmpty) {
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

              if (controller.investments.isEmpty) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 150.h),
                    const Center(child: NoDataWidget()),
                  ],
                );
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                itemCount: controller.investments.length,
                itemBuilder: (context, index) {
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
            },
          ),
        );
      }),
      floatingActionButton: CustomFAB(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddInvestmentScreen(
                onSubmit: (investment) {
                  controller.addInvestment(investment);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
