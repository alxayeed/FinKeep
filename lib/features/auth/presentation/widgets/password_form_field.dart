import 'package:flutter/material.dart';
import 'package:spendly/core/responsive/responsive.dart';

class PasswordFormField extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? Function(String?)? validator;

  const PasswordFormField({
    super.key,
    required this.controller,
    this.labelText,
    this.validator,
  });

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 60.hc(min: 50, max: 65),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: widget.labelText ?? 'Password',
          labelStyle: TextStyle(fontSize: 14.sp),
          prefixIcon: Icon(
            Icons.lock,
            color: theme.colorScheme.primary,
            size: 24.r,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: theme.colorScheme.primary,
              size: 24.r,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
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
            widget.validator ??
            (value) {
              if (value == null || value.isEmpty) return ' ';
              if (value.length < 6) return ' ';
              return null;
            },
      ),
    );
  }
}
