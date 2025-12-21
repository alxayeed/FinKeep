import 'package:flutter/material.dart';
import 'package:spendly/core/common/widgets/styled_date_picker_button.dart';
import 'package:spendly/core/common/widgets/styled_text_form_field.dart';

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

  DateTime? _returnDate;
  String? _medium;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16,
        left: 16,
        right: 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Return Entry',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Amount Received
              StyledTextFormField(
                controller: _amountController,
                labelText: 'Amount Received *',
                keyboardType: TextInputType.number,
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
              const SizedBox(height: 16),

              // Date Picker
              StyledDatePickerButton(
                labelText: 'Date *',
                selectedDate: _returnDate,
                onDateSelected: (date) => setState(() => _returnDate = date),
                validator: (value) =>
                    value == null ? 'This field is required' : null,
              ),
              const SizedBox(height: 16),

              // Transaction ID
              StyledTextFormField(
                controller: _transactionIdController,
                labelText: 'Transaction ID *',
                validator: (value) => value == null || value.isEmpty
                    ? 'This field is required'
                    : null,
              ),
              const SizedBox(height: 16),

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

              const SizedBox(height: 16),

              // Notes
              StyledTextFormField(
                controller: _notesController,
                labelText: 'Notes',
              ),
              const SizedBox(height: 24),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;
                      if (_returnDate == null || _medium == null) return;

                      final newReturn = ReturnEntry(
                        id: DateTime.now().toString(),
                        amountReceived: double.parse(_amountController.text),
                        date: _returnDate!,
                        transactionId: _transactionIdController.text,
                        medium: _medium!,
                        notes: _notesController.text,
                      );

                      widget.onAddReturn(newReturn);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
