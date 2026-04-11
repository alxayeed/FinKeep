import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:spendly/core/common/widgets/custom_app_bar.dart';
import 'package:spendly/core/common/widgets/error_widget.dart';
import 'package:spendly/core/common/widgets/loader_widget.dart';
import 'package:spendly/core/common/widgets/no_data_widget.dart';
import 'package:spendly/core/routes/app_router.dart';
import 'package:spendly/features/lendings/presentation/controllers/lendings_controller.dart';
import 'package:spendly/features/lendings/presentation/widgets/lending_list_item.dart';

import '../../../expense/presentation/widgets/custom_fab.dart';

class LendingListScreen extends GetView<LendingsController> {
  const LendingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Lendings'),
      body: RefreshIndicator(
        onRefresh: controller.refreshLendings,
        child: Obx(() {
          if (controller.isLoading.value && controller.lendingsList.isEmpty) {
            return const Center(child: LoaderWidget());
          }
          if (controller.errorMessage.value != null) {
            return Center(
              child: ErrorIndicatorWidget(
                errorMessage: controller.errorMessage.value!,
              ),
            );
          }
          if (controller.lendingsList.isEmpty) {
            return const Center(child: NoDataWidget());
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.lendingsList.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              if (index == 0) {
                return LendingSummaryWidget(
                  givenDue: controller.totalGivenDue,
                  receivedDue: controller.totalReceivedDue,
                );
              }
              final lending = controller.lendingsList[index - 1];
              return LendingListItem(lending: lending);
            },
          );
        }),
      ),
      floatingActionButton: CustomFAB(
        onPressed: () => context.pushNamed(AppRoutes.addLending),
      ),
    );
  }
}

class LendingSummaryWidget extends StatelessWidget {
  final double givenDue;
  final double receivedDue;

  const LendingSummaryWidget({
    super.key,
    required this.givenDue,
    required this.receivedDue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDueItem("You'll get", givenDue, Colors.green.shade700),
          Container(width: 1, height: 40, color: Colors.teal.shade100),
          _buildDueItem("You owe", receivedDue, Colors.red.shade700),
        ],
      ),
    );
  }

  Widget _buildDueItem(String label, double amount, Color amountColor) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        const SizedBox(height: 4),
        Text(
          "${NumberFormat.simpleCurrency(name: '').format(amount)} ৳",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: amountColor,
          ),
        ),
      ],
    );
  }
}
