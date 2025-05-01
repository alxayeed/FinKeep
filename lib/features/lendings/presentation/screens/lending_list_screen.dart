import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/core/common/widgets/app_drawer.dart';
import 'package:spendly/core/common/widgets/custom_app_bar.dart';
import 'package:spendly/core/common/widgets/error_widget.dart';
import 'package:spendly/core/common/widgets/loader_widget.dart';
import 'package:spendly/features/lendings/presentation/controllers/lending_list_controller.dart';
import 'package:spendly/features/lendings/presentation/widgets/lending_list_item.dart';

class LendingListScreen extends GetView<LendingListController> {
  const LendingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Lendings'),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: controller.refreshLendings,
        child: Obx(() => _buildContent(context)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/addLending');
        },
        tooltip: 'Add Lending',
        child: const Icon(Icons.add),
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
          // onRetry: controller
          //     .fetchLendings, // Ensure ErrorIndicatorWidget accepts onRetry
        ),
      );
    }

    if (controller.lendingsList.isEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: const Center(
                  child: Text(
                'No lendings recorded yet.\nTap + to add one!',
                textAlign: TextAlign.center,
              )),
            ),
          );
        },
      );
    }

    return ListView.builder(
      itemCount: controller.lendingsList.length,
      itemBuilder: (context, index) {
        final lending = controller.lendingsList[index];
        return LendingListItem(
          lending: lending,
          onTap: () {
            print('Tapped on: ${lending.personName}');
          },
        );
      },
    );
  }
}
