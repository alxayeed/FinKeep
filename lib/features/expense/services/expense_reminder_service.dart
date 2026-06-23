import 'dart:io';
import 'package:flutter/widgets.dart';

import 'expense_reminder_android.dart';
import 'expense_reminder_ios.dart';

abstract class ExpenseReminderService {
  Future<void> init({required void Function(String?) onTap});

  Future<void> scheduleDailyReminder({required int hour, required int minute});

  Future<void> cancelReminder();

  Future<void> showTestNotificationNow();

  Future<bool> requestPermissions(BuildContext context);
}

/// Factory method to create platform-specific implementation
ExpenseReminderService createExpenseReminderService() {
  if (Platform.isAndroid) {
    return AndroidExpenseReminderService();
  }
  if (Platform.isIOS) {
    return IosExpenseReminderService();
  }
  throw UnsupportedError('Expense reminder not supported on this platform');
}
