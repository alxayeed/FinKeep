import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter/widgets.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      final success = await BackgroundBackupService.performBackup();
      return success;
    } catch (e) {
      return false;
    }
  });
}

class BackgroundBackupService {
  // Obfuscated 32-byte key (consistent with BackupService)
  static final List<int> _keyBytes = [
    83, 112, 101, 110, 100, 108, 121, 83, 101, 99, 117, 114, 101, 66, 97, 99,
    107, 117, 112, 75, 101, 121, 50, 48, 50, 54, 33, 64, 35, 36, 37, 94
  ];

  // Obfuscated 16-byte IV (consistent with BackupService)
  static final List<int> _ivBytes = [
    83, 112, 101, 110, 100, 108, 121, 73, 86, 73, 110, 105, 116, 50, 48, 56
  ];

  /// Core backup logic designed to run safely inside background isolate or main thread
  static Future<bool> performBackup() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      
      // Initialize Hive in isolation
      Hive.init(directory.path);

      // Helper to retrieve open boxes or open new ones
      Future<Box<Map>> getBox(String name) async {
        return Hive.isBoxOpen(name) ? Hive.box<Map>(name) : await Hive.openBox<Map>(name);
      }

      // Check which boxes were already open in this isolate
      final bool expensesWasOpen = Hive.isBoxOpen('expenses');
      final bool investmentsWasOpen = Hive.isBoxOpen('investments');
      final bool lendingsWasOpen = Hive.isBoxOpen('lendings');
      final bool personsWasOpen = Hive.isBoxOpen('persons');
      final bool repaymentsWasOpen = Hive.isBoxOpen('repayments');
      final bool budgetsWasOpen = Hive.isBoxOpen('budgets');
      final bool incomeWasOpen = Hive.isBoxOpen('income');
      final bool incomeCategoriesWasOpen = Hive.isBoxOpen('income_categories');
      final bool expenseCategoriesWasOpen = Hive.isBoxOpen('expense_categories');

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
      final normalizedPayload = _deepConvertDateTimes(backupPayload);
      final jsonString = jsonEncode(normalizedPayload);

      // Perform AES Encryption
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

  static dynamic _deepConvertDateTimes(dynamic val) {
    if (val is Map) {
      return val.map((k, v) => MapEntry(k.toString(), _deepConvertDateTimes(v)));
    } else if (val is List) {
      return val.map((item) => _deepConvertDateTimes(item)).toList();
    } else if (val is DateTime) {
      return val.toIso8601String();
    }
    return val;
  }
}
