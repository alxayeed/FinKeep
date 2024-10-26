import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class YearlyExpenseScreen extends StatelessWidget {
  const YearlyExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      floatingActionButton: CustomFAB(),
      body: Center(
        child: Text("Year view"),
      ),
    );
  }
}
