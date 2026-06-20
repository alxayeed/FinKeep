import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finkeep/core/routes/app_router.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/styles/app_colors.dart';
import 'widgets/onboarding_slide.dart';
import 'widgets/animated_illustration.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
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
    final borderCol = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

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
                  illustration: AnimatedIllustration(index: 0, isActive: _currentPage == 0),
                  title: 'Track Expenses Smartly',
                  subtitle: 'Log your daily expenses, set budget limits, and analyze your spending habits with intuitive category breakdowns.',
                ),
                OnboardingSlide(
                  illustration: AnimatedIllustration(index: 1, isActive: _currentPage == 1),
                  title: 'Manage Loans & Debts',
                  subtitle: 'Keep a structured log of personal lendings, borrowings, and repayments. Never lose track of money owed or due.',
                ),
                OnboardingSlide(
                  illustration: AnimatedIllustration(index: 2, isActive: _currentPage == 2),
                  title: 'Monitor Investments',
                  subtitle: 'Keep all your active investments in view. Check your portfolio valuation and track growth over time.',
                ),
                OnboardingSlide(
                  illustration: AnimatedIllustration(index: 3, isActive: _currentPage == 3),
                  title: 'Your Data, Safe and Private',
                  subtitle: 'FinKeep is fully offline. All your financial data is stored locally on your device and never leaves it. You can securely backup your data using AES-256 encrypted files.',
                  extra: _buildSecurityFeatures(borderCol, textCol, isDark),
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
                  TextButton(
                    onPressed: () => _completeOnboarding(context),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white60 : const Color(0xFF475569),
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
                    children: List.generate(4, (index) {
                      final bool isActive = _currentPage == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        width: isActive ? 28.w : 8.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFF006E25)
                              : (isDark ? const Color(0xFF334155) : const Color(0xFFBACBB6)),
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

  Widget _buildActionsRow(BuildContext context, bool isDark) {
    if (_currentPage == 0) {
      // Screen 1: Full-width Next
      return _buildNextButton(fullWidth: true);
    } else if (_currentPage == 3) {
      // Screen 4: Full-width Get Started
      return _buildGetStartedButton();
    } else {
      // Screen 2 & 3: Back + Next
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
          Icon(
            Icons.arrow_forward_rounded,
            color: Colors.white,
            size: 16.sp,
          ),
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
      child: fullWidth ? SizedBox(width: double.infinity, child: button) : button,
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
            Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 16.sp,
            ),
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
                  child: Icon(Icons.lock_rounded, color: AppColors.success, size: 16.sp),
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
                  child: Icon(Icons.cloud_off_rounded, color: Colors.blue, size: 16.sp),
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
