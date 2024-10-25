import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class WeeklyExpenseScreen extends StatelessWidget {
  const WeeklyExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      floatingActionButton: CustomFAB(),
      body: Center(
        child: Text("Week view"),
      ),
    );
  }
}
