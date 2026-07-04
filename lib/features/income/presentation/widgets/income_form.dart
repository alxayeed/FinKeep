import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/common/widgets/widgets.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/styles/app_colors.dart';
import '../../domain/entities/income/income_entity.dart';
import '../controllers/income_category_controller.dart';

class IncomeForm extends StatefulWidget {
  final IncomeEntity? initialIncome;
  final String submitButtonText;
  final void Function(
    double amount,
    String categoryId,
    DateTime date,
    String description,
  ) onSubmit;

  const IncomeForm({
    super.key,
    this.initialIncome,
    required this.submitButtonText,
    required this.onSubmit,
  });

  @override
  State<IncomeForm> createState() => _IncomeFormState();
}

class _IncomeFormState extends State<IncomeForm> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final IncomeCategoryController categoryController = Get.find();

  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    if (widget.initialIncome != null) {
      final inc = widget.initialIncome!;
      amountController.text = inc.amount.toStringAsFixed(0);
      descriptionController.text = inc.description;
      _selectedDate = inc.date;
      _selectedTime = TimeOfDay.fromDateTime(inc.date);
      _selectedCategoryId = inc.categoryId;
    } else {
      _selectedDate = DateTime.now();
      _selectedTime = TimeOfDay.now();
      // Select the first category, or default to other/first available
      final defaultCat = categoryController.categories.firstWhereOrNull((c) => !c.isDeleted) ??
          categoryController.categories.firstOrNull;
      _selectedCategoryId = defaultCat?.id;
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

  void _submitForm() {
    final parsedAmount = double.tryParse(amountController.text);
    if (parsedAmount == null || parsedAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount.')),
      );
      return;
    }
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category.')),
      );
      return;
    }
    widget.onSubmit(
      parsedAmount,
      _selectedCategoryId!,
      _selectedDate,
      descriptionController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color inputBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
    final Color labelColor = isDark ? Colors.white60 : const Color(0xFF64748B);
    final Color primaryColor = AppColors.primaryTeal;

    return Obx(() {
      // Gather active categories
      final active = categoryController.categories.where((c) => !c.isDeleted).toList();
      
      // If the selected category is a soft-deleted one (meaning we are editing a historical entry),
      // merge it back into the selection list.
      if (widget.initialIncome != null) {
        final currentCatId = widget.initialIncome!.categoryId;
        final isCurrentDeleted = categoryController.categories.any((c) => c.id == currentCatId && c.isDeleted);
        if (isCurrentDeleted) {
          final deletedCat = categoryController.categories.firstWhere((c) => c.id == currentCatId);
          if (!active.any((c) => c.id == currentCatId)) {
            active.add(deletedCat);
          }
        }
      }

      // Check if _selectedCategoryId is still in the active list (e.g. if it was deleted while form is open)
      if (_selectedCategoryId != null && !categoryController.categories.any((c) => c.id == _selectedCategoryId)) {
        _selectedCategoryId = active.firstOrNull?.id;
      }

      return Column(
        children: [
          SizedBox(height: 24.h),

          // Large Amount input
          StyledAmountField(
            controller: amountController,
            labelText: 'Amount Received',
            autofocus: widget.initialIncome == null,
          ),

          SizedBox(height: 28.h),

          // Category Dropdown
          StyledDropdownFormField<String>(
            value: _selectedCategoryId,
            labelText: 'Category',
            prefixIcon: Icons.category_rounded,
            items: active.map((cat) {
              return DropdownMenuItem(
                value: cat.id,
                child: Text('${cat.emoji}  ${cat.displayLabel}'),
              );
            }).toList(),
            onChanged: (catId) {
              if (catId != null) {
                setState(() {
                  _selectedCategoryId = catId;
                });
              }
            },
          ),

          SizedBox(height: 16.h),

          // Date and Time Row
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

          // Note description
          StyledTextFormField(
            controller: descriptionController,
            labelText: 'Note (Optional)',
            hintText: 'Add details about this income...',
            prefixIcon: Icons.description_rounded,
            maxLines: 3,
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
    });
  }
}
