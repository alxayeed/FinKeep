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

    // Fetch repayments when screen builds
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
              final updatedLending = await Get.toNamed(AppRoutes.updateLending,
                  arguments: lending);

              if (updatedLending != null) {
                final success = await controller.updateLending(updatedLending);
                if (success) {
                  Get.snackbar('Success', 'Lending updated',
                      snackPosition: SnackPosition.BOTTOM);
                }
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_outline_rounded, color: AppColors.error),
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
            /// SUMMARY SECTION
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

            /// DETAILS (COMPACT)
            _buildCompactRow(
              title: 'Amount',
              value: amount,
              icon: Icons.currency_rupee,
              valueColor: AppColors.getColorForLendingType(lending.type),
            ),
            _buildCompactRow(
              title: 'Person',
              value: lending.person.name,
              icon: Icons.person_outline,
            ),
            _buildCompactRow(
              title: 'Type',
              value: lending.type.name.capitalizeFirst ?? lending.type.name,
              icon: Icons.swap_horiz,
            ),
            _buildCompactRow(
              title: 'Status',
              value: lending.status.name.capitalizeFirst ?? lending.status.name,
              icon: Icons.check_circle_outline,
              valueColor: AppColors.getColorForLendingStatus(lending.status),
            ),
            _buildCompactRow(
              title: 'Date Created',
              value: dateFormat.format(lending.createdDate),
              icon: Icons.calendar_today_outlined,
            ),
            _buildCompactRow(
              title: 'Due Date',
              value: lending.dueDate != null
                  ? dateFormat.format(lending.dueDate!)
                  : 'N/A',
              icon: Icons.event_busy_outlined,
            ),
            _buildCompactRow(
              title: 'Description',
              value: lending.description?.isNotEmpty ?? false
                  ? lending.description!
                  : 'N/A',
              icon: Icons.notes_rounded,
              isMultiline: true,
            ),

            /// REPAYMENT HISTORY SECTION
            const SizedBox(height: 20),
            const Text(
              'Repayment History',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppColors.darkGrey),
            ),
            const SizedBox(height: 10),
            Obx(() {
              if (controller.repaymentsList.isEmpty) {
                return const Text(
                  'No repayments yet.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                );
              }
              return Column(
                children: controller.repaymentsList.map((RepaymentEntity r) {
                  final paidDate = dateFormat.format(r.paidDate);
                  final amount = currencyFormat.format(r.amount);
                  return _buildCompactRow(
                    title: paidDate,
                    value: amount,
                    icon: Icons.payment_outlined,
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactRow({
    required String title,
    required String value,
    required IconData icon,
    Color? valueColor,
    bool isMultiline = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.6),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.grey.shade500,
          ),
          const SizedBox(width: 12),
          Text(
            '$title:',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Color(0xFF616161),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: valueColor ?? const Color(0xFF424242),
                fontWeight:
                    valueColor != null ? FontWeight.w600 : FontWeight.w400,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
