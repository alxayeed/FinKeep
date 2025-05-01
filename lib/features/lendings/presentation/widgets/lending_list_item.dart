import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date and currency formatting

import '../../domain/entity/lend_entity.dart';

class LendingListItem extends StatelessWidget {
  final LendingEntity lending;
  final VoidCallback? onTap; // Optional: For handling taps on the item

  const LendingListItem({
    super.key,
    required this.lending,
    this.onTap,
  });

  // Helper to get icon based on type
  IconData _getTypeIcon(LendingType type) {
    switch (type) {
      case LendingType.given:
        return Icons.arrow_upward_rounded; // Or Icons.redo_rounded
      case LendingType.taken:
        return Icons.arrow_downward_rounded; // Or Icons.undo_rounded
    }
  }

  // Helper to get color based on type
  Color _getTypeColor(LendingType type, BuildContext context) {
    switch (type) {
      case LendingType.given:
        // Consider using Theme colors for consistency
        return Colors.redAccent; // Money out
      case LendingType.taken:
        return Colors.green; // Money in
    }
  }

  // Helper to get color based on status
  Color _getStatusColor(LendingStatus status, BuildContext context) {
    switch (status) {
      case LendingStatus.due:
        return Colors.orangeAccent;
      case LendingStatus.paid:
        return Colors.lightGreen;
      case LendingStatus.dismissed:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typeColor = _getTypeColor(lending.type, context);
    final statusColor = _getStatusColor(lending.status, context);

    // Formatter for currency (adjust locale and symbol as needed)
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '৳');
    // Formatter for date
    final dateFormat = DateFormat.yMd(); // e.g., 5/15/2024

    return Card(
      // Or use InkWell directly on ListTile for ripple effect
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: typeColor.withOpacity(0.15),
          child: Icon(
            _getTypeIcon(lending.type),
            color: typeColor,
            size: 24,
          ),
        ),
        title: Text(
          lending.personName,
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Status Chip/Text
            Container(
              margin: const EdgeInsets.only(top: 4.0, bottom: 4.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text(
                lending.status.name.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: statusColor.withOpacity(0.9),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            // Date Info
            Text(
              'Date: ${dateFormat.format(lending.createdDate)}${lending.dueDate != null ? ' | Due: ${dateFormat.format(lending.dueDate!)}' : ''}',
              style: theme.textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            // Optional Description
            if (lending.description != null && lending.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  lending.description!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(fontStyle: FontStyle.italic),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
        trailing: Text(
          currencyFormat.format(lending.amount),
          style: theme.textTheme.titleMedium?.copyWith(
            color: typeColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        dense: true, // Makes the list tile a bit more compact
      ),
    );
  }
}
