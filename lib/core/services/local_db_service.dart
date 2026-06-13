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

  Future<void> init() async {
    await Hive.initFlutter();

    final suffix = AppConfig.get('DB_SUFFIX');
    
    // Open boxes with environment suffix to prevent data bleed
    _expensesBox = await Hive.openBox<Map>('expenses$suffix');
    _investmentsBox = await Hive.openBox<Map>('investments$suffix');
    _lendingsBox = await Hive.openBox<Map>('lendings$suffix');
    _personsBox = await Hive.openBox<Map>('persons$suffix');
    _repaymentsBox = await Hive.openBox<Map>('repayments$suffix');
    _syncQueueBox = await Hive.openBox<Map>('pending_sync_operations$suffix');
  }

  Box<Map> get expensesBox => _expensesBox;
  Box<Map> get investmentsBox => _investmentsBox;
  Box<Map> get lendingsBox => _lendingsBox;
  Box<Map> get personsBox => _personsBox;
  Box<Map> get repaymentsBox => _repaymentsBox;
  Box<Map> get syncQueueBox => _syncQueueBox;

  /// Utility to clear all databases (useful for testing or full resets)
  Future<void> clearAll() async {
    await _expensesBox.clear();
    await _investmentsBox.clear();
    await _lendingsBox.clear();
    await _personsBox.clear();
    await _repaymentsBox.clear();
    await _syncQueueBox.clear();
  }
}
