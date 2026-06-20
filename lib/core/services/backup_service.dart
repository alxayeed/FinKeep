import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:hive/hive.dart';
import 'package:finkeep/core/config/app_config.dart';
import 'package:finkeep/core/constants/app_strings.dart';
import 'package:finkeep/core/services/local_db_service.dart';
import 'package:finkeep/features/expense/data/models/expense_model.dart';
import 'package:finkeep/features/investments/data/models/investment_model.dart';
import 'package:finkeep/features/lendings/data/models/lending/lending_model.dart';
import 'package:finkeep/features/lendings/data/models/lending_person/lending_person_model.dart';
import 'package:finkeep/features/lendings/data/models/repayment/repayment_model.dart';

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

  /// Synchronizes remote Firestore database to local Hive boxes.
  Future<void> syncRemoteToLocal({Function(String)? onProgress}) async {
    if (!AppConfig.isPersonal) return;

    final firestore = FirebaseFirestore.instance;

    // 1. Sync Expenses
    onProgress?.call('Fetching remote expenses (1/6)...');
    final expensesColName = 'expenses';
    final expensesSnapshot = await firestore.collection(expensesColName).get();
    await localDb.expensesBox.clear();
    for (final doc in expensesSnapshot.docs) {
      final data = doc.data();
      data['id'] = doc.id;
      final model = ExpenseModel.fromFirestoreMap(data);
      await localDb.expensesBox.put(model.id, model.toJson());
    }

    // 2. Sync Investments
    onProgress?.call('Fetching remote investments (2/6)...');
    final investmentsColName = AppStrings.investmentsCollection;
    final investmentsSnapshot = await firestore.collection(investmentsColName).get();
    await localDb.investmentsBox.clear();
    for (final doc in investmentsSnapshot.docs) {
      final data = doc.data();
      data['id'] = doc.id;
      final model = InvestmentModel.fromFirestoreMap(data);
      await localDb.investmentsBox.put(model.id, model.toJson());
    }

    // 3. Sync Lending Persons (loan parties)
    onProgress?.call('Fetching remote loan parties (3/6)...');
    final loanPartiesColName = AppStrings.lendingPersonCollection;
    final loanPartiesSnapshot = await firestore.collection(loanPartiesColName).get();
    await localDb.personsBox.clear();
    for (final doc in loanPartiesSnapshot.docs) {
      final data = doc.data();
      data['id'] = doc.id;
      final model = LendingPersonModel.fromJson(data);
      await localDb.personsBox.put(model.id, model.toJson());
    }

    // 4. Sync Repayments
    onProgress?.call('Fetching remote repayments (4/6)...');
    final repaymentsColName = AppStrings.repaymentsCollection;
    final repaymentsSnapshot = await firestore.collection(repaymentsColName).get();
    await localDb.repaymentsBox.clear();
    for (final doc in repaymentsSnapshot.docs) {
      final data = doc.data();
      data['id'] = doc.id;
      final model = RepaymentModel.fromFirestoreMap(data);
      await localDb.repaymentsBox.put(model.id, model.toJson());
    }

    // 5. Sync Lendings (requires local Persons and Repayments to be in database for relationships)
    onProgress?.call('Fetching remote lendings (5/6)...');
    final lendingsColName = AppStrings.lendingsCollection;
    final lendingsSnapshot = await firestore.collection(lendingsColName).get();
    await localDb.lendingsBox.clear();
    for (final doc in lendingsSnapshot.docs) {
      final data = doc.data();
      data['id'] = doc.id;
      
      final personId = data['personId'] as String;
      final localPerson = localDb.personsBox.get(personId);
      if (localPerson != null) {
        data['person'] = Map<String, dynamic>.from(localPerson);
      } else {
        data['person'] = {
          'id': personId,
          'name': 'Unknown',
          'phoneNumber': '',
        };
      }

      final lendingRepayments = localDb.repaymentsBox.values
          .where((r) => r['lendingId'] == doc.id)
          .map((r) => Map<String, dynamic>.from(r))
          .toList();
      data['repayments'] = lendingRepayments;

      final model = LendingModel.fromFirestoreMap(data);
      final modelJson = model.toJson();
      if (model.repayments != null) {
        modelJson['repayments'] = model.repayments!.map((r) => r.toJson()).toList();
      }
      modelJson['person'] = model.person.toJson();
      await localDb.lendingsBox.put(model.id, modelJson);
    }

    // 6. Sync Budgets
    onProgress?.call('Fetching remote budgets (6/6)...');
    final budgetsColName = AppConfig.get('FIRESTORE_SUFFIX').isEmpty
        ? 'budgets'
        : 'budgets${AppConfig.get('FIRESTORE_SUFFIX')}';
    final budgetsSnapshot = await firestore.collection(budgetsColName).get();
    await localDb.budgetsBox.clear();
    for (final doc in budgetsSnapshot.docs) {
      final data = doc.data();
      if (data['updatedAt'] is Timestamp) {
        data['updatedAt'] = (data['updatedAt'] as Timestamp).toDate().toIso8601String();
      }
      await localDb.budgetsBox.put(doc.id, data);
    }
  }

  /// Exports all Hive box data as an encrypted binary list
  Future<Uint8List> exportEncryptedBackup({Function(String)? onProgress}) async {
    if (AppConfig.isPersonal) {
      await syncRemoteToLocal(onProgress: onProgress);
    }
    onProgress?.call('Encrypting and packaging data...');
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
