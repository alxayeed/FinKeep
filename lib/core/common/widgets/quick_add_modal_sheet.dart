import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/routes/app_router.dart';
import 'package:finkeep/core/styles/app_colors.dart';
import 'package:finkeep/core/styles/currency_provider.dart';
import 'package:finkeep/features/expense/domain/entities/expense_entity.dart';
import 'package:finkeep/features/expense/presentation/controllers/monthly_expense_controller.dart';
import 'package:finkeep/features/expense/presentation/widgets/expense_form.dart';
import 'package:finkeep/features/income/domain/entities/income/income_entity.dart';
import 'package:finkeep/features/income/presentation/controllers/income_controller.dart';
import 'package:finkeep/features/income/presentation/widgets/income_form.dart';
import 'package:finkeep/features/lendings/domain/entity/lending/lending_entity.dart';
import 'package:finkeep/features/lendings/presentation/controllers/lendings_controller.dart';
import 'package:finkeep/features/lendings/presentation/widgets/lending_form_widget.dart';

void showQuickAddModalSheet(BuildContext context, {int initialTab = 0}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => QuickAddModalSheet(initialTab: initialTab),
  );
}

class QuickAddModalSheet extends StatefulWidget {
  final int initialTab;

  const QuickAddModalSheet({
    super.key,
    this.initialTab = 0,
  });

  @override
  State<QuickAddModalSheet> createState() => _QuickAddModalSheetState();
}

class _QuickAddModalSheetState extends State<QuickAddModalSheet> {
  late int _selectedTab;
  late final PageController _pageController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
    _pageController = PageController(initialPage: widget.initialTab);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Color get _activeAccentColor {
    switch (_selectedTab) {
      case 0:
        return const Color(0xFFEF4444); // Crimson for Expense
      case 1:
        return const Color(0xFF10B981); // Emerald for Income
      case 2:
        return const Color(0xFF6366F1); // Indigo for Lend
      default:
        return AppColors.primaryTeal;
    }
  }

  void _onTabTapped(int index) {
    if (_selectedTab != index) {
      setState(() {
        _selectedTab = index;
      });
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;
    final activeSymbol = context.currency.symbol;

    return Container(
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.only(bottom: keyboardPadding),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDark : AppColors.bgLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // 1. Full Screen Modal Top Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: _activeAccentColor.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          _selectedTab == 2 ? '🤝' : activeSymbol,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: _activeAccentColor,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'Quick Add',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close_rounded,
                      size: 22.sp,
                      color: isDark ? Colors.white60 : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),

            // 2. Segmented Pill Switcher with dynamic theme accents
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              child: Container(
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: _activeAccentColor.withValues(alpha: 0.25),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(child: _buildTabButton(0, 'Expense', Icons.monetization_on_outlined, const Color(0xFFEF4444), isDark, currencySymbol: activeSymbol)),
                    Expanded(child: _buildTabButton(1, 'Income', Icons.account_balance_wallet_outlined, const Color(0xFF10B981), isDark, currencySymbol: activeSymbol)),
                    Expanded(child: _buildTabButton(2, 'Lend', Icons.handshake_outlined, const Color(0xFF6366F1), isDark)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.h),

            // 3. Fast Animated PageView (Full Height Page Content)
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(bottom: 12.h),
                    child: _buildExpenseForm(context),
                  ),
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(bottom: 12.h),
                    child: _buildIncomeForm(context),
                  ),
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(bottom: 12.h),
                    child: _buildLendingForm(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(int index, String label, IconData fallbackIcon, Color tabAccent, bool isDark, {String? currencySymbol}) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 9.h),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.cardDark : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: tabAccent.withValues(alpha: 0.25),
                    blurRadius: 8.r,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (currencySymbol != null)
              Text(
                currencySymbol,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? tabAccent
                      : (isDark ? Colors.white38 : const Color(0xFF94A3B8)),
                ),
              )
            else
              Icon(
                fallbackIcon,
                size: 16.sp,
                color: isSelected
                    ? tabAccent
                    : (isDark ? Colors.white38 : const Color(0xFF94A3B8)),
              ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontFamily: 'Manrope',
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected
                    ? (isDark ? Colors.white : const Color(0xFF0F172A))
                    : (isDark ? Colors.white38 : const Color(0xFF64748B)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseForm(BuildContext modalContext) {
    return ExpenseForm(
      submitButtonText: 'Save Expense',
      onSubmit: (amount, category, date, description, paymentMethod) async {
        if (_isSubmitting) return;
        setState(() => _isSubmitting = true);
        final nav = Navigator.of(modalContext);
        final router = GoRouter.of(modalContext);
        final messenger = ScaffoldMessenger.of(modalContext);

        try {
          final monthlyController = Get.find<MonthlyExpenseController>();
          final expense = ExpenseEntity(
            id: 'exp_${DateTime.now().millisecondsSinceEpoch}',
            amount: amount,
            category: category.displayLabel,
            date: date,
            description: description,
            paymentMethod: paymentMethod,
            createdAt: DateTime.now(),
          );
          await monthlyController.addExpense.call(expense);
          await monthlyController.fetchMonthlyExpenses();

          nav.pop();
          router.go(AppRoutes.expenses);
          messenger.showSnackBar(
            const SnackBar(
              content: Text('Expense successfully recorded!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        } catch (e) {
          messenger.showSnackBar(
            SnackBar(content: Text('Error adding expense: $e'), backgroundColor: Colors.red),
          );
        } finally {
          if (mounted) setState(() => _isSubmitting = false);
        }
      },
    );
  }

  Widget _buildIncomeForm(BuildContext modalContext) {
    return IncomeForm(
      submitButtonText: 'Save Income',
      onSubmit: (amount, categoryId, date, description, paymentMethod) async {
        if (_isSubmitting) return;
        setState(() => _isSubmitting = true);
        final nav = Navigator.of(modalContext);
        final router = GoRouter.of(modalContext);
        final messenger = ScaffoldMessenger.of(modalContext);

        try {
          final incomeController = Get.find<IncomeController>();
          final income = IncomeEntity(
            id: 'inc_${DateTime.now().millisecondsSinceEpoch}',
            amount: amount,
            categoryId: categoryId,
            date: date,
            description: description,
            paymentMethod: paymentMethod,
            createdAt: DateTime.now(),
          );
          await incomeController.createIncome(income);
          await incomeController.fetchMonthlyIncomes();

          nav.pop();
          router.go(AppRoutes.income);
          messenger.showSnackBar(
            const SnackBar(
              content: Text('Income successfully recorded!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        } catch (e) {
          messenger.showSnackBar(
            SnackBar(content: Text('Error adding income: $e'), backgroundColor: Colors.red),
          );
        } finally {
          if (mounted) setState(() => _isSubmitting = false);
        }
      },
    );
  }

  Widget _buildLendingForm(BuildContext modalContext) {
    return LendingFormWidget(
      submitButtonText: 'Save Entry',
      isLoading: _isSubmitting,
      onSubmit: (amount, person, type, status, createdDate, dueDate, description, paymentMethod) async {
        if (_isSubmitting) return;
        setState(() => _isSubmitting = true);
        final nav = Navigator.of(modalContext);
        final router = GoRouter.of(modalContext);
        final messenger = ScaffoldMessenger.of(modalContext);

        try {
          final lendingsController = Get.find<LendingsController>();
          final lending = LendingEntity(
            id: 'lend_${DateTime.now().millisecondsSinceEpoch}',
            personId: person.id,
            person: person,
            amount: amount,
            repaidAmount: 0.0,
            type: type,
            status: status,
            createdDate: createdDate,
            dueDate: dueDate,
            description: description,
            paymentMethod: paymentMethod,
          );
          await lendingsController.addLending.call(lending);
          await lendingsController.fetchLendings();

          nav.pop();
          router.go(AppRoutes.lendings);
          messenger.showSnackBar(
            const SnackBar(
              content: Text('Lending record saved!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        } catch (e) {
          messenger.showSnackBar(
            SnackBar(content: Text('Error adding lending entry: $e'), backgroundColor: Colors.red),
          );
        } finally {
          if (mounted) setState(() => _isSubmitting = false);
        }
      },
    );
  }
}
