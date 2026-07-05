import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finkeep/core/common/widgets/widgets.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/styles/app_colors.dart';
import '../../domain/entities/return_entry.dart';
import '../controller/investment_controller.dart';

class AddReturnBottomSheet extends StatefulWidget {
  final String investmentId;
  final ReturnEntry? returnEntry;

  const AddReturnBottomSheet({
    super.key,
    required this.investmentId,
    this.returnEntry,
  });

  @override
  State<AddReturnBottomSheet> createState() => _AddReturnBottomSheetState();
}

class _AddReturnBottomSheetState extends State<AddReturnBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _transactionIdController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _returnDate = DateTime.now();
  String? _medium = 'Bank Transfer';

  @override
  void initState() {
    super.initState();
    if (widget.returnEntry != null) {
      _amountController.text = widget.returnEntry!.amountReceived.toStringAsFixed(0);
      _transactionIdController.text = widget.returnEntry!.transactionId;
      _notesController.text = widget.returnEntry!.notes;
      _returnDate = widget.returnEntry!.date;
      _medium = widget.returnEntry!.medium;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _transactionIdController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color modalBg = isDark ? AppColors.cardDark : Colors.white;
    final Color textColor = isDark ? Colors.white : const Color(0xFF0F172A);

    return Container(
      decoration: BoxDecoration(
        color: modalBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom +
            MediaQuery.of(context).padding.bottom +
            24.h,
        top: 10.h,
        left: 24.w,
        right: 24.w,
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 38.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),

              Center(
                child: Text(
                  widget.returnEntry != null ? 'Edit Return Entry' : 'Add Return Entry',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              const Divider(height: 24),
              SizedBox(height: 8.h),

              // Large Centered Amount input
              AppNumberField(
                controller: _amountController,
                labelText: 'Amount Received',
                autofocus: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  if (double.tryParse(value) == null ||
                      double.parse(value) <= 0) {
                    return 'Enter a valid amount';
                  }
                  return null;
                },
              ),

              // Date Picker
              StyledDatePickerButton(
                labelText: 'Date *',
                selectedDate: _returnDate,
                onDateSelected: (date) => setState(() => _returnDate = date),
                validator: (value) =>
                    value == null ? 'This field is required' : null,
              ),
              SizedBox(height: 16.h),

              // Transaction ID
              AppTextField(
                controller: _transactionIdController,
                labelText: 'Transaction ID',
                hintText: 'e.g. TXN102938',
                prefixIcon: Icons.vpn_key_outlined,
                // validator: (value) =>
                //     value == null || value.isEmpty ? 'This field is required' : null,
              ),
              SizedBox(height: 16.h),

              StyledDropdownFormField<String>(
                value: _medium,
                labelText: 'Medium *',
                items: ['Bank Transfer', 'bKash', 'MSF', 'Other']
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: (value) => setState(() => _medium = value),
                validator: (value) =>
                    value == null ? 'Please select a method' : null,
                prefixIcon: Icons.payment,
              ),
              SizedBox(height: 16.h),

              // Notes
              AppTextField(
                controller: _notesController,
                labelText: 'Notes (Optional)',
                hintText: 'Add brief return notes...',
                prefixIcon: Icons.notes_rounded,
              ),
              SizedBox(height: 24.h),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        side: BorderSide(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white70
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        try {
                          debugPrint('AddReturnBottomSheet: Save/Add clicked');
                          final formState = _formKey.currentState;
                          if (formState == null) {
                            debugPrint('AddReturnBottomSheet: FormState is null!');
                            return;
                          }
                          final isValid = formState.validate();
                          debugPrint('AddReturnBottomSheet: Form isValid = $isValid');
                          debugPrint('AddReturnBottomSheet: Date: $_returnDate, Medium: $_medium');
                          if (!isValid) return;
                          if (_returnDate == null || _medium == null) return;

                          final isEdit = widget.returnEntry != null;
                          final newReturn = ReturnEntry(
                            id: widget.returnEntry?.id ?? DateTime.now().toIso8601String(),
                            amountReceived: double.parse(_amountController.text),
                            date: _returnDate!,
                            transactionId: _transactionIdController.text.trim(),
                            medium: _medium!,
                            notes: _notesController.text.trim(),
                          );

                          final controller = Get.find<InvestmentController>();
                          if (isEdit) {
                            controller.updateReturnEntry(
                              widget.investmentId,
                              newReturn,
                              onSuccess: () {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Return entry updated successfully!'),
                                    backgroundColor: AppColors.success,
                                  ),
                                );
                                Navigator.of(context).pop();
                              },
                              onError: (err) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to update return: $err'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              },
                            );
                          } else {
                            controller.addReturnEntry(
                              widget.investmentId,
                              newReturn,
                              onSuccess: () {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Return entry added successfully!'),
                                    backgroundColor: AppColors.success,
                                  ),
                                );
                                Navigator.of(context).pop();
                              },
                              onError: (err) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to add return: $err'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              },
                            );
                          }
                        } catch (e, stack) {
                          debugPrint('AddReturnBottomSheet Error: $e');
                          debugPrint(stack.toString());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        widget.returnEntry != null ? 'Save Return' : 'Add Return',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
