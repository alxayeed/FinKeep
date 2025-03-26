import 'package:flutter/material.dart';
import 'package:spendly/core/constants/app_strings.dart';
import 'package:spendly/features/lendings/domain/entity/lend_entity.dart';

class LendingCardWidget extends StatelessWidget {
  final LendingEntity lending;

  const LendingCardWidget({super.key, required this.lending});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Amount: ${lending.amount}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Borrower: ${lending.borrowerName}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Due: ${lending.dueDate.toLocal().toString().split(' ')[0]}',
              // Only date part
              style: TextStyle(fontSize: 14),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Note: ${lending.note ?? AppStrings.notAvailable}',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
