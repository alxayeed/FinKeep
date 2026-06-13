import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendly/features/auth/presentation/controller/auth_controller.dart';

import '../../../../core/common/backup_restore_screen.dart';
import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_themes.dart';
import '../../../../core/styles/theme_provider.dart';
import '../../../expense/services/expense_reminder_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _reminderEnabled = false;
  TimeOfDay? _selectedTime;
  final ExpenseReminderService _reminderService =
      createExpenseReminderService();
  final AuthController authController = Get.find();
  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  void initState() {
    super.initState();
    _reminderService.init(onTap: handleNotificationTap);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPreferences();
    });
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _reminderEnabled = prefs.getBool('reminder_enabled') ?? false;
      final hour = prefs.getInt('reminder_hour');
      final minute = prefs.getInt('reminder_minute');
      if (hour != null && minute != null) {
        _selectedTime = TimeOfDay(hour: hour, minute: minute);
      }
      if (_reminderEnabled && _selectedTime != null) {
        await _reminderService.scheduleDailyReminder(
          hour: _selectedTime!.hour,
          minute: _selectedTime!.minute,
        );
      }
      setState(() {});
    } catch (e, st) {
      log('Error loading SharedPreferences: $e\n$st');
    }
  }

  void handleNotificationTap(String? payload) {}

  Future<void> _toggleReminder(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value) {
      final now = TimeOfDay.now();
      if (!mounted) return;
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedTime ?? now,
        builder: (context, child) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
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
          _selectedTime = pickedTime;
          _reminderEnabled = true;
        });
        await _reminderService.scheduleDailyReminder(
          hour: pickedTime.hour,
          minute: pickedTime.minute,
        );
        await prefs.setBool('reminder_enabled', true);
        await prefs.setInt('reminder_hour', pickedTime.hour);
        await prefs.setInt('reminder_minute', pickedTime.minute);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Reminder scheduled at ${pickedTime.format(context)}',
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } else {
      await _reminderService.cancelReminder();
      setState(() {
        _reminderEnabled = false;
        _selectedTime = null;
      });
      await prefs.setBool('reminder_enabled', false);
      await prefs.remove('reminder_hour');
      await prefs.remove('reminder_minute');
    }
  }

  void _toggleTheme() => _themeProvider.toggleTheme();

  Future<void> _showTestNotificationNow() async {
    await _reminderService.showTestNotificationNow();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Test notification sent! Tap it to navigate.'),
        backgroundColor: AppColors.primaryTeal,
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, bottom: 8.h, top: 16.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11.sp,
          fontFamily: 'Manrope',
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: isDark ? Colors.white54 : const Color(0xFF64748B),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeProvider,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark;
        final Color cardBg = isDark ? AppColors.cardDark : Colors.white;
        final Color textColor = isDark ? Colors.white : const Color(0xFF0F172A);
        final Color subtitleColor = isDark ? Colors.white60 : const Color(0xFF64748B);

        return Theme(
          data: isDark ? AppThemes.darkTheme : AppThemes.lightTheme,
          child: Scaffold(
            backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
            appBar: CustomAppBar(
              title: 'Profile',
              showBackButton: false,
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.notifications_active_outlined,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    size: 20.sp,
                  ),
                  tooltip: 'Send Test Notification',
                  onPressed: _showTestNotificationNow,
                ),
              ],
            ),
            body: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              children: [
                // Header profile card
                Container(
                  padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Premium circular avatar ring
                      Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [AppColors.primaryTeal, AppColors.primaryTealLight],
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 46.r,
                          backgroundColor: cardBg,
                          child: CircleAvatar(
                            radius: 42.r,
                            backgroundImage: const NetworkImage(
                              'https://www.placecats.com/neo_banana/300/200',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Mr. Mew',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.email_outlined,
                            color: AppColors.primaryTeal,
                            size: 14.sp,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            authController.user?.email ?? 'Unknown user',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w500,
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12.h),

                // Settings section 1
                _buildSectionTitle('APP SETTINGS', isDark),
                Container(
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.brightness_6_outlined, size: 20.sp, color: AppColors.primaryTeal),
                        title: Text(
                          'Theme Mode',
                          style: TextStyle(fontSize: 13.sp, fontFamily: 'Manrope', fontWeight: FontWeight.w600, color: textColor),
                        ),
                        subtitle: Text(
                          isDark ? 'Dark Mode' : 'Light Mode',
                          style: TextStyle(fontSize: 11.sp, fontFamily: 'Manrope', color: subtitleColor),
                        ),
                        trailing: Switch(
                          value: isDark,
                          onChanged: (_) => _toggleTheme(),
                          activeColor: AppColors.primaryTeal,
                          activeTrackColor: AppColors.primaryTeal.withValues(alpha: 0.3),
                        ),
                      ),
                      Divider(height: 1, color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
                      ListTile(
                        leading: Icon(Icons.language_outlined, size: 20.sp, color: AppColors.primaryTeal),
                        title: Text(
                          'Language',
                          style: TextStyle(fontSize: 13.sp, fontFamily: 'Manrope', fontWeight: FontWeight.w600, color: textColor),
                        ),
                        subtitle: Text(
                          'English',
                          style: TextStyle(fontSize: 11.sp, fontFamily: 'Manrope', color: subtitleColor),
                        ),
                        trailing: Icon(Icons.chevron_right, size: 20.sp, color: subtitleColor),
                        onTap: () {},
                      ),
                      Divider(height: 1, color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
                      ListTile(
                        leading: Icon(Icons.payments_outlined, size: 20.sp, color: AppColors.primaryTeal),
                        title: Text(
                          'Currency',
                          style: TextStyle(fontSize: 13.sp, fontFamily: 'Manrope', fontWeight: FontWeight.w600, color: textColor),
                        ),
                        subtitle: Text(
                          'BDT (৳)',
                          style: TextStyle(fontSize: 11.sp, fontFamily: 'Manrope', color: subtitleColor),
                        ),
                        trailing: Icon(Icons.chevron_right, size: 20.sp, color: subtitleColor),
                        onTap: () {},
                      ),
                      Divider(height: 1, color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
                      ListTile(
                        leading: Icon(Icons.alarm_outlined, size: 20.sp, color: AppColors.primaryTeal),
                        title: Text(
                          'Daily Expense Reminder',
                          style: TextStyle(fontSize: 13.sp, fontFamily: 'Manrope', fontWeight: FontWeight.w600, color: textColor),
                        ),
                        subtitle: _reminderEnabled && _selectedTime != null
                            ? Text(
                                'Scheduled at ${_selectedTime!.format(context)}',
                                style: TextStyle(fontSize: 11.sp, fontFamily: 'Manrope', color: subtitleColor),
                              )
                            : Text(
                                'Not scheduled',
                                style: TextStyle(fontSize: 11.sp, fontFamily: 'Manrope', color: subtitleColor),
                              ),
                        trailing: Switch(
                          value: _reminderEnabled,
                          onChanged: _toggleReminder,
                          activeColor: AppColors.primaryTeal,
                          activeTrackColor: AppColors.primaryTeal.withValues(alpha: 0.3),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12.h),

                // Settings section 2
                _buildSectionTitle('ACCOUNT & UTILITIES', isDark),
                Container(
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.edit_outlined, size: 20.sp, color: AppColors.primaryTeal),
                        title: Text(
                          'Edit Profile',
                          style: TextStyle(fontSize: 13.sp, fontFamily: 'Manrope', fontWeight: FontWeight.w600, color: textColor),
                        ),
                        trailing: Icon(Icons.chevron_right, size: 20.sp, color: subtitleColor),
                        onTap: () {},
                      ),
                      Divider(height: 1, color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
                      ListTile(
                        leading: Icon(Icons.lock_outline_rounded, size: 20.sp, color: AppColors.primaryTeal),
                        title: Text(
                          'Change Password',
                          style: TextStyle(fontSize: 13.sp, fontFamily: 'Manrope', fontWeight: FontWeight.w600, color: textColor),
                        ),
                        trailing: Icon(Icons.chevron_right, size: 20.sp, color: subtitleColor),
                        onTap: () {},
                      ),
                      Divider(height: 1, color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
                      ListTile(
                        leading: Icon(Icons.cloud_upload_outlined, size: 20.sp, color: AppColors.primaryTeal),
                        title: Text(
                          'Backup & Restore',
                          style: TextStyle(fontSize: 13.sp, fontFamily: 'Manrope', fontWeight: FontWeight.w600, color: textColor),
                        ),
                        trailing: Icon(Icons.chevron_right, size: 20.sp, color: subtitleColor),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BackupRestoreScreen(),
                            ),
                          );
                        },
                      ),
                      Divider(height: 1, color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
                      ListTile(
                        leading: Icon(Icons.info_outline, size: 20.sp, color: AppColors.primaryTeal),
                        title: Text(
                          'About & Version',
                          style: TextStyle(fontSize: 13.sp, fontFamily: 'Manrope', fontWeight: FontWeight.w600, color: textColor),
                        ),
                        trailing: Icon(Icons.chevron_right, size: 20.sp, color: subtitleColor),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32.h),

                // Logout Button
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: OutlinedButton(
                      onPressed: () => authController.logout(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.error, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout_rounded, color: AppColors.error, size: 18.sp),
                          SizedBox(width: 8.w),
                          Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.bold,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
