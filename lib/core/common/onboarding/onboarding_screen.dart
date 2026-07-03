import 'package:finkeep/core/common/widgets/app_switch_button.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/routes/app_router.dart';
import 'package:finkeep/core/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/expense/presentation/controllers/budget_controller.dart';
import '../../../features/expense/services/expense_reminder_service.dart';
import 'widgets/animated_illustration.dart';
import 'widgets/onboarding_slide.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Setup form states
  late final TextEditingController _budgetTextController;
  bool _isRecurring = true;
  bool _reminderEnabled = true;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 21, minute: 0);
  final ExpenseReminderService _reminderService =
      createExpenseReminderService();

  @override
  void initState() {
    super.initState();
    _budgetTextController = TextEditingController(text: '0');
    _reminderService.init(onTap: (payload) {});
  }

  @override
  void dispose() {
    _pageController.dispose();
    _budgetTextController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Save Monthly Budget
    final budgetVal = double.tryParse(_budgetTextController.text) ?? 0.0;
    try {
      final budgetController = Get.find<BudgetController>();
      await budgetController.saveBudgetsForMonth(
        month: DateTime.now(),
        overall: budgetVal,
        categories: {},
        isRecurring: _isRecurring,
      );
    } catch (e) {
      debugPrint('Error saving budget in onboarding: $e');
    }

    // 2. Save Reminder Configuration
    await prefs.setBool('reminder_enabled', _reminderEnabled);
    if (_reminderEnabled) {
      await prefs.setInt('reminder_hour', _reminderTime.hour);
      await prefs.setInt('reminder_minute', _reminderTime.minute);
      try {
        await _reminderService.scheduleDailyReminder(
          hour: _reminderTime.hour,
          minute: _reminderTime.minute,
        );
      } catch (e) {
        debugPrint('Error scheduling reminder in onboarding: $e');
      }
    } else {
      await prefs.remove('reminder_hour');
      await prefs.remove('reminder_minute');
      try {
        await _reminderService.cancelReminder();
      } catch (e) {
        debugPrint('Error cancelling reminder in onboarding: $e');
      }
    }

    await prefs.setBool('seen_onboarding', true);
    if (context.mounted) {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Background style: Dark Slate or very light mint green
    final backgroundColor = isDark ? AppColors.bgDark : const Color(0xFFF2FDEC);
    final textCol = isDark ? Colors.white : const Color(0xFF0F172A);
    final borderCol = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    final subtitleColor = isDark ? Colors.white70 : const Color(0xFF475569);
    final cardBg = isDark ? AppColors.cardDark : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Slide contents (Page View)
            PageView(
              controller: _pageController,
              onPageChanged: (pageIndex) {
                setState(() {
                  _currentPage = pageIndex;
                });
              },
              children: [
                OnboardingSlide(
                  illustration: AnimatedIllustration(
                    index: 0,
                    isActive: _currentPage == 0,
                  ),
                  title: 'Track Expenses Smartly',
                  subtitle:
                      'Log your daily expenses, set budget limits, and analyze your spending habits with intuitive category breakdowns.',
                ),
                OnboardingSlide(
                  illustration: AnimatedIllustration(
                    index: 1,
                    isActive: _currentPage == 1,
                  ),
                  title: 'Manage Loans & Debts',
                  subtitle:
                      'Keep a structured log of personal lendings, borrowings, and repayments. Never lose track of money owed or due.',
                ),
                OnboardingSlide(
                  illustration: AnimatedIllustration(
                    index: 2,
                    isActive: _currentPage == 2,
                  ),
                  title: 'Monitor Investments',
                  subtitle:
                      'Keep all your active investments in view. Check your portfolio valuation and track growth over time.',
                ),
                OnboardingSlide(
                  illustration: AnimatedIllustration(
                    index: 3,
                    isActive: _currentPage == 3,
                  ),
                  title: 'Your Data, Safe and Private',
                  subtitle:
                      'FinKeep is fully offline. All your financial data is stored locally on your device and never leaves it. You can securely backup your data using AES-256 encrypted files.',
                  extra: _buildSecurityFeatures(borderCol, textCol, isDark),
                ),
                _buildSetupSlide(
                  cardBg,
                  borderCol,
                  textCol,
                  subtitleColor,
                  isDark,
                ),
              ],
            ),

            // Top Persistent Header (Logo & Skip)
            Positioned(
              top: 8.h,
              left: 20.w,
              right: 20.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo
                  Row(
                    children: [
                      Container(
                        width: 32.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: Image.asset(
                            'assets/img/app_Icon.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'FinKeep',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          color: textCol,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  // Skip Button
                  if (_currentPage < 4)
                    TextButton(
                      onPressed: () => _completeOnboarding(context),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white60
                              : const Color(0xFF475569),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Bottom Navigation Overlay (Page Indicator & Action Buttons)
            Positioned(
              bottom: 24.h,
              left: 20.w,
              right: 20.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page indicator dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final bool isActive = _currentPage == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        width: isActive ? 28.w : 8.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFF006E25)
                              : (isDark
                                    ? const Color(0xFF334155)
                                    : const Color(0xFFBACBB6)),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      );
                    }),
                  ),

                  SizedBox(height: 24.h),

                  // Actions block
                  _buildActionsRow(context, isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetupSlide(
    Color cardBg,
    Color borderCol,
    Color textCol,
    Color subtitleColor,
    bool isDark,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 70.h),
          Center(
            child: Text(
              'Customize Your Setup',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 24.sp,
                fontWeight: FontWeight.w800,
                color: textCol,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 8.h),
          Center(
            child: Text(
              'Configure your initial budget and reminders.\nYou can change these anytime in Settings.',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: subtitleColor,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 24.h),

          // Section 1: Budgeting
          _buildSetupSectionHeader('BUDGET & PLANNING', isDark),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: borderCol, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.tune_rounded,
                      size: 20.sp,
                      color: AppColors.primaryTeal,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'Monthly Budget Limit',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w600,
                        color: textCol,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Container(
                  height: 52.h,
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF0F172A)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: borderCol),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '৳',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white60 : Colors.black45,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: TextField(
                          controller: _budgetTextController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w800,
                            color: textCol,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '30,000',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [10000, 20000, 30000, 50000].map((preset) {
                    final String displayVal =
                        '${(preset / 1000).toStringAsFixed(0)}k';
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _budgetTextController.text = preset.toString();
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color:
                                  _budgetTextController.text ==
                                      preset.toString()
                                  ? AppColors.primaryTeal
                                  : borderCol,
                            ),
                            backgroundColor:
                                _budgetTextController.text == preset.toString()
                                ? AppColors.primaryTeal.withValues(alpha: 0.1)
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                          ),
                          child: Text(
                            '$displayVal ৳',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              color:
                                  _budgetTextController.text ==
                                      preset.toString()
                                  ? AppColors.primaryTeal
                                  : textCol,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 12.h),
                Divider(color: borderCol, height: 1),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recurring Budget',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                            color: textCol,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Apply settings to following months',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 10.sp,
                            color: subtitleColor,
                          ),
                        ),
                      ],
                    ),
                    AppSwitchButton(
                      value: _isRecurring,
                      onChanged: (val) {
                        setState(() {
                          _isRecurring = val;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // Section 2: Reminders
          _buildSetupSectionHeader('ALERTS & REMINDERS', isDark),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: borderCol, width: 1),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.notifications_active_outlined,
                          size: 20.sp,
                          color: AppColors.primaryTeal,
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Daily Expense Reminder',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.w600,
                                color: textCol,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Remind me to log today\'s expenses',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontFamily: 'Manrope',
                                color: subtitleColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    AppSwitchButton(
                      value: _reminderEnabled,
                      onChanged: (val) {
                        setState(() {
                          _reminderEnabled = val;
                        });
                      },
                    ),
                  ],
                ),
                if (_reminderEnabled) ...[
                  SizedBox(height: 12.h),
                  Divider(color: borderCol, height: 1),
                  SizedBox(height: 12.h),
                  InkWell(
                    onTap: () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: _reminderTime,
                        builder: (context, child) {
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
                      if (pickedTime != null) {
                        setState(() {
                          _reminderTime = pickedTime;
                        });
                      }
                    },
                    borderRadius: BorderRadius.circular(10.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF0F172A)
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: borderCol),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.alarm_outlined,
                                size: 18.sp,
                                color: subtitleColor,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Scheduled reminder time',
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 12.sp,
                                  color: textCol,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            _reminderTime.format(context),
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryTeal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: 180.h),
        ],
      ),
    );
  }

  Widget _buildSetupSectionHeader(String title, bool isDark) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 8.h, top: 12.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 10.sp,
          fontFamily: 'Manrope',
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: isDark ? Colors.white54 : const Color(0xFF64748B),
        ),
      ),
    );
  }

  Widget _buildActionsRow(BuildContext context, bool isDark) {
    if (_currentPage == 0) {
      return _buildNextButton(fullWidth: true);
    } else if (_currentPage == 4) {
      return _buildGetStartedButton();
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBackButton(isDark),
          _buildNextButton(fullWidth: false),
        ],
      );
    }
  }

  Widget _buildBackButton(bool isDark) {
    return GestureDetector(
      onTap: () {
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        width: 56.w,
        height: 56.h,
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFBACBB6),
            width: 1.5.w,
          ),
        ),
        child: Icon(
          Icons.arrow_back_rounded,
          color: isDark ? Colors.white70 : const Color(0xFF006E25),
          size: 20.sp,
        ),
      ),
    );
  }

  Widget _buildNextButton({required bool fullWidth}) {
    final button = Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: fullWidth ? 0 : 32.w),
      decoration: BoxDecoration(
        color: const Color(0xFF006E25),
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF006E25).withValues(alpha: 0.2),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Text(
            'Next',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 8.w),
          Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16.sp),
        ],
      ),
    );

    return GestureDetector(
      onTap: () {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: fullWidth
          ? SizedBox(width: double.infinity, child: button)
          : button,
    );
  }

  Widget _buildGetStartedButton() {
    return GestureDetector(
      onTap: () => _completeOnboarding(context),
      child: Container(
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          color: const Color(0xFF006E25),
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF006E25).withValues(alpha: 0.2),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Get Started',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityFeatures(Color borderCol, Color textCol, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: borderCol),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.lock_rounded,
                    color: AppColors.success,
                    size: 16.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ENCRYPTION',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.success,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'AES-256',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: textCol,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: borderCol),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.cloud_off_rounded,
                    color: Colors.blue,
                    size: 16.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'OFFLINE',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.blue,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '100% Local',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: textCol,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
