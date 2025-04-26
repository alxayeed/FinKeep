import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/core/common/widgets/loader_widget.dart';
import 'package:spendly/features/lendings/presentation/widgets/lending_card_widget.dart';
import 'package:spendly/features/lendings/presentation/widgets/loading_indicator_widget.dart';

import '../../../../core/common/widgets/app_drawer.dart';
import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../../../core/common/widgets/error_widget.dart';
import '../controllers/lendings_controller.dart';

class LendingScreen extends StatelessWidget {
  LendingScreen({super.key});

  final LendingController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const AppDrawer(),
      body: Obx(() => _buildBody(controller)),
    );
  }

  Widget _buildBody(LendingController controller) {
    if (controller.isLoading.value) {
      return Center(child: LoadingIndicatorWidget());
    }

    if (controller.errorMessage.value != null) {
      return Center(
        child:
            ErrorIndicatorWidget(errorMessage: controller.errorMessage.value!),
      );
    }

    if (controller.lendings.isEmpty) {
      return Center(child: Text('No lendings available'));
    }
    return ErrorIndicatorWidget(
        errorMessage: controller.errorMessage.value ?? " Under Development!");

    return LoaderWidget();

    return ListView.builder(
      itemCount: controller.lendings.length,
      itemBuilder: (context, index) {
        final lending = controller.lendings[index];
        return LendingCardWidget(lending: lending);
      },
    );
  }
}
