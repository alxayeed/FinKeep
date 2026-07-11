import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finkeep/core/styles/app_colors.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import '../controllers/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController _controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Branding / Logo section
                Icon(
                  Icons.lock_person_rounded,
                  size: 80.h,
                  color: AppColors.primaryTeal,
                ),
                SizedBox(height: 16.h),
                Text(
                  'FinKeep Secured',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.darkGrey,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Enter your credentials to access personal environment data.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.white70 : AppColors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40.h),

                // Card wrapper for the login form
                Card(
                  elevation: 0,
                  color: isDark ? AppColors.cardDark : Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Email Field
                        Text(
                          'Email Address',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white70 : AppColors.darkGrey,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextField(
                          controller: _controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: 'developer@example.com',
                            hintStyle: TextStyle(color: AppColors.hintText),
                            prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primaryTeal),
                            contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: isDark ? AppColors.dividerDark : AppColors.borderColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: isDark ? AppColors.dividerDark : AppColors.borderColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppColors.primaryTeal, width: 2),
                            ),
                          ),
                          style: TextStyle(color: isDark ? Colors.white : AppColors.darkGrey),
                        ),
                        SizedBox(height: 20.h),

                        // Password Field
                        Text(
                          'Password',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white70 : AppColors.darkGrey,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Obx(
                          () => TextField(
                            controller: _controller.passwordController,
                            obscureText: !_controller.isPasswordVisible.value,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _controller.login(context),
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              hintStyle: TextStyle(color: AppColors.hintText),
                              prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primaryTeal),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _controller.isPasswordVisible.value
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.grey,
                                ),
                                onPressed: _controller.togglePasswordVisibility,
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: isDark ? AppColors.dividerDark : AppColors.borderColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: isDark ? AppColors.dividerDark : AppColors.borderColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.primaryTeal, width: 2),
                              ),
                            ),
                            style: TextStyle(color: isDark ? Colors.white : AppColors.darkGrey),
                          ),
                        ),
                        SizedBox(height: 30.h),

                        // Submit Button
                        Obx(
                          () => ElevatedButton(
                            onPressed: _controller.isLoading.value ? null : () => _controller.login(context),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: AppColors.primaryTeal,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: AppColors.primaryTeal.withValues(alpha: 0.6),
                            ),
                            child: _controller.isLoading.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Sign In',
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16.w,
                                    ),
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
        ),
      ),
    );
  }
}
