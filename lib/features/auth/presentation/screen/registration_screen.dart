import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:spendly/core/common/widgets/styled_elevated_button.dart';
import 'package:spendly/core/responsive/responsive.dart';
import 'package:spendly/core/routes/app_router.dart';
import 'package:spendly/features/auth/presentation/controller/auth_controller.dart';
import 'package:spendly/features/auth/presentation/widgets/email_form_field.dart';
import 'package:spendly/features/auth/presentation/widgets/password_form_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final AuthController authController = Get.find();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                    'Create Account',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Sign up to get started',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32.h),
                  EmailFormField(controller: emailController),
                  SizedBox(height: 16.h),
                  PasswordFormField(controller: passwordController),
                  SizedBox(height: 16.h),
                  PasswordFormField(
                    controller: confirmPasswordController,
                    labelText: 'Confirm Password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24.h),
                  Obx(
                    () => StyledElevatedButton(
                      text: authController.isLoading.value
                          ? 'Registering...'
                          : 'Register',
                      onPressed: authController.isLoading.value
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                authController.register(
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
                        "Already have an account?",
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      TextButton(
                        onPressed: () {
                          context.goNamed(AppRoutes.login);
                        },
                        child: Text(
                          'Login',
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
