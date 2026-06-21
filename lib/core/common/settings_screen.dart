import 'dart:developer';

import 'package:finkeep/core/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:finkeep/core/services/app_update_service.dart';

import '../../features/expense/services/expense_reminder_service.dart';
import '../responsive/responsive.dart';
import '../styles/app_colors.dart';
import '../styles/app_themes.dart';
import '../styles/theme_provider.dart';
import 'backup_restore_screen.dart';
import 'widgets/custom_app_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _reminderEnabled = false;
  bool _biometricEnabled = false;
  TimeOfDay? _selectedTime;
  String _appVersion = '';
  bool _checkingForUpdates = false;
  final ExpenseReminderService _reminderService =
      createExpenseReminderService();
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
      _biometricEnabled = prefs.getBool('biometric_enabled') ?? false;
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
      try {
        final packageInfo = await PackageInfo.fromPlatform();
        _appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';
      } catch (e) {
        log('Error getting PackageInfo: $e');
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

  Widget _buildThemeSegmentButton(
    BuildContext context,
    IconData icon,
    ThemeMode optionMode,
    ThemeMode currentMode,
    bool isDark,
  ) {
    final isSelected = currentMode == optionMode;
    return GestureDetector(
      onTap: () => _themeProvider.setTheme(optionMode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 32.w,
        height: 28.h,
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.primaryTeal : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 2.r,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          size: 14.sp,
          color: isSelected
              ? (isDark ? Colors.white : const Color(0xFF0F172A))
              : (isDark ? Colors.white38 : const Color(0xFF64748B)),
        ),
      ),
    );
  }

  Future<void> _checkForUpdates() async {
    if (_checkingForUpdates) return;
    setState(() {
      _checkingForUpdates = true;
    });

    try {
      final updateService = Get.find<AppUpdateService>();
      final result = await updateService.checkForUpdates();

      if (!mounted) return;
      setState(() {
        _checkingForUpdates = false;
      });

      if (result.canUpdate) {
        showDialog(
          context: context,
          builder: (context) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return AlertDialog(
              backgroundColor: isDark ? AppColors.cardDark : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              title: Text(
                'Update Available',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              content: Text(
                'A new version of FinKeep (v${result.storeVersion ?? "unknown"}) is available. Update now to get the latest features and stability improvements.',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 13.sp,
                  color: isDark ? Colors.white70 : const Color(0xFF475569),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Later',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      color: isDark ? Colors.white54 : const Color(0xFF64748B),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    if (result.storeUrl != null) {
                      final Uri uri = Uri.parse(result.storeUrl!);
                      try {
                        await launchUrl(uri, mode: LaunchMode.platformDefault);
                      } catch (e) {
                        log('Error launching update URL: $e');
                      }
                    }
                  },
                  child: const Text(
                    'Update Now',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTeal,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return AlertDialog(
              backgroundColor: isDark ? AppColors.cardDark : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              title: Text(
                'Check for Updates',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              content: Text(
                'Your app is up to date! You are using the latest version.',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 13.sp,
                  color: isDark ? Colors.white70 : const Color(0xFF475569),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTeal,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    } catch (e, st) {
      log('Error checking updates: $e\n$st');
      if (mounted) {
        setState(() {
          _checkingForUpdates = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not check for updates: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

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
        final Color subtitleColor = isDark
            ? Colors.white60
            : const Color(0xFF64748B);

        return Theme(
          data: isDark ? AppThemes.darkTheme : AppThemes.lightTheme,
          child: Scaffold(
            backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
            appBar: CustomAppBar(
              title: 'Settings',
              showBackButton: true,
              // actions: [
              //   IconButton(
              //     icon: Icon(
              //       Icons.notifications_active_outlined,
              //       color: isDark ? Colors.white : const Color(0xFF0F172A),
              //       size: 20.sp,
              //     ),
              //     tooltip: 'Send Test Notification',
              //     onPressed: _showTestNotificationNow,
              //   ),
              // ],
            ),
            body: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              children: [
                // Settings section: Budgeting
                _buildSectionTitle('BUDGET & PLANNING', isDark),
                Container(
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.tune_rounded,
                          size: 20.sp,
                          color: AppColors.primaryTeal,
                        ),
                        title: Text(
                          'Set Monthly Budget',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        subtitle: Text(
                          'Manage your spending limit and goals',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontFamily: 'Manrope',
                            color: subtitleColor,
                          ),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          size: 20.sp,
                          color: subtitleColor,
                        ),
                        onTap: () {
                          context.pushNamed(
                            AppRoutes.setMonthlyBudget,
                            extra: DateTime.now(),
                          );
                        },
                      ),
                      Divider(
                        height: 1,
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFE2E8F0),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.category_outlined,
                          size: 20.sp,
                          color: AppColors.primaryTeal,
                        ),
                        title: Text(
                          'Configure Categories',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        subtitle: Text(
                          'Enable or disable expense categories',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontFamily: 'Manrope',
                            color: subtitleColor,
                          ),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          size: 20.sp,
                          color: subtitleColor,
                        ),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Configure Categories (Coming Soon)'),
                              backgroundColor: AppColors.primaryTeal,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12.h),

                // Settings section: App Customization
                _buildSectionTitle('APP SETTINGS', isDark),
                Container(
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.brightness_6_outlined,
                          size: 20.sp,
                          color: AppColors.primaryTeal,
                        ),
                        title: Text(
                          'Theme Mode',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        subtitle: Text(
                          mode == ThemeMode.light
                              ? 'Light Mode'
                              : mode == ThemeMode.dark
                              ? 'Dark Mode'
                              : 'System Default',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontFamily: 'Manrope',
                            color: subtitleColor,
                          ),
                        ),
                        trailing: Container(
                          height: 32.h,
                          padding: EdgeInsets.all(2.r),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildThemeSegmentButton(
                                context,
                                Icons.wb_sunny_rounded,
                                ThemeMode.light,
                                mode,
                                isDark,
                              ),
                              _buildThemeSegmentButton(
                                context,
                                Icons.nights_stay_rounded,
                                ThemeMode.dark,
                                mode,
                                isDark,
                              ),
                              _buildThemeSegmentButton(
                                context,
                                Icons.settings_suggest_rounded,
                                ThemeMode.system,
                                mode,
                                isDark,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFE2E8F0),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.language_outlined,
                          size: 20.sp,
                          color: AppColors.primaryTeal,
                        ),
                        title: Text(
                          'Language',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        subtitle: Text(
                          'English',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontFamily: 'Manrope',
                            color: subtitleColor,
                          ),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          size: 20.sp,
                          color: subtitleColor,
                        ),
                        onTap: () {},
                      ),
                      Divider(
                        height: 1,
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFE2E8F0),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.payments_outlined,
                          size: 20.sp,
                          color: AppColors.primaryTeal,
                        ),
                        title: Text(
                          'Currency',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        subtitle: Text(
                          'BDT (৳)',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontFamily: 'Manrope',
                            color: subtitleColor,
                          ),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          size: 20.sp,
                          color: subtitleColor,
                        ),
                        onTap: () {},
                      ),
                      Divider(
                        height: 1,
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFE2E8F0),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.alarm_outlined,
                          size: 20.sp,
                          color: AppColors.primaryTeal,
                        ),
                        title: Text(
                          'Daily Expense Reminder',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        subtitle: _reminderEnabled && _selectedTime != null
                            ? Text(
                                'Scheduled at ${_selectedTime!.format(context)}',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontFamily: 'Manrope',
                                  color: subtitleColor,
                                ),
                              )
                            : Text(
                                'Not scheduled',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontFamily: 'Manrope',
                                  color: subtitleColor,
                                ),
                              ),
                        trailing: Switch(
                          value: _reminderEnabled,
                          onChanged: _toggleReminder,
                          activeThumbColor: AppColors.primaryTeal,
                          activeTrackColor: AppColors.primaryTeal.withValues(
                            alpha: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12.h),

                // Settings section: Security & Privacy
                _buildSectionTitle('SECURITY & PRIVACY', isDark),
                Container(
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.fingerprint_rounded,
                          size: 20.sp,
                          color: AppColors.primaryTeal,
                        ),
                        title: Text(
                          'Biometric App Lock',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        subtitle: Text(
                          'Unlock app using fingerprint or Face ID',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontFamily: 'Manrope',
                            color: subtitleColor,
                          ),
                        ),
                        trailing: Switch(
                          value: _biometricEnabled,
                          onChanged: (value) async {
                            final prefs = await SharedPreferences.getInstance();
                            setState(() {
                              _biometricEnabled = value;
                            });
                            await prefs.setBool('biometric_enabled', value);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  value
                                      ? 'Biometric App Lock enabled (visual mockup)'
                                      : 'Biometric App Lock disabled (visual mockup)',
                                ),
                                backgroundColor: AppColors.primaryTeal,
                              ),
                            );
                          },
                          activeThumbColor: AppColors.primaryTeal,
                          activeTrackColor: AppColors.primaryTeal.withValues(
                            alpha: 0.3,
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFE2E8F0),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.privacy_tip_outlined,
                          size: 20.sp,
                          color: AppColors.primaryTeal,
                        ),
                        title: Text(
                          'Privacy Policy',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        subtitle: Text(
                          'Read our offline data policy',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontFamily: 'Manrope',
                            color: subtitleColor,
                          ),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          size: 20.sp,
                          color: subtitleColor,
                        ),
                        onTap: () {
                          context.pushNamed(AppRoutes.privacyPolicy);
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12.h),

                // Settings section: Data & Info
                _buildSectionTitle('DATA & UTILITIES', isDark),
                Container(
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.cloud_upload_outlined,
                          size: 20.sp,
                          color: AppColors.primaryTeal,
                        ),
                        title: Text(
                          'Backup & Restore',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          size: 20.sp,
                          color: subtitleColor,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BackupRestoreScreen(),
                            ),
                          );
                        },
                      ),
                      Divider(
                        height: 1,
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFE2E8F0),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.system_update_rounded,
                          size: 20.sp,
                          color: AppColors.primaryTeal,
                        ),
                        title: Text(
                          'Check for Updates',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        trailing: _checkingForUpdates
                            ? SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primaryTeal,
                                ),
                              )
                            : Icon(
                                Icons.chevron_right,
                                size: 20.sp,
                                color: subtitleColor,
                              ),
                        onTap: _checkingForUpdates ? null : _checkForUpdates,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Center(
                  child: Text(
                    _appVersion.isNotEmpty ? 'Version $_appVersion' : '',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontFamily: 'Manrope',
                      color: subtitleColor,
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
