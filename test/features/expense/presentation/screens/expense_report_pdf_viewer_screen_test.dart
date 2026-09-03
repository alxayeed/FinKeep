import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/features/expense/domain/entities/expense_pdf_report_config.dart';
import 'package:finkeep/features/expense/presentation/screens/expense_report_pdf_viewer_screen.dart';

void main() {
  testWidgets('ExpenseReportPdfViewerScreen renders appbar and actions',
      (WidgetTester tester) async {
    final dummyPdfBytes = Uint8List.fromList([
      0x25, 0x50, 0x44, 0x46, 0x2D, 0x31, 0x2E, 0x34
    ]);

    final config = ExpensePdfReportConfig(
      startDate: DateTime(2026, 8, 1),
      endDate: DateTime(2026, 8, 31),
      mode: ExpenseReportPdfMode.compact,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            Responsive.init(context, refHeight: 844, refWidth: 390);
            return ExpenseReportPdfViewerScreen(
              pdfBytes: dummyPdfBytes,
              config: config,
              pdfViewerBuilder: (ctx, bytes) => const Center(
                child: Text('PDF Mock Viewer Body'),
              ),
            );
          },
        ),
      ),
    );

    await tester.pump();

    // Verify Title, Mock Body and Action Icons render
    expect(find.text('Report Preview'), findsOneWidget);
    expect(find.text('PDF Mock Viewer Body'), findsOneWidget);
    expect(find.byIcon(Icons.share_rounded), findsOneWidget);
    expect(find.byIcon(Icons.download_rounded), findsOneWidget);
  });
}
