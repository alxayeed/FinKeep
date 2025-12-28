import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:spendly/core/routes/app_router.dart';
import 'package:spendly/features/auth/presentation/controller/auth_controller.dart';
import 'package:spendly/features/auth/presentation/widgets/email_form_field.dart';
import 'package:spendly/features/auth/presentation/widgets/password_form_field.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.find();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              EmailFormField(controller: emailController),
              const SizedBox(height: 16.0),
              PasswordFormField(controller: passwordController),
              const SizedBox(height: 16.0),
              Obx(
                () => authController.isLoading.value
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            authController.login(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            );
                          }
                        },
                        child: const Text('Login'),
                      ),
              ),
              Obx(
                () => Text(
                  authController.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  context.goNamed(AppRoutes.register);
                },
                child: const Text('Don\'t have an account? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
