import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:spendly/core/styles/app_colors.dart';

import '../../../../core/routes/app_router.dart';
import '../../domain/entity/lending/lending_entity.dart';

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

  Color _getTypeColor(LendingType type) =>
      AppColors.getColorForLendingType(type);

  Color _getStatusColor(LendingStatus status) =>
      AppColors.getColorForLendingStatus(status);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typeColor = _getTypeColor(lending.type);
    final statusColor = _getStatusColor(lending.status);
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '৳');
    final dateFormat = DateFormat.yMd();

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        context.pushNamed(AppRoutes.lendingDetails, extra: lending);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        elevation: 1.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              // Icon + status
              Column(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: typeColor.withValues(alpha: 0.15),
                    child: Icon(
                      _getTypeIcon(lending.type),
                      size: 18,
                      color: typeColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      lending.status.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),

              // Main content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      lending.person.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    if (lending.description != null &&
                        lending.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          lending.description!,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(fontStyle: FontStyle.italic),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    Text(
                      'Date: ${dateFormat.format(lending.createdDate)}'
                      '${lending.dueDate != null ? ' | Due: ${dateFormat.format(lending.dueDate!)}' : ''}',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Amount
              Text(
                currencyFormat.format(lending.amount),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: typeColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
