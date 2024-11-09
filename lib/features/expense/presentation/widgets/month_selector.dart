import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../controllers/expense_controller.dart';

class MonthSelector extends StatefulWidget {
  final ValueChanged<DateTime> onMonthChanged;
  final double totalExpense;

  const MonthSelector({
    super.key,
    required this.onMonthChanged,
    this.totalExpense = 0.0,
  });

  @override
  State<MonthSelector> createState() => _MonthSelectorState();
}

class _MonthSelectorState extends State<MonthSelector> {
  DateTime _selectedMonth = DateTime.now();


  @override
  void initState() {

    super.initState();
  }

  @override
  void didChangeDependencies() {
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      widget.onMonthChanged(_selectedMonth);
    });
    super.didChangeDependencies();
  }

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.month == 1 ? _selectedMonth.year - 1 : _selectedMonth.year,
        _selectedMonth.month == 1 ? 12 : _selectedMonth.month - 1,
      );
      widget.onMonthChanged(_selectedMonth);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.month == 12 ? _selectedMonth.year + 1 : _selectedMonth.year,
        _selectedMonth.month == 12 ? 1 : _selectedMonth.month + 1,
      );
      widget.onMonthChanged(_selectedMonth);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _previousMonth,
        ),
        Text(
          DateFormat.yMMMM().format(_selectedMonth),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: _nextMonth,
        ),
      ],
    );
  }
}
