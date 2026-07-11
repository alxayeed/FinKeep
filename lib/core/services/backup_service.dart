import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:hive/hive.dart';
import 'package:finkeep/core/config/app_config.dart';
import 'package:finkeep/core/constants/app_strings.dart';
import 'package:finkeep/core/error/exception_handler.dart';
import 'package:finkeep/core/services/local_db_service.dart';
import 'package:finkeep/features/expense/data/models/expense_model.dart';
import 'package:finkeep/features/investments/data/models/investment_model.dart';
import 'package:finkeep/features/lendings/data/models/lending/lending_model.dart';
import 'package:finkeep/features/lendings/data/models/lending_person/lending_person_model.dart';
import 'package:finkeep/features/lendings/data/models/repayment/repayment_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/widgets.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      final success = await BackupService.performBackup();
      return success;
    } catch (e) {
      return false;
    }
  });
}

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

    // Pre-group repayments by lendingId beforehand to achieve O(N + M) lookup complexity
    final Map<String, List<Map<String, dynamic>>> repaymentsByLendingId = {};
    for (final rawRepayment in localDb.repaymentsBox.values) {
      final map = Map<String, dynamic>.from(rawRepayment);
      final lendingId = map['lendingId'] as String?;
      if (lendingId != null) {
        repaymentsByLendingId.putIfAbsent(lendingId, () => []).add(map);
      }
    }

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

      data['repayments'] = repaymentsByLendingId[doc.id] ?? [];

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

  /// Imports data from encrypted binary list into Hive boxes, overwriting/merging existing items
  Future<void> importEncryptedBackup(Uint8List encryptedData, {Function(String)? onProgress}) async {
    final key = encrypt.Key(Uint8List.fromList(_keyBytes));
    final iv = encrypt.IV(Uint8List.fromList(_ivBytes));
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    
    encrypt.Encrypted encrypted;
    try {
      final possibleBase64 = utf8.decode(encryptedData).trim();
      // Validate it's indeed valid base64
      base64.decode(possibleBase64);
      encrypted = encrypt.Encrypted.fromBase64(possibleBase64);
    } catch (_) {
      encrypted = encrypt.Encrypted(encryptedData);
    }
    
    final decryptedJson = encrypter.decrypt(encrypted, iv: iv);
    await importBackup(decryptedJson, onProgress: onProgress);
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

  /// Imports data from a JSON string into Hive boxes, merging existing items
  Future<void> importBackup(String jsonString, {Function(String)? onProgress}) async {
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

    // Merge into local boxes (no clearAll)
    onProgress?.call('Merging local expenses...');
    await _importToBox(localDb.expensesBox, data['expenses'] as List);

    onProgress?.call('Merging local investments...');
    await _importToBox(localDb.investmentsBox, data['investments'] as List);

    onProgress?.call('Merging local lendings...');
    await _importToBox(localDb.lendingsBox, data['lendings'] as List);

    onProgress?.call('Merging local loan parties...');
    await _importToBox(localDb.personsBox, data['persons'] as List);

    onProgress?.call('Merging local repayments...');
    await _importToBox(localDb.repaymentsBox, data['repayments'] as List);

    onProgress?.call('Merging local budgets...');
    await _importToBox(localDb.budgetsBox, data['budgets'] as List);

    // Merge new optional income and category boxes if they exist
    if (data.containsKey('income') && data['income'] is List) {
      onProgress?.call('Merging local income logs...');
      await _importToBox(localDb.incomeBox, data['income'] as List);
    }

    if (data.containsKey('income_categories') && data['income_categories'] is List) {
      onProgress?.call('Merging local income categories...');
      await _importToBox(localDb.incomeCategoriesBox, data['income_categories'] as List);
    }

    if (data.containsKey('expense_categories') && data['expense_categories'] is List) {
      onProgress?.call('Merging local expense categories...');
      await _importToBox(localDb.expenseCategoriesBox, data['expense_categories'] as List);
    }

    // If cloud mode is active, merge into Firestore
    if (AppConfig.isPersonal) {
      onProgress?.call('Syncing merged expenses with cloud...');
      final expensesColName = 'expenses';
      await _mergeToFirestore(expensesColName, rawData['expenses'] as List);

      onProgress?.call('Syncing merged investments with cloud...');
      final investmentsColName = AppStrings.investmentsCollection;
      await _mergeToFirestore(investmentsColName, rawData['investments'] as List);

      onProgress?.call('Syncing merged loan parties with cloud...');
      final loanPartiesColName = AppStrings.lendingPersonCollection;
      await _mergeToFirestore(loanPartiesColName, rawData['persons'] as List);

      onProgress?.call('Syncing merged repayments with cloud...');
      final repaymentsColName = AppStrings.repaymentsCollection;
      await _mergeToFirestore(repaymentsColName, rawData['repayments'] as List);

      onProgress?.call('Syncing merged lendings with cloud...');
      final lendingsColName = AppStrings.lendingsCollection;
      await _mergeToFirestore(lendingsColName, rawData['lendings'] as List);

      onProgress?.call('Syncing merged budgets with cloud...');
      final budgetsColName = AppConfig.get('FIRESTORE_SUFFIX').isEmpty
          ? 'budgets'
          : 'budgets${AppConfig.get('FIRESTORE_SUFFIX')}';
      await _mergeToFirestore(budgetsColName, rawData['budgets'] as List, isBudget: true);
    }
  }

  Future<void> _mergeToFirestore(String collectionName, List items, {bool isBudget = false}) async {
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection(collectionName);
    for (final item in items) {
      if (item is Map) {
        final mapItem = Map<String, dynamic>.from(item);
        final id = mapItem['id'];
        if (id != null && id is String) {
          if (isBudget) {
            final firestoreMap = _deepConvertToFirestoreTimestamps(mapItem);
            await collection.doc(id).set(firestoreMap);
          } else {
            final firestoreMap = _convertToFirestoreMap(collectionName, mapItem);
            if (firestoreMap != null) {
              await collection.doc(id).set(firestoreMap);
            }
          }
        }
      }
    }
  }

  Map<String, dynamic>? _convertToFirestoreMap(String collectionName, Map<String, dynamic> json) {
    try {
      if (collectionName.contains('expenses')) {
        return ExpenseModel.fromJson(json).toFirestoreMap();
      } else if (collectionName.contains('investments')) {
        return InvestmentModel.fromJson(json).toFirestoreMap();
      } else if (collectionName.contains('loan_parties')) {
        return LendingPersonModel.fromJson(json).toJson();
      } else if (collectionName.contains('repayments')) {
        return RepaymentModel.fromJson(json).toFirestoreMap();
      } else if (collectionName.contains('lendings')) {
        return LendingModel.fromJson(json).toFirestoreMap();
      }
    } catch (e, s) {
      ExceptionHandler.handle(e, s, 'BackupService._convertToFirestoreMap ($collectionName)');
    }
    return null;
  }

  Map<String, dynamic> _deepConvertToFirestoreTimestamps(Map<String, dynamic> map) {
    final result = <String, dynamic>{};
    map.forEach((k, v) {
      if (v is String && RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}').hasMatch(v)) {
        try {
          result[k] = Timestamp.fromDate(DateTime.parse(v));
        } catch (_) {
          result[k] = v;
        }
      } else if (v is Map) {
        result[k] = _deepConvertToFirestoreTimestamps(Map<String, dynamic>.from(v));
      } else {
        result[k] = v;
      }
    });
    return result;
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

  /// Core backup logic designed to run safely inside background isolate or main thread
  static Future<bool> performBackup() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      
      // Initialize Hive in isolation
      Hive.init(directory.path);

      final suffix = AppConfig.get('DB_SUFFIX');

      // Helper to retrieve open boxes or open new ones
      Future<Box<Map>> getBox(String name) async {
        final fullName = '$name$suffix';
        return Hive.isBoxOpen(fullName) ? Hive.box<Map>(fullName) : await Hive.openBox<Map>(fullName);
      }

      // Check which boxes were already open in this isolate
      final bool expensesWasOpen = Hive.isBoxOpen('expenses$suffix');
      final bool investmentsWasOpen = Hive.isBoxOpen('investments$suffix');
      final bool lendingsWasOpen = Hive.isBoxOpen('lendings$suffix');
      final bool personsWasOpen = Hive.isBoxOpen('persons$suffix');
      final bool repaymentsWasOpen = Hive.isBoxOpen('repayments$suffix');
      final bool budgetsWasOpen = Hive.isBoxOpen('budgets$suffix');
      final bool incomeWasOpen = Hive.isBoxOpen('income$suffix');
      final bool incomeCategoriesWasOpen = Hive.isBoxOpen('income_categories$suffix');
      final bool expenseCategoriesWasOpen = Hive.isBoxOpen('expense_categories$suffix');

      // Fetch or open boxes
      final expensesBox = await getBox('expenses');
      final investmentsBox = await getBox('investments');
      final lendingsBox = await getBox('lendings');
      final personsBox = await getBox('persons');
      final repaymentsBox = await getBox('repayments');
      final budgetsBox = await getBox('budgets');
      final incomeBox = await getBox('income');
      final incomeCategoriesBox = await getBox('income_categories');
      final expenseCategoriesBox = await getBox('expense_categories');

      // Export into JSON-ready Map
      final Map<String, dynamic> backupPayload = {
        'version': '1.1',
        'exportedAt': DateTime.now().toIso8601String(),
        'expenses': expensesBox.values.map((v) => Map<String, dynamic>.from(v)).toList(),
        'investments': investmentsBox.values.map((v) => Map<String, dynamic>.from(v)).toList(),
        'lendings': lendingsBox.values.map((v) => Map<String, dynamic>.from(v)).toList(),
        'persons': personsBox.values.map((v) => Map<String, dynamic>.from(v)).toList(),
        'repayments': repaymentsBox.values.map((v) => Map<String, dynamic>.from(v)).toList(),
        'budgets': budgetsBox.values.map((v) => Map<String, dynamic>.from(v)).toList(),
        'income': incomeBox.values.map((v) => Map<String, dynamic>.from(v)).toList(),
        'income_categories': incomeCategoriesBox.values.map((v) => Map<String, dynamic>.from(v)).toList(),
        'expense_categories': expenseCategoriesBox.values.map((v) => Map<String, dynamic>.from(v)).toList(),
      };

      // Only close boxes that were NOT already open in this isolate
      if (!expensesWasOpen) await expensesBox.close();
      if (!investmentsWasOpen) await investmentsBox.close();
      if (!lendingsWasOpen) await lendingsBox.close();
      if (!personsWasOpen) await personsBox.close();
      if (!repaymentsWasOpen) await repaymentsBox.close();
      if (!budgetsWasOpen) await budgetsBox.close();
      if (!incomeWasOpen) await incomeBox.close();
      if (!incomeCategoriesWasOpen) await incomeCategoriesBox.close();
      if (!expenseCategoriesWasOpen) await expenseCategoriesBox.close();

      // Normalize DateTimes to ISO strings
      final normalizedPayload = _deepConvertBackupDateTimes(backupPayload);
      final jsonString = jsonEncode(normalizedPayload);

      // Perform AES Encryption (using unified static keys/IVs)
      final key = encrypt.Key(Uint8List.fromList(_keyBytes));
      final iv = encrypt.IV(Uint8List.fromList(_ivBytes));
      final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
      final encrypted = encrypter.encrypt(jsonString, iv: iv);
      final base64Payload = encrypted.base64;

      // Resolve the base directory of the backup
      final baseFile = await getBackupFile();
      final baseDir = baseFile.parent;

      // Delete any previous backups in this folder (both automated_backup_ and finkeep_backup_)
      try {
        final List<FileSystemEntity> files = baseDir.listSync();
        for (final file in files) {
          if (file is File) {
            final fileName = file.path.split('/').last;
            if ((fileName.startsWith('automated_backup_') || fileName.startsWith('finkeep_backup_')) && fileName.endsWith('.fkdb')) {
              try {
                await file.delete();
              } catch (_) {}
            }
          }
        }
      } catch (_) {}

      // Save the backup with a fresh timestamp in its name (Option 3 format with seconds)
      final timestamp = _getFormattedTimestamp(DateTime.now());
      final newBackupFile = File('${baseDir.path}/finkeep_backup_$timestamp.fkdb');
      await newBackupFile.writeAsString(base64Payload, flush: true);

      // Update SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_auto_backup_time', DateTime.now().toIso8601String());
      await prefs.setString('last_auto_backup_path', newBackupFile.path);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Returns the file instance for the current backup.
  /// Searches for any existing backup matching `finkeep_backup_*.fkdb`. If none is found,
  /// returns a default location using the current timestamp.
  static Future<File> getBackupFile() async {
    final timestamp = _getFormattedTimestamp(DateTime.now());
    final defaultFileName = 'finkeep_backup_$timestamp.fkdb';
    
    Directory baseDir;
    if (Platform.isAndroid) {
      try {
        final publicDir = Directory('/storage/emulated/0/Download');
        if (await publicDir.exists()) {
          final testFile = File('${publicDir.path}/.test_finkeep_write');
          await testFile.writeAsString('', flush: true);
          await testFile.delete();
          baseDir = publicDir;
        } else {
          baseDir = await getApplicationDocumentsDirectory();
        }
      } catch (_) {
        baseDir = await getApplicationDocumentsDirectory();
      }
    } else {
      baseDir = await getApplicationDocumentsDirectory();
    }
    
    // Check if a backup file already exists in the directory
    try {
      final List<FileSystemEntity> files = baseDir.listSync();
      for (final file in files) {
        if (file is File) {
          final name = file.path.split('/').last;
          if (name.startsWith('finkeep_backup_') && name.endsWith('.fkdb')) {
            return file;
          }
        }
      }
    } catch (_) {}
    
    return File('${baseDir.path}/$defaultFileName');
  }

  static String _getFormattedTimestamp(DateTime dt) {
    final y = dt.year.toString();
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    return '$y$m${d}_$h$min$s';
  }

  static dynamic _deepConvertBackupDateTimes(dynamic val) {
    if (val is Map) {
      return val.map((k, v) => MapEntry(k.toString(), _deepConvertBackupDateTimes(v)));
    } else if (val is List) {
      return val.map((item) => _deepConvertBackupDateTimes(item)).toList();
    } else if (val is DateTime) {
      return val.toIso8601String();
    }
    return val;
  }
}
