import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:spendly/core/common/widgets/styled_elevated_button.dart';
import 'package:spendly/core/responsive/responsive.dart';
import 'package:spendly/core/routes/app_router.dart';
import 'package:spendly/features/auth/presentation/controller/auth_controller.dart';
import 'package:spendly/features/auth/presentation/widgets/email_form_field.dart';
import 'package:spendly/features/auth/presentation/widgets/password_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = Get.find();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40.h),
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Login to continue',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32.h),
                  EmailFormField(controller: emailController),
                  SizedBox(height: 16.h),
                  PasswordFormField(controller: passwordController),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                      ),
                      SizedBox(width: 8.w),
                      Text('Remember Me', style: TextStyle(fontSize: 14.sp)),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Obx(
                    () => StyledElevatedButton(
                      text: authController.isLoading.value
                          ? 'Logging in...'
                          : 'Login',
                      onPressed: authController.isLoading.value
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                authController.login(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                );
                              }
                            },
                      isLoading: authController.isLoading.value,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Obx(
                    () => Text(
                      authController.errorMessage.value,
                      style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      TextButton(
                        onPressed: () {
                          context.goNamed(AppRoutes.register);
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
