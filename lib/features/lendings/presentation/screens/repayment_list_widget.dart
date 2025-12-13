import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart'; // Added for context.pop() in dialogs
import 'package:intl/intl.dart';

import '../../../../core/common/widgets/styled_date_picker_button.dart';
import '../../../../core/common/widgets/styled_elevated_button.dart';
import '../../../../core/common/widgets/styled_text_form_field.dart';
import '../../../../core/styles/app_colors.dart';
import '../../domain/entity/lending/lending_entity.dart';
import '../../domain/entity/repayment/repayment_entity.dart';
import '../controllers/lendings_controller.dart';
import '../widgets/repayment_item_widget.dart';

class RepaymentListWidget extends StatefulWidget {
  final LendingEntity lending;

  const RepaymentListWidget({super.key, required this.lending});

  @override
  State<RepaymentListWidget> createState() => _RepaymentListWidgetState();
}

class _RepaymentListWidgetState extends State<RepaymentListWidget> {
  final LendingsController controller = Get.find<LendingsController>();

  @override
  void initState() {
    super.initState();
    controller.fetchRepayments(widget.lending.id);
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '৳');
    final dateFormat = DateFormat('dd MMM, yyyy');

    double calculateDueAmount() {
      final paid = controller.repaymentsList.fold<double>(
        0,
        (sum, r) => sum + r.amount,
      );
      return widget.lending.amount - paid;
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryTeal.withValues(alpha: 0.06),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Repayment History',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppColors.darkGrey,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline,
                          color: AppColors.primaryTealDark),
                      onPressed: () => _showRepaymentForm(context),
                    ),
                  ],
                ),
                Obx(() {
                  final dueAmount = calculateDueAmount();
                  return DueAmountBanner(
                    dueAmount: dueAmount,
                    currencyFormat: currencyFormat,
                  );
                }),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.repaymentsList.isEmpty) {
                return const Center(
                  child: Text(
                    'No repayments yet.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.repaymentsList.length,
                itemBuilder: (context, index) {
                  final repayment = controller.repaymentsList[index];
                  return Dismissible(
                    key: ValueKey(repayment.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: AppColors.error,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete Repayment'),
                          content: const Text(
                              'Are you sure you want to delete this repayment?'),
                          actions: [
                            TextButton(
                                onPressed: () => context.pop(false),
                                child: const Text('Cancel')),
                            TextButton(
                              style: TextButton.styleFrom(
                                  foregroundColor: AppColors.error),
                              onPressed: () => context.pop(true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await controller.deleteRepayment(repayment);
                      }

                      return confirm ?? false;
                    },
                    child: RepaymentItemWidget(
                      repayment: repayment,
                      onEdit: () =>
                          _showRepaymentForm(context, repayment: repayment),
                      currencyFormat: currencyFormat,
                      dateFormat: dateFormat,
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showRepaymentForm(BuildContext context, {RepaymentEntity? repayment}) {
    final isEdit = repayment != null;
    final amountController =
        TextEditingController(text: repayment?.amount.toString() ?? '');
    final dateController = Rx<DateTime?>(repayment?.paidDate);
    final notesController = TextEditingController(text: repayment?.notes ?? '');
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (modalContext) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(modalContext).viewInsets.bottom + 16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  StyledTextFormField(
                    controller: amountController,
                    labelText: 'Amount',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Enter amount';
                      if (double.tryParse(val) == null ||
                          double.parse(val) <= 0) {
                        return 'Invalid amount';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    return StyledDatePickerButton(
                      labelText: 'Paid Date',
                      selectedDate: dateController.value,
                      onDateSelected: (date) => dateController.value = date,
                    );
                  }),
                  const SizedBox(height: 16),
                  StyledTextFormField(
                    controller: notesController,
                    labelText: 'Notes (Optional)',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 24),
                  StyledElevatedButton(
                    text: isEdit ? 'Update' : 'Add',
                    onPressed: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        final enteredAmount =
                            double.parse(amountController.text);
                        final totalPaid = controller.repaymentsList
                            .fold<double>(
                                0,
                                (sum, r) =>
                                    sum +
                                    (r.id == repayment?.id ? 0 : r.amount));
                        final dueAmount = widget.lending.amount - totalPaid;

                        if (!isEdit && dueAmount <= 0) {
                          await showDialog(
                            context: modalContext,
                            builder: (ctx) => AlertDialog(
                              title: const Text('No due left'),
                              content: const Text(
                                  'This lending has already been fully repaid.'),
                              actions: [
                                TextButton(
                                    onPressed: () => modalContext.pop(),
                                    child: const Text('OK')),
                              ],
                            ),
                          );
                          if (!mounted) return;
                          return;
                        }

                        bool allowProceed = true;
                        if (!isEdit && enteredAmount > dueAmount) {
                          allowProceed = await showDialog<bool>(
                                context: modalContext,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Overpayment Warning'),
                                  content: Text(
                                      'The due amount is ${NumberFormat.currency(locale: 'en_IN', symbol: '৳').format(dueAmount)}. '
                                      'You are about to pay ${NumberFormat.currency(locale: 'en_IN', symbol: '৳').format(enteredAmount)}. '
                                      'Do you want to proceed?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            modalContext.pop(false),
                                        child: const Text('Cancel')),
                                    TextButton(
                                        onPressed: () => modalContext.pop(true),
                                        child: const Text('Proceed')),
                                  ],
                                ),
                              ) ??
                              false;
                        }

                        if (!allowProceed) return;

                        if (!mounted) return;

                        final newRepayment = RepaymentEntity(
                          id: repayment?.id ?? UniqueKey().toString(),
                          lendingId: widget.lending.id,
                          userId: "dummy_user",
                          amount: enteredAmount,
                          paidDate: dateController.value ?? DateTime.now(),
                          notes: notesController.text.trim().isEmpty
                              ? null
                              : notesController.text.trim(),
                        );

                        if (isEdit) {
                          await controller.updateRepayment(newRepayment);
                        } else {
                          await controller.addRepayment(newRepayment);
                        }

                        if (!mounted) return;

                        modalContext.pop();
                      }
                    },
                    icon: isEdit ? Icons.edit : Icons.add,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class DueAmountBanner extends StatelessWidget {
  final double dueAmount;
  final NumberFormat currencyFormat;

  const DueAmountBanner({
    super.key,
    required this.dueAmount,
    required this.currencyFormat,
  });

  @override
  Widget build(BuildContext context) {
    String text;
    Color color;

    if (dueAmount > 0) {
      text = 'Due: ${currencyFormat.format(dueAmount)}';
      color = AppColors.lendingGiven;
    } else if (dueAmount < 0) {
      text = 'Extra Paid: ${currencyFormat.format(dueAmount.abs())}';
      color = Colors.green.shade600;
    } else {
      text = 'No due left';
      color = Colors.grey.shade600;
    }

    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 15,
        color: color,
      ),
    );
  }
}
