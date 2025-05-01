import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spendly/core/styles/app_colors.dart';
import 'package:spendly/features/lendings/presentation/screens/lending_details_screen.dart';

import '../../domain/entity/lend_entity.dart';

class LendingListItem extends StatelessWidget {
  final LendingEntity lending;

  const LendingListItem({
    super.key,
    required this.lending,
  });

  IconData _getTypeIcon(LendingType type) {
    switch (type) {
      case LendingType.given:
        return Icons.arrow_upward_rounded;
      case LendingType.taken:
        return Icons.arrow_downward_rounded;
    }
  }

  Color _getTypeColor(LendingType type) {
    return AppColors.getColorForLendingType(type);
  }

  Color _getStatusColor(LendingStatus status) {
    return AppColors.getColorForLendingStatus(status);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typeColor = _getTypeColor(lending.type);
    final statusColor = _getStatusColor(lending.status);
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '৳');
    final dateFormat = DateFormat.yMd();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: ListTile(
        onTap: () {
          Get.to(() => LendingDetailsScreen(lending: lending));
        },
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
            Text(
              'Date: ${dateFormat.format(lending.createdDate)}${lending.dueDate != null ? ' | Due: ${dateFormat.format(lending.dueDate!)}' : ''}',
              style: theme.textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
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
        dense: true,
      ),
    );
  }
}
