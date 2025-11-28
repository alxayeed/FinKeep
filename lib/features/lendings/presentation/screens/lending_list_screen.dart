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
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: controller.refreshLendings,
        child: Obx(() => _buildContent(context)),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
        onPressed: () {
          Get.toNamed('/addLending');
        },
        tooltip: 'Add Lending',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
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
      return const Center(
        child: NoDataWidget(),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: controller.lendingsList.length,
      itemBuilder: (context, index) {
        final lending = controller.lendingsList[index];
        // LendingListItem handles its own onTap navigation now
        return LendingListItem(lending: lending);
      },
    );
  }
}
