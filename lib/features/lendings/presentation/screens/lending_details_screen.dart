import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spendly/core/styles/app_colors.dart';
import 'package:spendly/features/lendings/presentation/controllers/lendings_controller.dart';

import '../../domain/entity/lending/lending_entity.dart';

class LendingDetailsScreen extends StatelessWidget {
  final LendingEntity lending;
  final LendingsController controller = Get.find<LendingsController>();

  LendingDetailsScreen({super.key, required this.lending});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '৳');
    final dateFormat = DateFormat.yMd();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lending Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note_rounded,
                color: AppColors.primaryTealDark),
            tooltip: 'Edit Lending',
            onPressed: () {
              Get.snackbar('Info', 'Edit functionality not implemented yet.');
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
            _buildDetailItem(
              title: 'Amount',
              value: currencyFormat.format(lending.amount),
              icon: Icons.currency_rupee,
              valueColor: AppColors.getColorForLendingType(lending.type),
            ),
            const Divider(thickness: 1, height: 1),
            _buildDetailItem(
              title: 'Person',
              value: lending.person.name,
              icon: Icons.person_outline,
            ),
            const Divider(thickness: 1, height: 1),
            _buildDetailItem(
              title: 'Type',
              value: lending.type.name.capitalizeFirst ?? lending.type.name,
              icon: Icons.swap_horiz,
            ),
            const Divider(thickness: 1, height: 1),
            _buildDetailItem(
              title: 'Status',
              value: lending.status.name.capitalizeFirst ?? lending.status.name,
              icon: Icons.check_circle_outline,
              valueColor: AppColors.getColorForLendingStatus(lending.status),
            ),
            const Divider(thickness: 1, height: 1),
            _buildDetailItem(
              title: 'Date Created',
              value: dateFormat.format(lending.createdDate),
              icon: Icons.calendar_today_outlined,
            ),
            const Divider(thickness: 1, height: 1),
            _buildDetailItem(
              title: 'Due Date',
              value: lending.dueDate != null
                  ? dateFormat.format(lending.dueDate!)
                  : 'N/A',
              icon: Icons.event_busy_outlined,
            ),
            const Divider(thickness: 1, height: 1),
            _buildDetailItem(
              title: 'Description',
              value: lending.description?.isNotEmpty ?? false
                  ? lending.description!
                  : 'N/A',
              icon: Icons.notes_rounded,
              isMultiline: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required String title,
    required String value,
    required IconData icon,
    Color? valueColor,
    bool isMultiline = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.darkGrey, size: 20),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.darkGrey,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    color: valueColor ?? AppColors.black.withValues(alpha: 0.5),
                    fontWeight: valueColor != null
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                  softWrap: isMultiline,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
