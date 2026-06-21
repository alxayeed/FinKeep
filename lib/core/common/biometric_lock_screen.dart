import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/biometric_service.dart';
import '../styles/app_colors.dart';
import '../responsive/responsive.dart';
import 'widgets/styled_elevated_button.dart';

class BiometricLockScreen extends StatefulWidget {
  final VoidCallback onUnlocked;
  const BiometricLockScreen({super.key, required this.onUnlocked});

  @override
  State<BiometricLockScreen> createState() => _BiometricLockScreenState();
}

class _BiometricLockScreenState extends State<BiometricLockScreen> {
  final BiometricService _biometricService = Get.find<BiometricService>();
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    // Auto-trigger authentication after the build frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authenticate();
    });
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating) return;
    setState(() {
      _isAuthenticating = true;
    });

    final bool success = await _biometricService.authenticate();
    
    if (mounted) {
      setState(() {
        _isAuthenticating = false;
      });
      if (success) {
        widget.onUnlocked();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              // Muted, modern logo representation
              Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_outline_rounded,
                  size: 36.sp,
                  color: AppColors.primaryTeal,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'FinKeep Secured',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Manrope',
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Please unlock to access your personal finance records',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontFamily: 'Manrope',
                  color: isDark ? Colors.white60 : const Color(0xFF64748B),
                ),
              ),
              const Spacer(),
              if (_isAuthenticating)
                const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryTeal,
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: StyledElevatedButton(
                    text: 'Unlock App',
                    onPressed: _authenticate,
                  ),
                ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
