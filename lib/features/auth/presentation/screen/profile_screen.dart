import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendly/features/auth/presentation/controller/auth_controller.dart';

import '../../../../core/common/widgets/styled_elevated_button.dart';
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
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedTime ?? now,
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Reminder scheduled at ${pickedTime.format(context)}',
            ),
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Test notification sent! Tap it to navigate.'),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeProvider,
      builder: (context, mode, _) {
        return Theme(
          data: mode == ThemeMode.light
              ? AppThemes.lightTheme
              : AppThemes.darkTheme,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Profile',
                style: TextStyle(fontSize: 20.sp, color: Colors.white),
              ),
              backgroundColor: Colors.teal,
              elevation: 0,
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_active,
                    color: Colors.white,
                  ),
                  tooltip: 'Send Test Notification',
                  onPressed: _showTestNotificationNow,
                ),
              ],
            ),
            body: ListView(
              padding: EdgeInsets.all(16.w),
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50.r,
                        backgroundImage: const NetworkImage(
                          'https://www.placecats.com/neo_banana/300/200',
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Mr. Mew',
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.email_outlined,
                            color: AppColors.primaryTeal,
                            size: 18.r,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            authController.user?.email ?? 'Unknown user',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                _buildSectionTitle('App Settings'),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 2,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.brightness_6, size: 22.r),
                        title: Text('Theme', style: TextStyle(fontSize: 16.sp)),
                        subtitle: Text(
                          mode == ThemeMode.light ? 'Light' : 'Dark',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        trailing: Switch(
                          value: mode == ThemeMode.dark,
                          onChanged: (_) => _toggleTheme(),
                          activeThumbColor: Colors.teal,
                        ),
                      ),
                      Divider(color: Theme.of(context).dividerColor),
                      ListTile(
                        leading: Icon(Icons.language, size: 22.r),
                        title: Text(
                          'Language',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        subtitle: Text(
                          'English',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        trailing: Icon(Icons.chevron_right, size: 22.r),
                        onTap: () {},
                      ),
                      Divider(color: Theme.of(context).dividerColor),
                      ListTile(
                        leading: Text(
                          '৳',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.sp,
                          ),
                        ),
                        title: Text(
                          'Currency',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        subtitle: Text(
                          'BDT',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        trailing: Icon(Icons.chevron_right, size: 22.r),
                        onTap: () {},
                      ),
                      Divider(color: Theme.of(context).dividerColor),
                      SwitchListTile(
                        title: Text(
                          'Enable Expense Reminder',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        subtitle: _reminderEnabled && _selectedTime != null
                            ? Text(
                                'Reminder at ${_selectedTime!.format(context)}',
                                style: TextStyle(fontSize: 14.sp),
                              )
                            : null,
                        secondary: Icon(Icons.alarm, size: 22.r),
                        value: _reminderEnabled,
                        onChanged: _toggleReminder,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 2,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.edit, size: 22.r),
                        title: Text(
                          'Edit Profile',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        trailing: Icon(Icons.chevron_right, size: 22.r),
                        onTap: () {},
                      ),
                      Divider(color: Theme.of(context).dividerColor),
                      ListTile(
                        leading: Icon(Icons.lock, size: 22.r),
                        title: Text(
                          'Change Password',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        trailing: Icon(Icons.chevron_right, size: 22.r),
                        onTap: () {},
                      ),
                      Divider(color: Theme.of(context).dividerColor),
                      ListTile(
                        leading: Icon(Icons.backup, size: 22.r),
                        title: Text(
                          'Backup & Restore',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        trailing: Icon(Icons.chevron_right, size: 22.r),
                        onTap: () {},
                      ),
                      Divider(color: Theme.of(context).dividerColor),
                      ListTile(
                        leading: Icon(Icons.info_outline, size: 22.r),
                        title: Text(
                          'About & Version',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        trailing: Icon(Icons.chevron_right, size: 22.r),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Center(
                  child: SizedBox(
                    width: 280.w,
                    child: StyledElevatedButton(
                      text: 'Logout',
                      onPressed: () => authController.logout(),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
