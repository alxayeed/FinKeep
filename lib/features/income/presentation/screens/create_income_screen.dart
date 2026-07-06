import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/styles/app_colors.dart';
import '../../domain/entities/income/income_entity.dart';
import '../controllers/income_controller.dart';
import '../widgets/income_form.dart';

import '../../../../core/enums/payment_type.dart';

class CreateIncomeScreen extends StatefulWidget {
  const CreateIncomeScreen({super.key});

  @override
  State<CreateIncomeScreen> createState() => _CreateIncomeScreenState();
}

class _CreateIncomeScreenState extends State<CreateIncomeScreen> {
  final IncomeController controller = Get.find();

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
                'New Income',
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
            child: IncomeForm(
              submitButtonText: 'Save Income',
              onSubmit: (amount, categoryId, date, description, paymentMethod) {
                _saveIncome(amount, categoryId, date, description, paymentMethod);
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

  Future<void> _saveIncome(
    double amount,
    String categoryId,
    DateTime date,
    String description,
    PaymentType paymentMethod,
  ) async {
    final newIncome = IncomeEntity(
      id: 'inc_${DateTime.now().millisecondsSinceEpoch}',
      amount: amount,
      categoryId: categoryId,
      date: date,
      description: description,
      paymentMethod: paymentMethod,
      createdAt: DateTime.now(),
    );

    await controller.createIncome(
      newIncome,
      onSuccess: () {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Income successfully recorded!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      },
      onError: (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save income: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  }
}
