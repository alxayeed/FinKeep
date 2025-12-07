import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/features/lendings/presentation/controllers/lendings_controller.dart';
import 'package:spendly/features/lendings/presentation/widgets/lending_form_widget.dart';

class AddLendingScreen extends GetView<LendingsController> {
  const AddLendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Lending'),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          children: [
            // Error message
            Obx(() {
              if (controller.errorMessage.value != null) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    controller.errorMessage.value!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            // Lending Form
            LendingFormWidget(
              controller: controller,
              formKey: formKey,
              buttonText: 'Add Lending',
            ),
          ],
        ),
      ),
    );
  }
}
