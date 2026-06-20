import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:hive/hive.dart';
import 'package:finkeep/core/services/local_db_service.dart';

class BackupService {
  final LocalDbService localDb;

  BackupService({required this.localDb});

  // Obfuscated 32-byte key (legacy Spendly key preserved for backup compatibility)
  static final List<int> _keyBytes = [
    83, 112, 101, 110, 100, 108, 121, 83, 101, 99, 117, 114, 101, 66, 97, 99,
    107, 117, 112, 75, 101, 121, 50, 48, 50, 54, 33, 64, 35, 36, 37, 94
  ];

  // Obfuscated 16-byte IV (legacy Spendly IV preserved for backup compatibility)
  static final List<int> _ivBytes = [
    83, 112, 101, 110, 100, 108, 121, 73, 86, 73, 110, 105, 116, 50, 48, 54
  ];

  /// Exports all Hive box data as an encrypted binary list
  Future<Uint8List> exportEncryptedBackup() async {
    final jsonString = await exportBackup();
    final key = encrypt.Key(Uint8List.fromList(_keyBytes));
    final iv = encrypt.IV(Uint8List.fromList(_ivBytes));
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(jsonString, iv: iv);
    return encrypted.bytes;
  }

  /// Imports data from encrypted binary list into Hive boxes, overwriting existing items
  Future<void> importEncryptedBackup(Uint8List encryptedData) async {
    final key = encrypt.Key(Uint8List.fromList(_keyBytes));
    final iv = encrypt.IV(Uint8List.fromList(_ivBytes));
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypt.Encrypted(encryptedData);
    final decryptedJson = encrypter.decrypt(encrypted, iv: iv);
    await importBackup(decryptedJson);
  }

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

    final cleanBackup = _deepConvertDateTimes(backup);

    // Use JsonEncoder.withIndent to make it pretty and readable
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(cleanBackup);
  }

  /// Imports data from a JSON string into Hive boxes, overwriting existing items
  Future<void> importBackup(String jsonString) async {
    final Map<String, dynamic> rawData;
    try {
      rawData = json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Invalid JSON formatting: $e');
    }

    final data = _deepRestoreDateTimes(rawData) as Map<String, dynamic>;

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

  dynamic _deepConvertDateTimes(dynamic val) {
    if (val is Map) {
      return val.map((k, v) => MapEntry(k.toString(), _deepConvertDateTimes(v)));
    } else if (val is List) {
      return val.map((item) => _deepConvertDateTimes(item)).toList();
    } else if (val is DateTime) {
      return val.toIso8601String();
    }
    return val;
  }

  dynamic _deepRestoreDateTimes(dynamic val) {
    if (val is Map) {
      return val.map((k, v) => MapEntry(k.toString(), _deepRestoreDateTimes(v)));
    } else if (val is List) {
      return val.map((item) => _deepRestoreDateTimes(item)).toList();
    } else if (val is String) {
      if (RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}').hasMatch(val)) {
        try {
          return DateTime.parse(val);
        } catch (_) {
          return val;
        }
      }
    }
    return val;
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
