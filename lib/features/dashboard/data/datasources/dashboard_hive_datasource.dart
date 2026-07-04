import 'package:finkeep/core/services/local_db_service.dart';
import 'package:finkeep/core/utils/date_parser.dart';
import 'package:intl/intl.dart';

import '../models/dashboard_aggregate_stats_model.dart';
import '../models/dashboard_category_breakdown_model.dart';
import '../models/dashboard_recent_activity_model.dart';
import '../models/dashboard_trend_point_model.dart';
import 'dashboard_local_datasource.dart';

class DashboardHiveDataSource implements DashboardLocalDataSource {
  final LocalDbService localDb;

  DashboardHiveDataSource({required this.localDb});

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  DateTime _parseDate(dynamic val) => DateParser.parse(val);

  bool _inRange(DateTime date, DateTime start, DateTime end) {
    return !date.isBefore(start) && !date.isAfter(end);
  }

  // ---------------------------------------------------------------------------
  // Aggregate Stats
  // ---------------------------------------------------------------------------

  @override
  Future<DashboardAggregateStatsModel> getAggregateStats(
    DateTime start,
    DateTime end,
  ) async {
    double totalIncome = 0.0;
    double totalExpense = 0.0;
    double totalGivenDue = 0.0;
    double totalReceivedDue = 0.0;
    double totalInvested = 0.0;
    double totalInvestmentProfit = 0.0;

    // Expenses
    for (final raw in localDb.expensesBox.values) {
      final map = Map<String, dynamic>.from(raw);
      final date = _parseDate(map['date']);
      if (_inRange(date, start, end)) {
        totalExpense += (map['amount'] as num? ?? 0).toDouble();
      }
    }

    // Income
    for (final raw in localDb.incomeBox.values) {
      final map = Map<String, dynamic>.from(raw);
      final date = _parseDate(map['date']);
      if (_inRange(date, start, end)) {
        totalIncome += (map['amount'] as num? ?? 0).toDouble();
      }
    }

    // Lendings — net outstanding dues
    final Map<String, double> repaidMap = {};
    for (final raw in localDb.repaymentsBox.values) {
      final map = Map<String, dynamic>.from(raw);
      final lendingId = map['lendingId'] as String? ?? '';
      final amount = (map['amount'] as num? ?? 0).toDouble();
      repaidMap[lendingId] = (repaidMap[lendingId] ?? 0) + amount;
    }
    for (final raw in localDb.lendingsBox.values) {
      final map = Map<String, dynamic>.from(raw);
      final lendingAmount = (map['amount'] as num? ?? 0).toDouble();
      final id = map['id'] as String? ?? '';
      final repaid = repaidMap[id] ?? (map['repaidAmount'] as num? ?? 0).toDouble();
      final due = (lendingAmount - repaid).clamp(0, double.infinity).toDouble();
      final type = map['type'] as String? ?? '';
      if (type == 'given') {
        totalGivenDue += due;
      } else if (type == 'taken') {
        totalReceivedDue += due;
      }
    }

    // Investments
    for (final raw in localDb.investmentsBox.values) {
      final map = Map<String, dynamic>.from(raw);
      final invested = (map['amountInvested'] as num? ?? 0).toDouble();
      final status = map['status'] as String? ?? '';
      final returns = (map['returns'] as List<dynamic>? ?? []);
      double returnsSum = 0.0;
      for (final r in returns) {
        final rMap = Map<String, dynamic>.from(r as Map);
        returnsSum += (rMap['amountReceived'] as num? ?? 0).toDouble();
      }
      if (status == 'active' || status == 'returnsStarted') {
        totalInvested += invested;
      }
      if (status == 'completed' || status == 'loss') {
        totalInvestmentProfit += (returnsSum - invested);
      } else if (returnsSum > invested) {
        totalInvestmentProfit += (returnsSum - invested);
      }
    }

    final netSavings = totalIncome - totalExpense;
    final savingsRate = totalIncome > 0 ? (netSavings / totalIncome) * 100 : 0.0;
    final monthlyBudget = await _sumBudgetsForRange(start, end);

    return DashboardAggregateStatsModel(
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      netSavings: netSavings,
      savingsRate: savingsRate,
      monthlyBudget: monthlyBudget,
      totalGivenDue: totalGivenDue,
      totalReceivedDue: totalReceivedDue,
      totalInvested: totalInvested,
      totalInvestmentProfit: totalInvestmentProfit,
    );
  }

  Future<double> _sumBudgetsForRange(DateTime start, DateTime end) async {
    double total = 0.0;
    DateTime cursor = DateTime(start.year, start.month, 1);
    final endMonth = DateTime(end.year, end.month, 1);
    while (!cursor.isAfter(endMonth)) {
      final key = DateFormat('yyyy-MMMM').format(cursor);
      final raw = localDb.budgetsBox.get(key);
      if (raw != null) {
        total += (raw['overallBudget'] as num? ?? 0).toDouble();
      } else {
        // Fall back to recurring budget if set after cursor
        final recurring = localDb.budgetsBox.get('recurring');
        if (recurring != null) {
          total += (recurring['overallBudget'] as num? ?? 0).toDouble();
        }
      }
      cursor = DateTime(cursor.year, cursor.month + 1, 1);
    }
    return total;
  }

  // ---------------------------------------------------------------------------
  // Expense Category Breakdown
  // ---------------------------------------------------------------------------

  @override
  Future<List<DashboardCategoryBreakdownModel>> getExpenseCategoryBreakdown(
    DateTime start,
    DateTime end,
  ) async {
    final Map<String, double> catSums = {};
    double grandTotal = 0.0;

    // Build category emoji lookup from expense_categories box
    final Map<String, String> emojiMap = {};
    for (final raw in localDb.expenseCategoriesBox.values) {
      final map = Map<String, dynamic>.from(raw);
      final id = map['id'] as String? ?? '';
      final emoji = map['emoji'] as String? ?? '💸';
      emojiMap[id] = emoji;
    }

    for (final raw in localDb.expensesBox.values) {
      final map = Map<String, dynamic>.from(raw);
      final date = _parseDate(map['date']);
      if (_inRange(date, start, end)) {
        final category = map['category'] as String? ?? 'other';
        final amount = (map['amount'] as num? ?? 0).toDouble();
        catSums[category] = (catSums[category] ?? 0) + amount;
        grandTotal += amount;
      }
    }

    final List<DashboardCategoryBreakdownModel> result = catSums.entries.map((e) {
      final percentage = grandTotal > 0 ? (e.value / grandTotal) * 100 : 0.0;
      return DashboardCategoryBreakdownModel(
        categoryName: e.key,
        amount: e.value,
        percentage: percentage,
        emoji: emojiMap[e.key] ?? '💸',
      );
    }).toList();

    result.sort((a, b) => b.amount.compareTo(a.amount));
    return result;
  }

  // ---------------------------------------------------------------------------
  // Income Category Breakdown
  // ---------------------------------------------------------------------------

  @override
  Future<List<DashboardCategoryBreakdownModel>> getIncomeCategoryBreakdown(
    DateTime start,
    DateTime end,
  ) async {
    final Map<String, double> catSums = {};
    double grandTotal = 0.0;

    // Build category label + emoji lookup from income_categories box
    final Map<String, String> labelMap = {};
    final Map<String, String> emojiMap = {};
    for (final raw in localDb.incomeCategoriesBox.values) {
      final map = Map<String, dynamic>.from(raw);
      final id = map['id'] as String? ?? '';
      labelMap[id] = map['name'] as String? ?? id;
      emojiMap[id] = map['emoji'] as String? ?? '💰';
    }

    for (final raw in localDb.incomeBox.values) {
      final map = Map<String, dynamic>.from(raw);
      final date = _parseDate(map['date']);
      if (_inRange(date, start, end)) {
        final categoryId = map['categoryId'] as String? ?? 'other';
        final amount = (map['amount'] as num? ?? 0).toDouble();
        catSums[categoryId] = (catSums[categoryId] ?? 0) + amount;
        grandTotal += amount;
      }
    }

    final List<DashboardCategoryBreakdownModel> result = catSums.entries.map((e) {
      final percentage = grandTotal > 0 ? (e.value / grandTotal) * 100 : 0.0;
      return DashboardCategoryBreakdownModel(
        categoryName: labelMap[e.key] ?? e.key,
        amount: e.value,
        percentage: percentage,
        emoji: emojiMap[e.key] ?? '💰',
      );
    }).toList();

    result.sort((a, b) => b.amount.compareTo(a.amount));
    return result;
  }

  // ---------------------------------------------------------------------------
  // Daily Trend Points
  // ---------------------------------------------------------------------------

  @override
  Future<List<DashboardTrendPointModel>> getTrendPoints(
    DateTime start,
    DateTime end,
  ) async {
    final Map<DateTime, double> dailyIncome = {};
    final Map<DateTime, double> dailyExpense = {};

    for (final raw in localDb.incomeBox.values) {
      final map = Map<String, dynamic>.from(raw);
      final date = _parseDate(map['date']);
      if (_inRange(date, start, end)) {
        final day = DateTime(date.year, date.month, date.day);
        dailyIncome[day] =
            (dailyIncome[day] ?? 0) + (map['amount'] as num? ?? 0).toDouble();
      }
    }

    for (final raw in localDb.expensesBox.values) {
      final map = Map<String, dynamic>.from(raw);
      final date = _parseDate(map['date']);
      if (_inRange(date, start, end)) {
        final day = DateTime(date.year, date.month, date.day);
        dailyExpense[day] =
            (dailyExpense[day] ?? 0) + (map['amount'] as num? ?? 0).toDouble();
      }
    }

    final List<DashboardTrendPointModel> trends = [];
    DateTime cursor = DateTime(start.year, start.month, start.day);
    final endDay = DateTime(end.year, end.month, end.day);
    double cumulativeBalance = 0.0;

    while (!cursor.isAfter(endDay)) {
      final inc = dailyIncome[cursor] ?? 0.0;
      final exp = dailyExpense[cursor] ?? 0.0;
      cumulativeBalance += (inc - exp);
      trends.add(DashboardTrendPointModel(
        date: cursor,
        income: inc,
        expense: exp,
        balance: cumulativeBalance,
      ));
      cursor = cursor.add(const Duration(days: 1));
    }

    return trends;
  }

  // ---------------------------------------------------------------------------
  // Recent Activities
  // ---------------------------------------------------------------------------

  @override
  Future<List<DashboardRecentActivityModel>> getRecentActivities(
    DateTime start,
    DateTime end, {
    int limit = 8,
  }) async {
    final List<DashboardRecentActivityModel> activities = [];

    // Expenses
    final Map<String, String> expEmojiMap = {};
    for (final raw in localDb.expenseCategoriesBox.values) {
      final map = Map<String, dynamic>.from(raw);
      expEmojiMap[map['id'] as String? ?? ''] =
          map['emoji'] as String? ?? '💸';
    }
    for (final raw in localDb.expensesBox.values) {
      final map = Map<String, dynamic>.from(raw);
      final date = _parseDate(map['date']);
      if (_inRange(date, start, end)) {
        final category = map['category'] as String? ?? 'other';
        activities.add(DashboardRecentActivityModel(
          id: map['id'] as String? ?? '',
          title: (map['description'] as String? ?? '').isNotEmpty
              ? map['description'] as String
              : category,
          category: category,
          amount: (map['amount'] as num? ?? 0).toDouble(),
          date: date,
          type: 'expense',
          emoji: expEmojiMap[category] ?? '💸',
        ));
      }
    }

    // Income
    final Map<String, String> incLabelMap = {};
    final Map<String, String> incEmojiMap = {};
    for (final raw in localDb.incomeCategoriesBox.values) {
      final map = Map<String, dynamic>.from(raw);
      final id = map['id'] as String? ?? '';
      incLabelMap[id] = map['name'] as String? ?? id;
      incEmojiMap[id] = map['emoji'] as String? ?? '💰';
    }
    for (final raw in localDb.incomeBox.values) {
      final map = Map<String, dynamic>.from(raw);
      final date = _parseDate(map['date']);
      if (_inRange(date, start, end)) {
        final catId = map['categoryId'] as String? ?? '';
        activities.add(DashboardRecentActivityModel(
          id: map['id'] as String? ?? '',
          title: (map['description'] as String? ?? '').isNotEmpty
              ? map['description'] as String
              : incLabelMap[catId] ?? 'Income',
          category: incLabelMap[catId] ?? catId,
          amount: (map['amount'] as num? ?? 0).toDouble(),
          date: date,
          type: 'income',
          emoji: incEmojiMap[catId] ?? '💰',
        ));
      }
    }

    // Lendings
    final Map<String, String> personNameMap = {};
    for (final raw in localDb.personsBox.values) {
      final map = Map<String, dynamic>.from(raw);
      personNameMap[map['id'] as String? ?? ''] =
          map['name'] as String? ?? 'Unknown';
    }
    for (final raw in localDb.lendingsBox.values) {
      final map = Map<String, dynamic>.from(raw);
      final date = _parseDate(map['createdDate']);
      if (_inRange(date, start, end)) {
        final type = map['type'] as String? ?? '';
        final personId = map['personId'] as String? ?? '';
        final personName = personNameMap[personId] ?? 'Unknown';
        activities.add(DashboardRecentActivityModel(
          id: map['id'] as String? ?? '',
          title: type == 'given'
              ? 'Lent to $personName'
              : 'Borrowed from $personName',
          category: 'Lending',
          amount: (map['amount'] as num? ?? 0).toDouble(),
          date: date,
          type: 'lending',
          emoji: '🤝',
        ));
      }
    }

    activities.sort((a, b) => b.date.compareTo(a.date));
    return activities.take(limit).toList();
  }
}
