import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkeep/core/config/app_config.dart';
import 'package:finkeep/core/utils/date_parser.dart';
import 'package:intl/intl.dart';

import '../models/dashboard_aggregate_stats_model.dart';
import '../models/dashboard_category_breakdown_model.dart';
import '../models/dashboard_recent_activity_model.dart';
import '../models/dashboard_trend_point_model.dart';
import 'dashboard_remote_datasource.dart';

/// Firestore collection names used across other features — defined here
/// to keep the dashboard fully self-contained.
class _Collections {
  static String expenses(bool isPersonal) =>
      isPersonal ? 'expenses' : 'expenses_dev';
  static String income(bool isPersonal) =>
      isPersonal ? 'income' : 'income_dev';
  static String lendings(bool isPersonal) =>
      isPersonal ? 'lendings' : 'lendings_dev';
  static String persons(bool isPersonal) =>
      isPersonal ? 'persons' : 'persons_dev';
  static String investments(bool isPersonal) =>
      isPersonal ? 'investments' : 'investments_dev';
  static String budgets(bool isPersonal) =>
      isPersonal ? 'budgets' : 'budgets_dev';
  static String incomeCategories(bool isPersonal) =>
      isPersonal ? 'income_categories' : 'income_categories_dev';
  static String expenseCategories(bool isPersonal) =>
      isPersonal ? 'expense_categories' : 'expense_categories_dev';
}

class DashboardFirestoreDataSource implements DashboardRemoteDataSource {
  final FirebaseFirestore fireStore;
  late final bool _isPersonal;

  DashboardFirestoreDataSource({required this.fireStore}) {
    _isPersonal = AppConfig.isPersonal;
  }

  DateTime _parseDate(dynamic val) => DateParser.parse(val);

  // ---------------------------------------------------------------------------
  // Aggregate Stats
  // ---------------------------------------------------------------------------

  @override
  Future<DashboardAggregateStatsModel> getAggregateStats(
    DateTime start,
    DateTime end,
  ) async {
    final startTs = Timestamp.fromDate(start);
    final endTs = Timestamp.fromDate(end);

    // Parallel fetch expenses and income
    final expenseFuture = fireStore
        .collection(_Collections.expenses(_isPersonal))
        .where('date', isGreaterThanOrEqualTo: startTs)
        .where('date', isLessThanOrEqualTo: endTs)
        .get();

    final incomeFuture = fireStore
        .collection(_Collections.income(_isPersonal))
        .where('date', isGreaterThanOrEqualTo: startTs)
        .where('date', isLessThanOrEqualTo: endTs)
        .get();

    final lendingsFuture =
        fireStore.collection(_Collections.lendings(_isPersonal)).get();

    final investmentsFuture =
        fireStore.collection(_Collections.investments(_isPersonal)).get();

    final results = await Future.wait(
        [expenseFuture, incomeFuture, lendingsFuture, investmentsFuture]);

    final expenseDocs = results[0].docs;
    final incomeDocs = results[1].docs;
    final lendingDocs = results[2].docs;
    final investmentDocs = results[3].docs;

    double totalExpense = 0.0;
    for (final doc in expenseDocs) {
      totalExpense += (doc['amount'] as num? ?? 0).toDouble();
    }

    double totalIncome = 0.0;
    for (final doc in incomeDocs) {
      totalIncome += (doc['amount'] as num? ?? 0).toDouble();
    }

    double totalGivenDue = 0.0;
    double totalReceivedDue = 0.0;
    for (final doc in lendingDocs) {
      final data = doc.data();
      final lendingAmount = (data['amount'] as num? ?? 0).toDouble();
      final repaid = (data['repaidAmount'] as num? ?? 0).toDouble();
      final due = (lendingAmount - repaid).clamp(0, double.infinity).toDouble();
      final type = data['type'] as String? ?? '';
      if (type == 'given') {
        totalGivenDue += due;
      } else if (type == 'taken') {
        totalReceivedDue += due;
      }
    }

    double totalInvested = 0.0;
    double totalInvestmentProfit = 0.0;
    for (final doc in investmentDocs) {
      final data = doc.data();
      final invested = (data['amountInvested'] as num? ?? 0).toDouble();
      final status = data['status'] as String? ?? '';
      final returns = (data['returns'] as List<dynamic>? ?? []);
      double returnsSum = 0.0;
      for (final r in returns) {
        final rMap = r as Map<String, dynamic>;
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
    final savingsRate =
        totalIncome > 0 ? (netSavings / totalIncome) * 100 : 0.0;
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
      final doc = await fireStore
          .collection(_Collections.budgets(_isPersonal))
          .doc(key)
          .get();
      if (doc.exists && doc.data() != null) {
        total +=
            (doc.data()!['overallBudget'] as num? ?? 0).toDouble();
      } else {
        // Fallback to recurring budget
        final recurring = await fireStore
            .collection(_Collections.budgets(_isPersonal))
            .doc('recurring')
            .get();
        if (recurring.exists && recurring.data() != null) {
          total +=
              (recurring.data()!['overallBudget'] as num? ?? 0).toDouble();
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
    final startTs = Timestamp.fromDate(start);
    final endTs = Timestamp.fromDate(end);

    final results = await Future.wait([
      fireStore
          .collection(_Collections.expenses(_isPersonal))
          .where('date', isGreaterThanOrEqualTo: startTs)
          .where('date', isLessThanOrEqualTo: endTs)
          .get(),
      fireStore
          .collection(_Collections.expenseCategories(_isPersonal))
          .get(),
    ]);

    final expenseDocs = results[0].docs;
    final categoryDocs = results[1].docs;

    final Map<String, String> emojiMap = {
      for (final doc in categoryDocs)
        (doc['id'] ?? doc.id) as String: (doc['emoji'] ?? '💸') as String
    };

    final Map<String, double> catSums = {};
    double grandTotal = 0.0;
    for (final doc in expenseDocs) {
      final category = doc['category'] as String? ?? 'other';
      final amount = (doc['amount'] as num? ?? 0).toDouble();
      catSums[category] = (catSums[category] ?? 0) + amount;
      grandTotal += amount;
    }

    final result = catSums.entries.map((e) {
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
    final startTs = Timestamp.fromDate(start);
    final endTs = Timestamp.fromDate(end);

    final results = await Future.wait([
      fireStore
          .collection(_Collections.income(_isPersonal))
          .where('date', isGreaterThanOrEqualTo: startTs)
          .where('date', isLessThanOrEqualTo: endTs)
          .get(),
      fireStore
          .collection(_Collections.incomeCategories(_isPersonal))
          .get(),
    ]);

    final incomeDocs = results[0].docs;
    final categoryDocs = results[1].docs;

    final Map<String, String> labelMap = {};
    final Map<String, String> emojiMap = {};
    for (final doc in categoryDocs) {
      final id = (doc['id'] ?? doc.id) as String;
      labelMap[id] = (doc['name'] ?? id) as String;
      emojiMap[id] = (doc['emoji'] ?? '💰') as String;
    }

    final Map<String, double> catSums = {};
    double grandTotal = 0.0;
    for (final doc in incomeDocs) {
      final catId = doc['categoryId'] as String? ?? 'other';
      final amount = (doc['amount'] as num? ?? 0).toDouble();
      catSums[catId] = (catSums[catId] ?? 0) + amount;
      grandTotal += amount;
    }

    final result = catSums.entries.map((e) {
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
    final startTs = Timestamp.fromDate(start);
    final endTs = Timestamp.fromDate(end);

    final results = await Future.wait([
      fireStore
          .collection(_Collections.income(_isPersonal))
          .where('date', isGreaterThanOrEqualTo: startTs)
          .where('date', isLessThanOrEqualTo: endTs)
          .get(),
      fireStore
          .collection(_Collections.expenses(_isPersonal))
          .where('date', isGreaterThanOrEqualTo: startTs)
          .where('date', isLessThanOrEqualTo: endTs)
          .get(),
    ]);

    final Map<DateTime, double> dailyIncome = {};
    final Map<DateTime, double> dailyExpense = {};

    for (final doc in results[0].docs) {
      final date = _parseDate(doc['date']);
      final day = DateTime(date.year, date.month, date.day);
      dailyIncome[day] =
          (dailyIncome[day] ?? 0) + (doc['amount'] as num? ?? 0).toDouble();
    }
    for (final doc in results[1].docs) {
      final date = _parseDate(doc['date']);
      final day = DateTime(date.year, date.month, date.day);
      dailyExpense[day] =
          (dailyExpense[day] ?? 0) + (doc['amount'] as num? ?? 0).toDouble();
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
    final startTs = Timestamp.fromDate(start);
    final endTs = Timestamp.fromDate(end);

    final results = await Future.wait([
      fireStore
          .collection(_Collections.expenses(_isPersonal))
          .where('date', isGreaterThanOrEqualTo: startTs)
          .where('date', isLessThanOrEqualTo: endTs)
          .get(),
      fireStore
          .collection(_Collections.income(_isPersonal))
          .where('date', isGreaterThanOrEqualTo: startTs)
          .where('date', isLessThanOrEqualTo: endTs)
          .get(),
      fireStore
          .collection(_Collections.lendings(_isPersonal))
          .where('createdDate', isGreaterThanOrEqualTo: startTs)
          .where('createdDate', isLessThanOrEqualTo: endTs)
          .get(),
      fireStore
          .collection(_Collections.expenseCategories(_isPersonal))
          .get(),
      fireStore
          .collection(_Collections.incomeCategories(_isPersonal))
          .get(),
      fireStore
          .collection(_Collections.persons(_isPersonal))
          .get(),
    ]);

    final expenseDocs = results[0].docs;
    final incomeDocs = results[1].docs;
    final lendingDocs = results[2].docs;
    final expCatDocs = results[3].docs;
    final incCatDocs = results[4].docs;
    final personDocs = results[5].docs;

    final Map<String, String> expEmojiMap = {
      for (final doc in expCatDocs)
        (doc['id'] ?? doc.id) as String: (doc['emoji'] ?? '💸') as String
    };
    final Map<String, String> incLabelMap = {};
    final Map<String, String> incEmojiMap = {};
    for (final doc in incCatDocs) {
      final id = (doc['id'] ?? doc.id) as String;
      incLabelMap[id] = (doc['name'] ?? id) as String;
      incEmojiMap[id] = (doc['emoji'] ?? '💰') as String;
    }
    final Map<String, String> personNameMap = {
      for (final doc in personDocs)
        doc.id: (doc['name'] ?? 'Unknown') as String
    };

    final List<DashboardRecentActivityModel> activities = [];

    for (final doc in expenseDocs) {
      final date = _parseDate(doc['date']);
      final category = doc['category'] as String? ?? 'other';
      final description = doc['description'] as String? ?? '';
      activities.add(DashboardRecentActivityModel(
        id: doc.id,
        title: description.isNotEmpty ? description : category,
        category: category,
        amount: (doc['amount'] as num? ?? 0).toDouble(),
        date: date,
        type: 'expense',
        emoji: expEmojiMap[category] ?? '💸',
      ));
    }

    for (final doc in incomeDocs) {
      final date = _parseDate(doc['date']);
      final catId = doc['categoryId'] as String? ?? '';
      final description = doc['description'] as String? ?? '';
      activities.add(DashboardRecentActivityModel(
        id: doc.id,
        title: description.isNotEmpty
            ? description
            : incLabelMap[catId] ?? 'Income',
        category: incLabelMap[catId] ?? catId,
        amount: (doc['amount'] as num? ?? 0).toDouble(),
        date: date,
        type: 'income',
        emoji: incEmojiMap[catId] ?? '💰',
      ));
    }

    for (final doc in lendingDocs) {
      final date = _parseDate(doc['createdDate']);
      final type = doc['type'] as String? ?? '';
      final personId = doc['personId'] as String? ?? '';
      final personName = personNameMap[personId] ?? 'Unknown';
      activities.add(DashboardRecentActivityModel(
        id: doc.id,
        title: type == 'given'
            ? 'Lent to $personName'
            : 'Borrowed from $personName',
        category: 'Lending',
        amount: (doc['amount'] as num? ?? 0).toDouble(),
        date: date,
        type: 'lending',
        emoji: '🤝',
      ));
    }

    activities.sort((a, b) => b.date.compareTo(a.date));
    return activities.take(limit).toList();
  }
}
