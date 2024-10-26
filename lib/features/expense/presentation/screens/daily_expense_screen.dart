import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class DailyExpenseScreen extends StatelessWidget {
  const DailyExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      floatingActionButton: CustomFAB(),
      body: Center(
        child: Text("Day view"),
      ),
    );
  }
}
