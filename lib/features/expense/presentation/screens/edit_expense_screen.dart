import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/payment_type.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/styles/app_colors.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/entities/expense_category_entity.dart';
import '../controllers/monthly_expense_controller.dart';
import '../widgets/expense_form.dart';

class EditExpenseScreen extends StatefulWidget {
  final ExpenseEntity expense;
  final ValueChanged<ExpenseEntity>? onSave;

  const EditExpenseScreen({super.key, required this.expense, this.onSave});

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final MonthlyExpenseController controller = Get.find();

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
            child: ExpenseForm(
              initialExpense: widget.expense,
              submitButtonText: 'Update Expense',
              onSubmit: (amount, category, date, description, paymentMethod) {
                _saveExpense(amount, category, date, description, paymentMethod);
              },
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

  Future<void> _saveExpense(
    double amount,
    ExpenseCategoryEntity category,
    DateTime date,
    String description,
    PaymentType paymentMethod,
  ) async {
    final updatedExpense = widget.expense.copyWith(
      amount: amount,
      category: category.displayLabel,
      date: date,
      description: description,
      paymentMethod: paymentMethod,
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
        context.pop(updatedExpense);
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
