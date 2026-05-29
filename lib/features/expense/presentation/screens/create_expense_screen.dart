import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/enums/expense_category.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/styles/app_colors.dart';
import '../../domain/entities/expense_entity.dart';
import '../controllers/expense_controller.dart';

class CreateExpenseScreen extends StatefulWidget {
  const CreateExpenseScreen({super.key});

  @override
  State<CreateExpenseScreen> createState() => _CreateExpenseScreenState();
}

class _CreateExpenseScreenState extends State<CreateExpenseScreen> {
  final ExpenseController controller = Get.find();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  ExpenseCategory _selectedCategory = ExpenseCategory.food;
  String _paymentMethod = 'CARD'; // CARD, CASH, TRANSFER (CARD is default in mockup)

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: isDark
              ? ThemeData.dark().copyWith(
                  colorScheme: const ColorScheme.dark(
                    primary: AppColors.primaryTeal,
                    onPrimary: Colors.white,
                    surface: AppColors.cardDark,
                    onSurface: Colors.white,
                  ),
                )
              : ThemeData.light().copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: AppColors.primaryTeal,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Color(0xFF0F172A),
                  ),
                ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedDate.hour,
          _selectedDate.minute,
        );
      });
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: isDark
              ? ThemeData.dark().copyWith(
                  colorScheme: const ColorScheme.dark(
                    primary: AppColors.primaryTeal,
                    onPrimary: Colors.white,
                    surface: AppColors.cardDark,
                    onSurface: Colors.white,
                  ),
                )
              : ThemeData.light().copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: AppColors.primaryTeal,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Color(0xFF0F172A),
                  ),
                ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _selectedDate = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color inputBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
    final Color labelColor = isDark ? Colors.white60 : const Color(0xFF64748B);
    final Color primaryColor = AppColors.primaryTeal;

    final mainContent = Column(
      children: [
        // Drag handle (visible when modal)
        Center(
          child: Container(
            width: 38.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 12.h, top: 4.h),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        ),

        // Header Action Bar
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  child: Row(
                    children: [
                      Icon(Icons.chevron_left, size: 22.sp, color: primaryColor),
                      Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                'New Expense',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              SizedBox(width: 48.w), // Flanking spacer for title centering
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 24.h),

                // Large Centered Amount input
                Text(
                  'AMOUNT SPENT',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: labelColor,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '৳',
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white30 : const Color(0xFFCBD5E1),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    IntrinsicWidth(
                      child: TextField(
                        controller: amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        autofocus: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 42.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                        decoration: InputDecoration(
                          hintText: '0.00',
                          hintStyle: TextStyle(
                            color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 28.h),

                // Category Selection
                _buildLabel('Category', labelColor),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  decoration: BoxDecoration(
                    color: inputBg,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.category_rounded, size: 20.sp, color: isDark ? Colors.white38 : const Color(0xFF94A3B8)),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<ExpenseCategory>(
                            value: _selectedCategory,
                            icon: Icon(Icons.expand_more_rounded, size: 20.sp, color: isDark ? Colors.white38 : const Color(0xFF94A3B8)),
                            dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : const Color(0xFF334155),
                            ),
                            onChanged: (cat) {
                              if (cat != null) {
                                setState(() {
                                  _selectedCategory = cat;
                                });
                              }
                            },
                            items: ExpenseCategory.values.map((cat) {
                              return DropdownMenuItem(
                                value: cat,
                                child: Text(cat.displayName),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                // Date and Time selectors Row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Date', labelColor),
                          GestureDetector(
                            onTap: () => _pickDate(context),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                              decoration: BoxDecoration(
                                color: inputBg,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today_rounded, size: 18.sp, color: isDark ? Colors.white38 : const Color(0xFF94A3B8)),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Text(
                                      DateFormat('yyyy-MM-dd').format(_selectedDate),
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontFamily: 'Manrope',
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? Colors.white : const Color(0xFF334155),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Time', labelColor),
                          GestureDetector(
                            onTap: () => _pickTime(context),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                              decoration: BoxDecoration(
                                color: inputBg,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.schedule_rounded, size: 18.sp, color: isDark ? Colors.white38 : const Color(0xFF94A3B8)),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Text(
                                      _selectedTime.format(context),
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontFamily: 'Manrope',
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? Colors.white : const Color(0xFF334155),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // Note description field
                _buildLabel('Note (Optional)', labelColor),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: inputBg,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 12.h),
                        child: Icon(Icons.description_rounded, size: 20.sp, color: isDark ? Colors.white38 : const Color(0xFF94A3B8)),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: TextField(
                          controller: descriptionController,
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : const Color(0xFF334155),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Add details about this expense...',
                            hintStyle: TextStyle(
                              color: isDark ? Colors.white24 : const Color(0xFFCBD5E1),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                // Payment Method Label and Selector Row
                _buildLabel('Payment Method', labelColor),
                Row(
                  children: [
                    _buildPaymentBtn('Card', Icons.credit_card_rounded, 'CARD', primaryColor),
                    SizedBox(width: 8.w),
                    _buildPaymentBtn('Cash', Icons.payments_rounded, 'CASH', primaryColor),
                    SizedBox(width: 8.w),
                    _buildPaymentBtn('Transfer', Icons.account_balance_rounded, 'TRANSFER', primaryColor),
                  ],
                ),

                SizedBox(height: 24.h),

                // Attach receipt dash card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.transparent,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long_rounded, size: 20.sp, color: isDark ? Colors.white38 : const Color(0xFFCBD5E1)),
                      SizedBox(width: 8.w),
                      Text(
                        'Attach Receipt',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // Save Expense Button
                ElevatedButton(
                  onPressed: _saveExpense,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 54.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    elevation: 2,
                    shadowColor: primaryColor.withValues(alpha: 0.2),
                  ),
                  child: Text(
                    'Save Expense',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ],
    );

    // Render safely as a Scaffold so it behaves properly inside GoRouter navigation / bottom sheet
    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : Colors.white,
      body: SafeArea(
        child: mainContent,
      ),
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 6.h, top: 10.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 11.sp,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentBtn(String text, IconData icon, String method, Color primaryColor) {
    final isSelected = _paymentMethod == method;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _paymentMethod = method;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected
                ? primaryColor.withValues(alpha: 0.05)
                : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
            border: Border.all(
              color: isSelected ? primaryColor : Colors.transparent,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20.sp,
                color: isSelected
                    ? primaryColor
                    : (isDark ? Colors.white38 : const Color(0xFF94A3B8)),
              ),
              SizedBox(height: 4.h),
              Text(
                text.toUpperCase(),
                style: TextStyle(
                  fontSize: 9.sp,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? primaryColor
                      : (isDark ? Colors.white38 : const Color(0xFF64748B)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveExpense() async {
    final parsedAmount = double.tryParse(amountController.text);
    if (parsedAmount == null || parsedAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount.')),
      );
      return;
    }

    final newExpense = ExpenseEntity(
      id: DateTime.now().toString(),
      amount: parsedAmount,
      category: _selectedCategory.displayName,
      date: _selectedDate,
      description: descriptionController.text,
      userId: controller.userId,
    );

    await controller.createExpense(
      newExpense,
      onSuccess: () {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Expense successfully recorded!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      },
      onError: (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save expense: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  }
}

