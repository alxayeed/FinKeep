import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/double_ext.dart';

class MonthSelector extends StatefulWidget {
  final ValueChanged<DateTime> onMonthChanged;
  final double? totalExpense;

  const MonthSelector({
    super.key,
    required this.onMonthChanged,
    this.totalExpense,
  });

  @override
  State<MonthSelector> createState() => _MonthSelectorState();
}

class _MonthSelectorState extends State<MonthSelector> {
  DateTime _selectedMonth = DateTime.now();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Use addPostFrameCallback instead of Future.delayed for cleaner initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onMonthChanged(_selectedMonth);
    });
  }

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.month == 1
            ? _selectedMonth.year - 1
            : _selectedMonth.year,
        _selectedMonth.month == 1 ? 12 : _selectedMonth.month - 1,
      );
      widget.onMonthChanged(_selectedMonth);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.month == 12
            ? _selectedMonth.year + 1
            : _selectedMonth.year,
        _selectedMonth.month == 12 ? 1 : _selectedMonth.month + 1,
      );
      widget.onMonthChanged(_selectedMonth);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabController = DefaultTabController.of(context);

    // AnimatedBuilder listens to the tabController's changes
    return AnimatedBuilder(
      animation: tabController,
      builder: (context, child) {
        // The index updates here automatically as the user swipes
        final bool isListTab = tabController.index == 1;

        return Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: _previousMonth,
                  ),
                  Text(
                    DateFormat.yMMMM().format(_selectedMonth),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: _nextMonth,
                  ),
                ],
              ),
            ),
            if (isListTab && widget.totalExpense != null)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  height: 45,
                  // Fixed height to keep Row balanced
                  decoration: BoxDecoration(
                    color: Colors.teal.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '${widget.totalExpense!.toCurrency()} ৳',
                      style: const TextStyle(
                        fontSize: 16, // Slightly smaller to fit layout
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            else
              const SizedBox.shrink(),
            // Keeps the month title centered when total is hidden
          ],
        );
      },
    );
  }
}
