import 'package:flutter/material.dart';

import '../../domain/entities/investment.dart';
import '../widgets/investment_stepper_form.dart';

class AddInvestmentScreen extends StatelessWidget {
  final Function(Investment) onSubmit;

  const AddInvestmentScreen({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return InvestmentStepperForm(
      title: 'Add Investment',
      // onSubmit: onSubmit,
    );
  }
}
