import '../repositories/expense_repository.dart';

class GetLastMonthTotalUseCase {
  final ExpenseRepository repository;

  GetLastMonthTotalUseCase(this.repository);

  /// Returns total expenses of the month **before [currentMonth]**
  Future<double> call({required DateTime currentMonth}) async {
    final prevMonth = DateTime(
      currentMonth.month == 1 ? currentMonth.year - 1 : currentMonth.year,
      currentMonth.month == 1 ? 12 : currentMonth.month - 1,
      1,
    );

    return repository.getTotalExpensesForMonth(prevMonth);
  }
}
