import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:finkeep/core/enums/payment_type.dart';
import 'package:finkeep/features/expense/data/services/expense_pdf_service.dart';
import 'package:finkeep/features/expense/domain/entities/expense_entity.dart';
import 'package:finkeep/features/expense/domain/entities/expense_pdf_report_config.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ExpensePdfService Tests', () {
    late ExpensePdfService service;

    final dummyPngBytes = Uint8List.fromList([
      0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
      0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
      0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
      0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
      0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
      0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82
    ]);

    final sampleExpenses = [
      ExpenseEntity(
        id: '1',
        amount: 3850.0,
        category: 'Food',
        date: DateTime(2026, 8, 28),
        description: 'Agora grocery',
        paymentMethod: PaymentType.card,
      ),
      ExpenseEntity(
        id: '2',
        amount: 500.0,
        category: 'Food',
        date: DateTime(2026, 8, 28),
        description: 'Snacks',
        paymentMethod: PaymentType.cash,
      ),
      ExpenseEntity(
        id: '3',
        amount: 4500.0,
        category: 'Utilities',
        date: DateTime(2026, 8, 27),
        description: 'Electricity',
        paymentMethod: PaymentType.mfs,
      ),
      ExpenseEntity(
        id: '4',
        amount: 8000.0,
        category: 'Family',
        date: DateTime(2026, 7, 15),
        description: 'Home repair',
        paymentMethod: PaymentType.transfer,
      ),
    ];

    setUp(() {
      service = ExpensePdfService();
    });

    test('generateExpensePdf in Compact mode returns valid PDF bytes', () async {
      final config = ExpensePdfReportConfig(
        startDate: DateTime(2026, 7, 1),
        endDate: DateTime(2026, 8, 31),
        mode: ExpenseReportPdfMode.compact,
        currencySymbol: '৳',
        currencyCode: 'BDT',
      );

      final bytes = await service.generateExpensePdf(
        config: config,
        expenses: sampleExpenses,
        logoBytes: dummyPngBytes,
      );

      expect(bytes, isNotEmpty);
      final header = String.fromCharCodes(bytes.take(4));
      expect(header, '%PDF');
    });

    test('generateExpensePdf with all optional breakdown sections toggled on', () async {
      final config = ExpensePdfReportConfig(
        startDate: DateTime(2026, 7, 1),
        endDate: DateTime(2026, 8, 31),
        mode: ExpenseReportPdfMode.details,
        includeCategorySummary: true,
        includeMonthlyBreakdown: true,
        includePaymentMethodBreakdown: true,
        includeHighLowAvgMetrics: true,
        currencySymbol: '৳',
        currencyCode: 'BDT',
      );

      final bytes = await service.generateExpensePdf(
        config: config,
        expenses: sampleExpenses,
        logoBytes: dummyPngBytes,
      );

      expect(bytes, isNotEmpty);
      final header = String.fromCharCodes(bytes.take(4));
      expect(header, '%PDF');
    });

    test('generateExpensePdf with specific category filter', () async {
      final config = ExpensePdfReportConfig(
        startDate: DateTime(2026, 7, 1),
        endDate: DateTime(2026, 8, 31),
        selectedCategory: 'Food',
        mode: ExpenseReportPdfMode.compact,
        includeHighLowAvgMetrics: true,
        includeCategorySummary: true,
      );

      final bytes = await service.generateExpensePdf(
        config: config,
        expenses: sampleExpenses,
        logoBytes: dummyPngBytes,
      );

      expect(bytes, isNotEmpty);
    });

    test('generateExpensePdf handles empty expense list without crashing', () async {
      final config = ExpensePdfReportConfig(
        startDate: DateTime(2026, 8, 1),
        endDate: DateTime(2026, 8, 31),
        mode: ExpenseReportPdfMode.compact,
        includeCategorySummary: true,
        includeHighLowAvgMetrics: true,
      );

      final bytes = await service.generateExpensePdf(
        config: config,
        expenses: [],
        logoBytes: dummyPngBytes,
      );

      expect(bytes, isNotEmpty);
    });
  });
}
