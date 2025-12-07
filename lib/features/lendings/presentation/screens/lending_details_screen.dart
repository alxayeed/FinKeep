import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spendly/core/styles/app_colors.dart';
import 'package:spendly/features/lendings/presentation/controllers/lendings_controller.dart';

import '../../../../core/routes/app_routes.dart';
import '../../domain/entity/lending/lending_entity.dart';
import '../../domain/entity/repayment/repayment_entity.dart';

class LendingDetailsScreen extends StatelessWidget {
  final LendingEntity lending;
  final LendingsController controller = Get.find<LendingsController>();

  LendingDetailsScreen({super.key, required this.lending});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '৳');
    final dateFormat = DateFormat('dd MMMM, yyyy');

    controller.fetchRepayments(lending.id);

    final isGiven = lending.type == LendingType.given;
    final personName = lending.person.name;
    final amount = currencyFormat.format(lending.amount);
    final createdDate = dateFormat.format(lending.createdDate);

    String summary = "You ${isGiven ? 'gave' : 'took'} $amount "
        "${isGiven ? 'to' : 'from'} $personName on $createdDate.";

    if (lending.status == LendingStatus.paid) {
      summary += " This amount has already been fully repaid.";
    } else if (lending.dueDate != null) {
      final dueDate = dateFormat.format(lending.dueDate!);
      summary += " Repayment is due by $dueDate.";
    } else {
      summary += " No repayment date has been set yet.";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lending Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note_rounded,
                color: AppColors.primaryTealDark),
            tooltip: 'Edit Lending',
            onPressed: () async {
              final updatedLending = await Get.toNamed(
                AppRoutes.updateLending,
                arguments: lending,
              );
              if (updatedLending != null) {
                final success = await controller.updateLending(updatedLending);
                if (success) {
                  Get.snackbar(
                    'Success',
                    'Lending updated',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded,
                color: AppColors.error),
            tooltip: 'Delete Lending',
            onPressed: () async {
              final confirm = await Get.dialog<bool>(
                AlertDialog(
                  title: const Text('Delete Lending'),
                  content: const Text(
                      'Are you sure you want to delete this lending record? This action cannot be undone.'),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(result: false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: AppColors.error),
                      onPressed: () => Get.back(result: true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await controller.deleteLending(lending.id);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.primaryTeal.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: AppColors.primaryTealDark),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      summary,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 12,
                childAspectRatio: 3.2,
              ),
              children: [
                _buildGridItem('Amount', amount, Icons.currency_rupee,
                    valueColor: AppColors.getColorForLendingType(lending.type)),
                _buildGridItem(
                    'Person', lending.person.name, Icons.person_outline),
                _buildGridItem(
                    'Type',
                    lending.type.name.capitalizeFirst ?? lending.type.name,
                    Icons.swap_horiz),
                _buildGridItem(
                    'Status',
                    lending.status.name.capitalizeFirst ?? lending.status.name,
                    Icons.check_circle_outline,
                    valueColor:
                        AppColors.getColorForLendingStatus(lending.status)),
                _buildGridItem('', dateFormat.format(lending.createdDate),
                    Icons.calendar_today_outlined),
                _buildGridItem(
                    '',
                    lending.dueDate != null
                        ? dateFormat.format(lending.dueDate!)
                        : 'N/A',
                    Icons.event_busy_outlined),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Description',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.darkGrey,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.subtleBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                lending.description?.isNotEmpty ?? false
                    ? lending.description!
                    : 'No description provided.',
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Repayment History',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.darkGrey,
              ),
            ),
            const SizedBox(height: 12),
            Obx(() {
              if (controller.repaymentsList.isEmpty) {
                return const Text(
                  'No repayments yet.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                );
              }
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.subtleBackground,
                ),
                height: 220,
                child: ListView.separated(
                  itemCount: controller.repaymentsList.length,
                  separatorBuilder: (_, __) => const Divider(height: 16),
                  itemBuilder: (context, index) {
                    final RepaymentEntity r = controller.repaymentsList[index];
                    final paidDate = dateFormat.format(r.paidDate);
                    final amount = currencyFormat.format(r.amount);
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          paidDate,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          amount,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryTealDark),
                        ),
                      ],
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(String title, String value, IconData icon,
      {Color? valueColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.subtleBackground,
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight:
                  valueColor != null ? FontWeight.w600 : FontWeight.w400,
              color: valueColor ?? const Color(0xFF212121),
            ),
          ),
        ],
      ),
    );
  }
}
