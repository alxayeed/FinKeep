import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/enums/expense_category.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/styles/app_colors.dart';
import '../../domain/entities/expense_entity.dart';
import '../controllers/expense_controller.dart';

class EditExpenseScreen extends StatefulWidget {
  final ExpenseEntity expense;
  final ValueChanged<ExpenseEntity>? onSave;

  const EditExpenseScreen({super.key, required this.expense, this.onSave});

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final ExpenseController controller = Get.find();
  late TextEditingController amountController;
  late TextEditingController descriptionController;
  late TextEditingController merchantController; // Maps to description or local state since entity doesn't have merchant

  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late ExpenseCategory _selectedCategory;
  String _paymentMethod = 'CARD'; // CARD, CASH, TRANSFER

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController(text: widget.expense.amount.toStringAsFixed(0));
    // Parse merchant vs description if needed; since description is just a string, we treat it as notes,
    // and if there's no merchant, we can show a placeholder or let them edit description here.
    // Let's make merchant map to description if there's one line, or show description in notes.
    final desc = widget.expense.description;
    merchantController = TextEditingController(text: desc.split('\n').first);
    descriptionController = TextEditingController(
      text: desc.contains('\n') ? desc.substring(desc.indexOf('\n') + 1) : '',
    );
    _selectedDate = widget.expense.date;
    _selectedTime = TimeOfDay.fromDateTime(widget.expense.date);
    _selectedCategory = ExpenseCategory.values.firstWhere(
      (category) => category.displayName == widget.expense.category,
      orElse: () => ExpenseCategory.food,
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    merchantController.dispose();
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

  Future<void> _confirmDelete(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await controller.removeExpense(
        widget.expense.id,
        onSuccess: () {
          if (!mounted) return;
          context.pop(); // Pop edit screen
          context.pop(); // Pop details screen back to main dashboard
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Expense successfully deleted.'),
              backgroundColor: Colors.green,
            ),
          );
        },
        onError: (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete expense: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color inputBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6);
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
              IconButton(
                onPressed: () => context.pop(),
                icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp, color: isDark ? Colors.white : const Color(0xFF0F172A)),
              ),
              Text(
                'Edit Expense',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              IconButton(
                onPressed: () => _confirmDelete(context),
                icon: Icon(Icons.delete_outline_rounded, size: 22.sp, color: Colors.red),
              ),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 16.h),

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
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white30 : const Color(0xFFCBD5E1),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    IntrinsicWidth(
                      child: TextField(
                        controller: amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 40.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                        decoration: InputDecoration(
                          hintText: '0.00',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24.h),

                // Form fields matching mockup 6 prepended styles
                // Merchant / Title
                _buildLabel('Merchant / Title', labelColor),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  decoration: BoxDecoration(
                    color: inputBg,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.shopping_bag_outlined, size: 20.sp, color: isDark ? Colors.white38 : const Color(0xFF94A3B8)),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: TextField(
                          controller: merchantController,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : const Color(0xFF334155),
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter title or merchant...',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

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
                      Icon(Icons.restaurant_rounded, size: 20.sp, color: isDark ? Colors.white38 : const Color(0xFF94A3B8)),
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

                // Date and Time Row
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

                // Paid With Dropdown
                _buildLabel('Paid With', labelColor),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  decoration: BoxDecoration(
                    color: inputBg,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.credit_card_rounded, size: 20.sp, color: isDark ? Colors.white38 : const Color(0xFF94A3B8)),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _paymentMethod,
                            icon: Icon(Icons.expand_more_rounded, size: 20.sp, color: isDark ? Colors.white38 : const Color(0xFF94A3B8)),
                            dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : const Color(0xFF334155),
                            ),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _paymentMethod = val;
                                });
                              }
                            },
                            items: const [
                              DropdownMenuItem(value: 'CARD', child: Text('Credit Card (•••• 8820)')),
                              DropdownMenuItem(value: 'CASH', child: Text('Cash')),
                              DropdownMenuItem(value: 'TRANSFER', child: Text('Main Savings (•••• 4291)')),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                // Notes (Optional) Textarea
                _buildLabel('Notes (Optional)', labelColor),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: inputBg,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: TextField(
                    controller: descriptionController,
                    maxLines: 2,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF334155),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Add a description...',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.white24 : const Color(0xFFCBD5E1),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                // Update Expense button
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
                    'Update Expense',
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

  Future<void> _saveExpense() async {
    final parsedAmount = double.tryParse(amountController.text);
    if (parsedAmount == null || parsedAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount.')),
      );
      return;
    }

    // Save combined description + merchant if edited
    final String combinedDescription = merchantController.text.isNotEmpty
        ? (descriptionController.text.isNotEmpty
            ? '${merchantController.text}\n${descriptionController.text}'
            : merchantController.text)
        : descriptionController.text;

    final updatedExpense = widget.expense.copyWith(
      amount: parsedAmount,
      category: _selectedCategory.displayName,
      date: _selectedDate,
      description: combinedDescription,
    );

    await controller.editExpense(
      updatedExpense,
      onSuccess: () {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Expense successfully updated!'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onSave?.call(updatedExpense);
        context.pop();
      },
      onError: (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update expense: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  }
}
