import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final ButtonStyle? style;
  final double indicatorSize;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.style,
    this.indicatorSize = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: style,
      // Disable button when loading or if onPressed is null externally
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? SizedBox(
              width: indicatorSize,
              height: indicatorSize,
              child: CircularProgressIndicator.adaptive(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.onPrimary, // Indicator color
                ),
              ),
            )
          : Text(text),
    );
  }
}
