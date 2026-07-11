import 'package:hive_flutter/hive_flutter.dart';
import '../config/app_config.dart';

class LocalDbService {
  static final LocalDbService _instance = LocalDbService._internal();
  factory LocalDbService() => _instance;
  LocalDbService._internal();

  late final Box<Map> _expensesBox;
  late final Box<Map> _investmentsBox;
  late final Box<Map> _lendingsBox;
  late final Box<Map> _personsBox;
  late final Box<Map> _repaymentsBox;
  late final Box<Map> _syncQueueBox;
  late final Box<Map> _budgetsBox;
  late final Box<Map> _incomeBox;
  late final Box<Map> _incomeCategoriesBox;
  late final Box<Map> _expenseCategoriesBox;

  Future<void> init() async {
    await Hive.initFlutter();

    // Open single, unified boxes without environment suffix
    _expensesBox = await Hive.openBox<Map>('expenses');
    _investmentsBox = await Hive.openBox<Map>('investments');
    _lendingsBox = await Hive.openBox<Map>('lendings');
    _personsBox = await Hive.openBox<Map>('persons');
    _repaymentsBox = await Hive.openBox<Map>('repayments');
    _syncQueueBox = await Hive.openBox<Map>('pending_sync_operations');
    _budgetsBox = await Hive.openBox<Map>('budgets');
    _incomeBox = await Hive.openBox<Map>('income');
    _incomeCategoriesBox = await Hive.openBox<Map>('income_categories');
    _expenseCategoriesBox = await Hive.openBox<Map>('expense_categories');

    // Run a silent, one-time migration for legacy personal mode users
    final suffix = AppConfig.get('DB_SUFFIX');
    if (suffix == '_personal') {
      await _migrateLegacyPersonalData();
    }
  }

  Future<void> _migrateLegacyPersonalData() async {
    final boxesToMigrate = [
      'expenses',
      'investments',
      'lendings',
      'persons',
      'repayments',
      'pending_sync_operations',
      'budgets',
      'income',
      'income_categories',
      'expense_categories',
    ];

    for (final boxName in boxesToMigrate) {
      final legacyName = '${boxName}_personal';
      try {
        if (await Hive.boxExists(legacyName)) {
          final legacyBox = await Hive.openBox<Map>(legacyName);
          if (legacyBox.isNotEmpty) {
            final mainBox = Hive.isBoxOpen(boxName) ? Hive.box<Map>(boxName) : await Hive.openBox<Map>(boxName);
            if (mainBox.isEmpty) {
              await mainBox.putAll(legacyBox.toMap());
            }
          }
          await legacyBox.close();
          await Hive.deleteBoxFromDisk(legacyName);
        }
      } catch (_) {
        // Fail silently during migration to prevent boot crashes
      }
    }
  }

  Box<Map> get expensesBox => _expensesBox;
  Box<Map> get investmentsBox => _investmentsBox;
  Box<Map> get lendingsBox => _lendingsBox;
  Box<Map> get personsBox => _personsBox;
  Box<Map> get repaymentsBox => _repaymentsBox;
  Box<Map> get syncQueueBox => _syncQueueBox;
  Box<Map> get budgetsBox => _budgetsBox;
  Box<Map> get incomeBox => _incomeBox;
  Box<Map> get incomeCategoriesBox => _incomeCategoriesBox;
  Box<Map> get expenseCategoriesBox => _expenseCategoriesBox;

  /// Utility to clear all databases (useful for testing or full resets)
  Future<void> clearAll() async {
    await _expensesBox.clear();
    await _investmentsBox.clear();
    await _lendingsBox.clear();
    await _personsBox.clear();
    await _repaymentsBox.clear();
    await _syncQueueBox.clear();
    await _budgetsBox.clear();
    await _incomeBox.clear();
    await _incomeCategoriesBox.clear();
    await _expenseCategoriesBox.clear();
  }
}
