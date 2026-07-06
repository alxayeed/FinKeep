import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/common/widgets/widgets.dart';
import '../../../../core/enums/payment_type.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/styles/app_colors.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/entities/expense_category_entity.dart';
import '../controllers/expense_category_controller.dart';

class ExpenseForm extends StatefulWidget {
  final ExpenseEntity? initialExpense;
  final String submitButtonText;
  final void Function(
    double amount,
    ExpenseCategoryEntity category,
    DateTime date,
    String description,
    PaymentType paymentMethod,
  ) onSubmit;

  const ExpenseForm({
    super.key,
    this.initialExpense,
    required this.submitButtonText,
    required this.onSubmit,
  });

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final ExpenseCategoryController categoryController = Get.find();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  String? _selectedCategoryId;
  late PaymentType _paymentMethod;

  @override
  void initState() {
    super.initState();
    if (widget.initialExpense != null) {
      final exp = widget.initialExpense!;
      amountController.text = exp.amount.toStringAsFixed(0);
      descriptionController.text = exp.description;
      _selectedDate = exp.date;
      _selectedTime = TimeOfDay.fromDateTime(exp.date);
      
      // Resolve category dynamically
      final resolvedCat = categoryController.resolveCategory(exp.category);
      _selectedCategoryId = resolvedCat.id;
      
      _paymentMethod = exp.paymentMethod;
    } else {
      _selectedDate = DateTime.now();
      _selectedTime = TimeOfDay.now();
      _selectedCategoryId = 'exp_food';
      _paymentMethod = PaymentType.cash;
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
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

  void _submitForm() {
    final parsedAmount = double.tryParse(amountController.text);
    if (parsedAmount == null || parsedAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount.')),
      );
      return;
    }
    
    final selectedCat = categoryController.categories.firstWhereOrNull((c) => c.id == _selectedCategoryId)
        ?? ExpenseCategoryController.defaultCategories.first;

    widget.onSubmit(
      parsedAmount,
      selectedCat,
      _selectedDate,
      descriptionController.text,
      _paymentMethod,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color inputBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
    final Color labelColor = isDark ? Colors.white60 : const Color(0xFF64748B);
    final Color primaryColor = AppColors.primaryTeal;

    return Column(
      children: [
        SizedBox(height: 24.h),

        // Large Centered Amount input
        AppNumberField(
          controller: amountController,
          labelText: 'Amount Spent',
          autofocus: widget.initialExpense == null,
        ),

        SizedBox(height: 28.h),

        // Category Selection
        Obx(() {
          final active = categoryController.categories.where((c) => !c.isDeleted).toList();

          if (widget.initialExpense != null) {
            final legacyResolved = categoryController.resolveCategory(widget.initialExpense!.category);
            if (legacyResolved.isDeleted && !active.any((c) => c.id == legacyResolved.id)) {
              active.add(legacyResolved);
            }
          }

          if (_selectedCategoryId != null && !categoryController.categories.any((c) => c.id == _selectedCategoryId)) {
            _selectedCategoryId = active.firstOrNull?.id;
          }

          final selectedCat = active.firstWhereOrNull((c) => c.id == _selectedCategoryId);

          return StyledCategorySelectorField<ExpenseCategoryEntity>(
            value: selectedCat,
            labelText: 'Category',
            items: active,
            titleExtractor: (cat) => cat.displayLabel,
            leadingBuilder: (context, cat, isSelected) {
              return Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  cat.emoji,
                  style: TextStyle(fontSize: 16.sp),
                ),
              );
            },
            onSelected: (cat) {
              setState(() {
                _selectedCategoryId = cat.id;
              });
            },
          );
        }),

        SizedBox(height: 16.h),

        // Date and Time selectors Row
        Row(
          children: [
            Expanded(
              child: StyledDatePickerButton(
                labelText: 'Date',
                selectedDate: _selectedDate,
                onDateSelected: (d) {
                  if (d != null) {
                    setState(() {
                      _selectedDate = DateTime(
                        d.year,
                        d.month,
                        d.day,
                        _selectedDate.hour,
                        _selectedDate.minute,
                      );
                    });
                  }
                },
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 4.w, bottom: 6.h),
                    child: Text(
                      'Time',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                        color: labelColor,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => _pickTime(context),
                    borderRadius: BorderRadius.circular(16.r),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.schedule_rounded,
                          color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                          size: 18.sp,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: inputBg,
                        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 4.w),
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
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 16.h),

        // Note description field
        AppTextField(
          controller: descriptionController,
          labelText: 'Note (Optional)',
          hintText: 'Add details about this expense...',
          maxLines: 3,
        ),

        SizedBox(height: 16.h),

        // Payment Method Selector
        PaymentMethodSelector(
          selectedMethod: _paymentMethod,
          labelColor: labelColor,
          onChanged: (method) {
            setState(() {
              _paymentMethod = method;
            });
          },
        ),

        SizedBox(height: 32.h),

        // Action Button
        ElevatedButton(
          onPressed: _submitForm,
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
            widget.submitButtonText,
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 40.h),
      ],
    );
  }
}
