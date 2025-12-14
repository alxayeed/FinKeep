import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:spendly/core/styles/app_colors.dart';
import 'package:spendly/features/lendings/presentation/controllers/lendings_controller.dart';
import 'package:spendly/features/lendings/presentation/screens/repayment_list_widget.dart';

import '../../../../core/routes/app_router.dart';
import '../../domain/entity/lending/lending_entity.dart';

class LendingDetailsScreen extends StatefulWidget {
  final LendingEntity lending;

  const LendingDetailsScreen({super.key, required this.lending});

  @override
  State<LendingDetailsScreen> createState() => _LendingDetailsScreenState();
}

class _LendingDetailsScreenState extends State<LendingDetailsScreen> {
  final LendingsController controller = Get.find<LendingsController>();

  Future<void> _handleDeleteLending(BuildContext context) async {
    await controller.deleteLending(
      widget.lending.id,
      onSuccess: () {
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lending record successfully deleted!'),
            backgroundColor: Colors.green,
          ),
        );

        context.pop();
      },
      onError: (e) {
        if (!context.mounted) return;

        final errorMessage = e?.toString() ?? 'An unknown error occurred.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete lending: $errorMessage'),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  }

  double calculatePaidAmount() {
    return controller.repaymentsList.fold<double>(
      0,
      (sum, r) => sum + r.amount,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '৳');
    final dateFormat = DateFormat('dd MMM, yyyy');

    controller.fetchRepayments(widget.lending.id);

    final isGiven = widget.lending.type == LendingType.given;
    final personName = widget.lending.person.name;
    final amount = currencyFormat.format(widget.lending.amount);
    final createdDate = dateFormat.format(widget.lending.createdDate);

    String summary = "You ${isGiven ? 'gave' : 'took'} $amount "
        "${isGiven ? 'to' : 'from'} $personName on $createdDate.";

    if (widget.lending.status == LendingStatus.paid) {
      summary += " This amount has already been fully repaid.";
    } else if (widget.lending.dueDate != null) {
      final dueDate = dateFormat.format(widget.lending.dueDate!);
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
            onPressed: () async {
              await context.pushNamed(
                AppRoutes.updateLending,
                extra: widget.lending,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded,
                color: AppColors.error),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete Lending'),
                  content: const Text(
                      'Are you sure you want to delete this lending record?'),
                  actions: [
                    TextButton(
                        onPressed: () => context.pop(false),
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () => context.pop(true),
                        child: const Text('Delete')),
                  ],
                ),
              );

              if (confirm == true) {
                await _handleDeleteLending(context);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          /// --- TOP SUMMARY SECTION ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryTeal.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          color: AppColors.primaryTealDark),
                      const SizedBox(width: 10),
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
                    childAspectRatio: 3.4,
                  ),
                  children: [
                    // _buildGridItem('', amount, Icons.call_made),
                    // _buildGridItem(
                    //     '',
                    //     currencyFormat.format(calculatePaidAmount()),
                    //     Icons.call_received),
                    _buildGridItem(
                        'Type',
                        widget.lending.type.name.capitalizeFirst ??
                            widget.lending.type.name,
                        Icons.swap_horiz),
                    _buildGridItem(
                        'Status',
                        widget.lending.status.name.capitalizeFirst ??
                            widget.lending.status.name,
                        Icons.check_circle_outline,
                        valueColor: AppColors.getColorForLendingStatus(
                            widget.lending.status)),
                    _buildGridItem(
                        '',
                        dateFormat.format(widget.lending.createdDate),
                        Icons.calendar_today_outlined),
                    _buildGridItem(
                        '',
                        widget.lending.dueDate != null
                            ? dateFormat.format(widget.lending.dueDate!)
                            : 'N/A',
                        Icons.event_busy_outlined),
                  ],
                ),
              ],
            ),
          ),

          /// --- REPAYMENT SECTION ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Column(
                children: [
                  /// Progress header

                  Expanded(
                    child: RepaymentListWidget(lending: widget.lending),
                  ),
                ],
              ),
            ),
          ),
        ],
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
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              title.isNotEmpty ? '$title: $value' : value,
              style: TextStyle(
                fontSize: 14,
                fontWeight:
                    valueColor != null ? FontWeight.w600 : FontWeight.w400,
                color: valueColor ?? const Color(0xFF212121),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
