import 'package:flutter/material.dart';
import 'package:spendly/features/expense/presentation/widgets/custom_app_bar.dart';

class YearlyExpenseScreen extends StatelessWidget {
  const YearlyExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Text("Year view"),
      ),
    );
  }
}
