import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:spendly/core/common/widgets/no_data_widget.dart';
import 'package:spendly/core/routes/app_router.dart';

import '../../../../core/common/widgets/custom_app_bar.dart';
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

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: ErrorIndicatorWidget(
              errorMessage: controller.errorMessage.value,
              onRetry: () async {
                await controller.fetchInvestments();
              },
            ),
          );
        }

        if (controller.investments.isEmpty) {
          return const Center(child: NoDataWidget());
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchInvestments();
          },
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
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
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
