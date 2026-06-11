import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/expense_category.dart';
import '../../../../core/enums/payment_type.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/styles/app_colors.dart';
import '../../domain/entities/expense_entity.dart';
import '../controllers/expense_controller.dart';
import '../widgets/expense_form.dart';

class CreateExpenseScreen extends StatefulWidget {
  const CreateExpenseScreen({super.key});

  @override
  State<CreateExpenseScreen> createState() => _CreateExpenseScreenState();
}

class _CreateExpenseScreenState extends State<CreateExpenseScreen> {
  final ExpenseController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
            child: ExpenseForm(
              submitButtonText: 'Save Expense',
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
    ExpenseCategory category,
    DateTime date,
    String description,
    PaymentType paymentMethod,
  ) async {
    final newExpense = ExpenseEntity(
      id: DateTime.now().toString(),
      amount: amount,
      category: category.displayName,
      date: date,
      description: description,
      userId: controller.userId,
      paymentMethod: paymentMethod,
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
