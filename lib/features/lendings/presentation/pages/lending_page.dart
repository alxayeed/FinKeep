import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/features/lendings/presentation/widgets/error_indicator_widget.dart';
import 'package:spendly/features/lendings/presentation/widgets/lending_card_widget.dart';
import 'package:spendly/features/lendings/presentation/widgets/loading_indicator_widget.dart';

import '../controllers/lendings_controller.dart';

class LendingPage extends StatelessWidget {
  const LendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LendingController controller = Get.find();

    return Scaffold(
      appBar: AppBar(title: Text('Lendings')),
      body: Obx(() => _buildBody(controller)),
    );
  }

  Widget _buildBody(LendingController controller) {
    if (controller.isLoading.value) {
      return Center(child: LoadingIndicatorWidget());
    }

    if (controller.errorMessage.value != null) {
      return Center(
        child: ErrorIndicatorWidget(message: controller.errorMessage.value!),
      );
    }

    if (controller.lendings.isEmpty) {
      return Center(child: Text('No lendings available'));
    }

    return ListView.builder(
      itemCount: controller.lendings.length,
      itemBuilder: (context, index) {
        final lending = controller.lendings[index];
        return LendingCardWidget(lending: lending);
      },
    );
  }
}
