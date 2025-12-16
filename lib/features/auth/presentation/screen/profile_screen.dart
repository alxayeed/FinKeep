import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../../core/styles/app_themes.dart';
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

  final ValueNotifier<ThemeMode> _themeModeNotifier =
      ValueNotifier(ThemeMode.system);

  @override
  void initState() {
    super.initState();
    _reminderService.init(onTap: handleNotificationTap);
  }

  void handleNotificationTap(String? payload) {
    if (payload == 'add_expense') log('Navigate to add expense screen');
  }

  Future<void> _toggleReminder(bool value) async {
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

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Reminder scheduled at ${pickedTime.format(context)}'),
          ),
        );
      }
    } else {
      await _reminderService.cancelReminder();
      setState(() {
        _reminderEnabled = false;
        _selectedTime = null;
      });
    }
  }

  void _changeTheme() {
    final newMode = _themeModeNotifier.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    _themeModeNotifier.value = newMode;
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeModeNotifier,
      builder: (context, mode, _) {
        return Theme(
          data: mode == ThemeMode.light
              ? AppThemes.lightTheme
              : AppThemes.darkTheme,
          child: Scaffold(
            appBar: AppBar(
              title:
                  const Text('Profile', style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.teal,
              elevation: 0,
              centerTitle: true,
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          'https://www.placecats.com/neo_banana/300/200',
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Mr. Mew',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'mr.mew@example.com',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                _buildSectionTitle('App Settings'),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.brightness_6),
                        title: const Text('Theme'),
                        subtitle: Text(
                          mode == ThemeMode.light ? 'Light' : 'Dark',
                        ),
                        trailing: Switch(
                          value: mode == ThemeMode.dark,
                          onChanged: (_) => _changeTheme(),
                          activeThumbColor: Colors.teal,
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                      ListTile(
                        leading: const Icon(Icons.language),
                        title: const Text('Language'),
                        subtitle: const Text('English'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {},
                      ),
                      Divider(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                      ListTile(
                        leading: Text(
                          '৳',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        title: const Text('Currency'),
                        subtitle: const Text('BDT'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {},
                      ),
                      Divider(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                      SwitchListTile(
                        title: const Text('Enable Expense Reminder'),
                        subtitle: _reminderEnabled && _selectedTime != null
                            ? Text(
                                'Reminder at ${_selectedTime!.format(context)}')
                            : null,
                        secondary: const Icon(Icons.alarm),
                        value: _reminderEnabled,
                        onChanged: _toggleReminder,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Account & More'),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text('Edit Profile'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {},
                      ),
                      Divider(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                      ListTile(
                        leading: const Icon(Icons.lock),
                        title: const Text('Change Password'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {},
                      ),
                      Divider(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                      ListTile(
                        leading: const Icon(Icons.backup),
                        title: const Text('Backup & Restore'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {},
                      ),
                      Divider(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                      ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: const Text('About & Version'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
