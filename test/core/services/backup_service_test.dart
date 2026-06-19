import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hive/hive.dart';
import 'package:spendly/core/services/backup_service.dart';
import 'package:spendly/core/services/local_db_service.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class MockLocalDbService extends Mock implements LocalDbService {}
class MockHiveBox extends Mock implements Box<Map> {}

void main() {
  late MockLocalDbService mockLocalDb;
  late MockHiveBox mockExpensesBox;
  late MockHiveBox mockInvestmentsBox;
  late MockHiveBox mockLendingsBox;
  late MockHiveBox mockPersonsBox;
  late MockHiveBox mockRepaymentsBox;
  late MockHiveBox mockBudgetsBox;
  late BackupService backupService;

  setUp(() {
    mockLocalDb = MockLocalDbService();
    mockExpensesBox = MockHiveBox();
    mockInvestmentsBox = MockHiveBox();
    mockLendingsBox = MockHiveBox();
    mockPersonsBox = MockHiveBox();
    mockRepaymentsBox = MockHiveBox();
    mockBudgetsBox = MockHiveBox();

    when(() => mockLocalDb.expensesBox).thenReturn(mockExpensesBox);
    when(() => mockLocalDb.investmentsBox).thenReturn(mockInvestmentsBox);
    when(() => mockLocalDb.lendingsBox).thenReturn(mockLendingsBox);
    when(() => mockLocalDb.personsBox).thenReturn(mockPersonsBox);
    when(() => mockLocalDb.repaymentsBox).thenReturn(mockRepaymentsBox);
    when(() => mockLocalDb.budgetsBox).thenReturn(mockBudgetsBox);

    backupService = BackupService(localDb: mockLocalDb);
  });

  group('BackupService Encryption Tests', () {
    test('should export data to encrypted bytes and decrypt successfully', () async {
      // Arrange
      final mockData = {'id': '1', 'amount': 100.0, 'date': DateTime(2026, 6, 19)};
      when(() => mockExpensesBox.values).thenReturn([mockData]);
      when(() => mockInvestmentsBox.values).thenReturn([]);
      when(() => mockLendingsBox.values).thenReturn([]);
      when(() => mockPersonsBox.values).thenReturn([]);
      when(() => mockRepaymentsBox.values).thenReturn([]);
      when(() => mockBudgetsBox.values).thenReturn([]);

      // Act
      final encryptedBytes = await backupService.exportEncryptedBackup();

      // Assert
      expect(encryptedBytes, isNotEmpty);

      // Verify that it is not plain text/JSON
      final decryptedDataRaw = utf8.decode(encryptedBytes, allowMalformed: true);
      expect(decryptedDataRaw.contains('expenses'), isFalse);

      // Decrypt using the same key/IV to verify
      final keyBytes = [
        83, 112, 101, 110, 100, 108, 121, 83, 101, 99, 117, 114, 101, 66, 97, 99,
        107, 117, 112, 75, 101, 121, 50, 48, 50, 54, 33, 64, 35, 36, 37, 94
      ];
      final ivBytes = [
        83, 112, 101, 110, 100, 108, 121, 73, 86, 73, 110, 105, 116, 50, 48, 54
      ];
      final key = encrypt.Key(Uint8List.fromList(keyBytes));
      final iv = encrypt.IV(Uint8List.fromList(ivBytes));
      final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
      final decryptedJson = encrypter.decrypt(encrypt.Encrypted(encryptedBytes), iv: iv);

      final Map<String, dynamic> data = json.decode(decryptedJson);
      expect(data['expenses'], isNotEmpty);
      expect(data['expenses'][0]['id'], '1');
    });

    test('should import encrypted bytes into Hive boxes', () async {
      // Arrange
      final backupData = {
        'version': '1.0',
        'exportedAt': DateTime.now().toIso8601String(),
        'expenses': [{'id': 'exp1', 'amount': 150.0}],
        'investments': [],
        'lendings': [],
        'persons': [],
        'repayments': [],
        'budgets': [],
      };
      
      final keyBytes = [
        83, 112, 101, 110, 100, 108, 121, 83, 101, 99, 117, 114, 101, 66, 97, 99,
        107, 117, 112, 75, 101, 121, 50, 48, 50, 54, 33, 64, 35, 36, 37, 94
      ];
      final ivBytes = [
        83, 112, 101, 110, 100, 108, 121, 73, 86, 73, 110, 105, 116, 50, 48, 54
      ];
      final key = encrypt.Key(Uint8List.fromList(keyBytes));
      final iv = encrypt.IV(Uint8List.fromList(ivBytes));
      final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
      final encrypted = encrypter.encrypt(json.encode(backupData), iv: iv);

      when(() => mockLocalDb.clearAll()).thenAnswer((_) async {});
      when(() => mockExpensesBox.put(any(), any())).thenAnswer((_) async {});

      // Act
      await backupService.importEncryptedBackup(encrypted.bytes);

      // Assert
      verify(() => mockLocalDb.clearAll()).called(1);
      verify(() => mockExpensesBox.put('exp1', {'id': 'exp1', 'amount': 150.0})).called(1);
    });
  });
}
