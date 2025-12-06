import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/core/common/widgets/app_drawer.dart';
import 'package:spendly/core/common/widgets/custom_app_bar.dart';
import 'package:spendly/core/common/widgets/error_widget.dart';
import 'package:spendly/core/common/widgets/loader_widget.dart';
import 'package:spendly/core/common/widgets/no_data_widget.dart';
import 'package:spendly/core/styles/app_colors.dart';
import 'package:spendly/features/lendings/presentation/controllers/lendings_controller.dart';
import 'package:spendly/features/lendings/presentation/widgets/lending_list_item.dart';

class LendingListScreen extends GetView<LendingsController> {
  const LendingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Lendings'),
      drawer: const AppDrawer(),
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
            padding: const EdgeInsets.only(bottom: 80, top: 8),
            itemCount: controller.lendingsList.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final lending = controller.lendingsList[index];
              return LendingListItem(lending: lending);
            },
          );
        }),
      ),
      floatingActionButton: Obx(() {
        return FloatingActionButton(
          backgroundColor:
              controller.isLoading.value ? Colors.grey : AppColors.primaryTeal,
          foregroundColor: Colors.white,
          onPressed: controller.isLoading.value
              ? null
              : () => Get.toNamed('/addLending'),
          tooltip: 'Add Lending',
          child: const Icon(Icons.add),
        );
      }),
    );
  }
}
