import 'package:flutter/material.dart';
import 'package:spendly/core/common/widgets/styled_date_picker_button.dart';
import 'package:spendly/core/common/widgets/styled_text_form_field.dart';
import 'package:spendly/core/responsive/responsive.dart';
import 'package:spendly/core/styles/app_colors.dart';

import '../../../../core/common/widgets/styled_dropdown_form_field.dart';
import '../../domain/entities/return_entry.dart';

class AddReturnBottomSheet extends StatefulWidget {
  final Function(ReturnEntry) onAddReturn;

  const AddReturnBottomSheet({super.key, required this.onAddReturn});

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
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
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
                  'Add Return Entry',
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

              // Amount Received
              StyledTextFormField(
                controller: _amountController,
                labelText: 'Amount Received *',
                hintText: '0.00',
                prefixIcon: Icons.attach_money_rounded,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  if (double.tryParse(value) == null ||
                      double.parse(value) <= 0) {
                    return 'Enter a valid amount';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

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
              StyledTextFormField(
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
              StyledTextFormField(
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
                        if (!_formKey.currentState!.validate()) return;
                        if (_returnDate == null || _medium == null) return;

                        final newReturn = ReturnEntry(
                          id: DateTime.now().toIso8601String(),
                          amountReceived: double.parse(_amountController.text),
                          date: _returnDate!,
                          transactionId: _transactionIdController.text.trim(),
                          medium: _medium!,
                          notes: _notesController.text.trim(),
                        );

                        widget.onAddReturn(newReturn);
                        Navigator.of(context).pop();
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
                        'Add Return',
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
