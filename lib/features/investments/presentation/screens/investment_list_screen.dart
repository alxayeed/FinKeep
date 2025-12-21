import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:spendly/core/routes/app_router.dart';

import '../../../../core/common/widgets/custom_app_bar.dart';
import '../controller/investment_controller.dart';
import '../widgets/investment_item.dart';
import 'add_investment_screen.dart';

class InvestmentListScreen extends StatelessWidget {
  const InvestmentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InvestmentController>();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Investments'),
      body: Obx(() {
        if (controller.investments.isEmpty) {
          return const Center(child: Text('No investments yet. Add one!'));
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchInvestments();
          },
          child: ListView.builder(
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
