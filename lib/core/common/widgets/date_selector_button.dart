import 'package:flutter/material.dart';

class DateSelectorButton extends StatelessWidget {
  final String title;
  final String dateText;
  final VoidCallback onTap;

  const DateSelectorButton({
    super.key,
    required this.title,
    required this.dateText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Card(
          elevation: 1,
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  child: Text(
                    dateText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
