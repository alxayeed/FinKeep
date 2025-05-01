import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePickerFormField extends StatelessWidget {
  final String labelText;
  final DateTime? selectedDate;
  final Function(DateTime?) onDateSelected;
  final DateTime firstDate;
  final DateTime lastDate;
  final String? Function(DateTime?)? validator;
  final bool isOptional;

  const CustomDatePickerFormField({
    super.key,
    required this.labelText,
    required this.selectedDate,
    required this.onDateSelected,
    required this.firstDate,
    required this.lastDate,
    this.validator,
    this.isOptional = false,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      validator: validator,
      initialValue: selectedDate,
      builder: (FormFieldState<DateTime> state) {
        // We pass the state to the _selectDate and clear handlers
        // so they can update the FormField state correctly
        void handleDateSelection(DateTime? date) {
          onDateSelected(date);
          state.didChange(date); // Update FormField state
        }

        return InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: firstDate,
              lastDate: lastDate,
            );
            if (picked != null) {
              handleDateSelection(picked);
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: labelText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              filled: true,
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isOptional && selectedDate != null)
                    IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: 'Clear Date',
                      onPressed: () {
                        handleDateSelection(null);
                      },
                    ),
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 8),
                ],
              ),
              errorText: state.errorText,
            ),
            child: Text(
              selectedDate != null
                  ? DateFormat.yMd().format(selectedDate!)
                  : 'Select Date',
              style: TextStyle(
                color:
                    selectedDate != null ? null : Theme.of(context).hintColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
