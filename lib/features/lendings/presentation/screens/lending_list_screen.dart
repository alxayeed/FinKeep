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

import '../../../../core/styles/app_colors.dart';
import '../../../expense/presentation/widgets/custom_fab.dart';
import '../../domain/entity/lending/lending_entity.dart';

class LendingListScreen extends GetView<LendingsController> {
  const LendingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '৳');

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

          // --- Calculate summary ---
          double totalGiven = 0;
          double totalReceived = 0;
          double givenRepaid = 0;
          double receivedRepaid = 0;

          for (var l in controller.lendingsList) {
            if (l.type == LendingType.given) {
              totalGiven += l.amount;
              givenRepaid +=
                  l.repayments?.fold(0.0, (sum, r) => sum! + r.amount) ?? 0;
            } else {
              totalReceived += l.amount;
              receivedRepaid +=
                  l.repayments?.fold(0.0, (sum, r) => sum! + r.amount) ?? 0;
            }
          }

          final totalGivenLeft = totalGiven - givenRepaid;
          final totalReceivedLeft = totalReceived - receivedRepaid;

          return ListView.separated(
            padding:
                const EdgeInsets.only(bottom: 80, top: 8, left: 16, right: 16),
            itemCount: controller.lendingsList.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              if (index == 0) {
                // Show summary at top
                return LendingSummaryWidget(
                  totalGiven: totalGiven,
                  givenRepaid: givenRepaid,
                  totalGivenLeft: totalGivenLeft,
                  totalReceived: totalReceived,
                  receivedRepaid: receivedRepaid,
                  totalReceivedLeft: totalReceivedLeft,
                  currencyFormat: currencyFormat,
                );
              }

              final lending = controller.lendingsList[index - 1];
              return LendingListItem(lending: lending);
            },
          );
        }),
      ),
      floatingActionButton: CustomFAB(
        onPressed: () {
          context.pushNamed(AppRoutes.addLending);
        },
      ),
    );
  }
}

// --- Reusable summary widget ---
class LendingSummaryWidget extends StatelessWidget {
  final double totalGiven;
  final double givenRepaid;
  final double totalGivenLeft;
  final double totalReceived;
  final double receivedRepaid;
  final double totalReceivedLeft;
  final NumberFormat currencyFormat;

  const LendingSummaryWidget({
    super.key,
    required this.totalGiven,
    required this.givenRepaid,
    required this.totalGivenLeft,
    required this.totalReceived,
    required this.receivedRepaid,
    required this.totalReceivedLeft,
    required this.currencyFormat,
  });

  @override
  Widget build(BuildContext context) {
    final givenColor = Colors.black54;
    final takenColor = Colors.black54;

    TextSpan numberText(double value) => TextSpan(
          text: currencyFormat.format(value),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black, // bold numbers in black
          ),
        );

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.07),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded,
              color: AppColors.primaryTealDark),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.3,
                  fontWeight: FontWeight.w400,
                ),
                children: [
                  // --- Given part ---
                  TextSpan(
                    text: "You have given ",
                    style: TextStyle(color: givenColor),
                  ),
                  numberText(totalGiven),
                  TextSpan(
                    text: ", of which ",
                    style: TextStyle(color: givenColor),
                  ),
                  numberText(givenRepaid),
                  TextSpan(
                    text: " has been repaid and ",
                    style: TextStyle(color: givenColor),
                  ),
                  numberText(totalGivenLeft),
                  TextSpan(
                    text: " is left. ",
                    style: TextStyle(color: givenColor),
                  ),

                  // --- Taken part ---
                  TextSpan(
                    text: "You have taken ",
                    style: TextStyle(color: takenColor),
                  ),
                  numberText(totalReceived),
                  TextSpan(
                    text: ", of which ",
                    style: TextStyle(color: takenColor),
                  ),
                  numberText(receivedRepaid),
                  TextSpan(
                    text: " has been repaid and ",
                    style: TextStyle(color: takenColor),
                  ),
                  numberText(totalReceivedLeft),
                  TextSpan(
                    text: " is left.",
                    style: TextStyle(color: takenColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
