import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/responsive/responsive.dart';

class MonthSelector extends StatefulWidget {
  final ValueChanged<DateTime> onMonthChanged;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onFilterPressed;
  final bool showSearchButton;

  const MonthSelector({
    super.key,
    required this.onMonthChanged,
    this.onSearchPressed,
    this.onFilterPressed,
    this.showSearchButton = true,
  });

  @override
  State<MonthSelector> createState() => _MonthSelectorState();
}

class _MonthSelectorState extends State<MonthSelector> {
  DateTime _selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onMonthChanged(_selectedMonth);
    });
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

  Future<void> _selectMonth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDatePickerMode: DatePickerMode.year,
      helpText: 'Select Month',
    );
    if (picked != null && picked != _selectedMonth) {
      setState(() {
        _selectedMonth = DateTime(picked.year, picked.month);
        widget.onMonthChanged(_selectedMonth);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left switching cluster
          Row(
            children: [
              // Left Chevron
              GestureDetector(
                onTap: _previousMonth,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? const Color(0xFF1E293B) : Colors.transparent,
                  ),
                  child: Icon(
                    Icons.chevron_left,
                    size: 24.sp,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              // Dropdown Button Pill
              GestureDetector(
                onTap: () => _selectMonth(context),
                child: Container(
                  height: 36.h,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(9999.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 2.r,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat('MMMM yyyy').format(_selectedMonth),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 16.sp,
                        color: isDark ? Colors.white60 : const Color(0xFF94A3B8),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              // Right Chevron
              GestureDetector(
                onTap: _nextMonth,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? const Color(0xFF1E293B) : Colors.transparent,
                  ),
                  child: Icon(
                    Icons.chevron_right,
                    size: 24.sp,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),

          // Right search & filter cluster
          Row(
            children: [
              // Search Button
              if (widget.showSearchButton) ...[
                GestureDetector(
                  onTap: widget.onSearchPressed,
                  child: Container(
                    width: 36.r,
                    height: 36.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? const Color(0xFF1E293B) : Colors.transparent,
                    ),
                    child: Icon(
                      Icons.search_rounded,
                      size: 22.sp,
                      color: isDark ? Colors.white70 : const Color(0xFF64748B),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
              ],
              // Filter Button
              GestureDetector(
                onTap: widget.onFilterPressed,
                child: Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? const Color(0xFF1E293B) : Colors.transparent,
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    size: 22.sp,
                    color: isDark ? Colors.white70 : const Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
