import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class MonthlyExpenseScreen extends StatelessWidget {
  const MonthlyExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Text("Month view"),
      ),
    );
  }
}
