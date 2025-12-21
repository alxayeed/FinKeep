import 'package:flutter/material.dart';

class CustomDatePicker extends StatefulWidget {
  final String labelText;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final String? Function(DateTime?)? validator;

  const CustomDatePicker({
    super.key,
    required this.labelText,
    this.selectedDate,
    required this.onDateSelected,
    this.validator,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      initialValue: _selectedDate,
      validator: widget.validator,
      builder: (FormFieldState<DateTime> state) {
        return InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: state.value ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (picked != null) {
              state.didChange(picked);
              widget.onDateSelected(picked);
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: widget.labelText,
              border: const OutlineInputBorder(),
              errorText: state.errorText,
            ),
            child: Text(
              state.value != null
                  ? '${state.value!.toLocal()}'.split(' ')[0]
                  : 'Select date',
            ),
          ),
        );
      },
    );
  }
}
