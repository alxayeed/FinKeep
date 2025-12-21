import 'package:flutter/material.dart';

import '../../domain/entities/investment.dart';
import '../widgets/investment_stepper_form.dart';

class EditInvestmentScreen extends StatelessWidget {
  final Investment investment;
  final Function(Investment) onUpdate;

  const EditInvestmentScreen({
    super.key,
    required this.investment,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return InvestmentStepperForm(
      title: 'Edit Investment',
      initialInvestment: investment,
      allowStatusEdit: true,
      onSubmit: onUpdate,
    );
  }
}
