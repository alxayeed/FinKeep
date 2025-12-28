import 'package:flutter/material.dart';
import 'package:spendly/core/responsive/responsive.dart';

class EmailFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? Function(String?)? validator;

  const EmailFormField({
    super.key,
    required this.controller,
    this.labelText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 60.hc(min: 50, max: 65),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: labelText ?? 'Email',
          labelStyle: TextStyle(fontSize: 14.sp),
          prefixIcon: Icon(
            Icons.email,
            color: theme.colorScheme.primary,
            size: 24.r,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: theme.dividerColor, width: 1.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 1.5.r,
            ),
          ),
          errorStyle: const TextStyle(height: 0, fontSize: 0),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 16.hc(),
          ),
        ),
        validator:
            validator ??
            (value) {
              if (value == null || value.isEmpty) return ' ';
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return ' ';
              return null;
            },
      ),
    );
  }
}
