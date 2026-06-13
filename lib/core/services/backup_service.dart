import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:spendly/core/services/local_db_service.dart';

class BackupService {
  final LocalDbService localDb;

  BackupService({required this.localDb});

  /// Exports all Hive box data to a formatted JSON string
  Future<String> exportBackup() async {
    final Map<String, dynamic> backup = {
      'version': '1.0',
      'exportedAt': DateTime.now().toIso8601String(),
      'expenses': _getBoxItems(localDb.expensesBox),
      'investments': _getBoxItems(localDb.investmentsBox),
      'lendings': _getBoxItems(localDb.lendingsBox),
      'persons': _getBoxItems(localDb.personsBox),
      'repayments': _getBoxItems(localDb.repaymentsBox),
      'budgets': _getBoxItems(localDb.budgetsBox),
    };

    // Use JsonEncoder.withIndent to make it pretty and readable
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(backup);
  }

  /// Imports data from a JSON string into Hive boxes, overwriting existing items
  Future<void> importBackup(String jsonString) async {
    final Map<String, dynamic> data;
    try {
      data = json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Invalid JSON formatting: $e');
    }

    // Basic structure validation
    final expectedKeys = ['expenses', 'investments', 'lendings', 'persons', 'repayments', 'budgets'];
    for (final key in expectedKeys) {
      if (!data.containsKey(key) || data[key] is! List) {
        throw Exception('Format validation failed: Missing or invalid list for "$key"');
      }
    }

    // Clear existing local cache before loading backup
    await localDb.clearAll();

    // Import each collection
    await _importToBox(localDb.expensesBox, data['expenses'] as List);
    await _importToBox(localDb.investmentsBox, data['investments'] as List);
    await _importToBox(localDb.lendingsBox, data['lendings'] as List);
    await _importToBox(localDb.personsBox, data['persons'] as List);
    await _importToBox(localDb.repaymentsBox, data['repayments'] as List);
    await _importToBox(localDb.budgetsBox, data['budgets'] as List);
  }

  List<Map<String, dynamic>> _getBoxItems(Box<Map> box) {
    return box.values.map((val) => Map<String, dynamic>.from(val)).toList();
  }

  Future<void> _importToBox(Box<Map> box, List items) async {
    for (final item in items) {
      if (item is Map) {
        final mapItem = Map<String, dynamic>.from(item);
        final id = mapItem['id'];
        if (id != null && id is String) {
          await box.put(id, mapItem);
        }
      }
    }
  }
}
