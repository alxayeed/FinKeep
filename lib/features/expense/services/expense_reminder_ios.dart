import 'expense_reminder_service.dart';

class IosExpenseReminderService implements ExpenseReminderService {
  @override
  Future<void> init({required void Function(String?) onTap}) async {
    // TODO: implement iOS initialization
  }

  @override
  Future<void> scheduleDailyReminder(
      {required int hour, required int minute}) async {
    // TODO: implement iOS scheduling
  }

  @override
  Future<void> cancelReminder() async {
    // TODO: implement iOS cancellation
  }

  @override
  Future<void> showTestNotificationNow() {
    // TODO: implement showTestNotificationNow
    throw UnimplementedError();
  }
}
