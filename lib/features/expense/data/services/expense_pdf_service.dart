import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:finkeep/core/constants/app_strings.dart';
import 'package:finkeep/core/enums/payment_type.dart';
import 'package:finkeep/core/extensions/double_ext.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/entities/expense_pdf_report_config.dart';

class ExpensePdfService {
  Future<Uint8List> generateExpensePdf({
    required ExpensePdfReportConfig config,
    required List<ExpenseEntity> expenses,
    Uint8List? logoBytes,
    pw.Font? customBaseFont,
    pw.Font? customBoldFont,
    pw.Font? customBengaliFont,
  }) async {
    final pdf = pw.Document();

    // 1. Resolve Fonts & Fallbacks
    pw.Font? baseFont = customBaseFont;
    pw.Font? boldFont = customBoldFont;
    pw.Font? bengaliFont = customBengaliFont;
    pw.Font? bengaliBoldFont;

    // Load bundled Bengali font from assets first (works 100% offline!)
    if (bengaliFont == null) {
      try {
        final fontData = await rootBundle.load('assets/fonts/NotoSansBengali-Regular.ttf');
        bengaliFont = pw.Font.ttf(fontData.buffer.asByteData());
      } catch (_) {}
    }

    try {
      final fontData = await rootBundle.load('assets/fonts/NotoSansBengali-Bold.ttf');
      bengaliBoldFont = pw.Font.ttf(fontData.buffer.asByteData());
    } catch (_) {
      bengaliBoldFont = bengaliFont;
    }

    // Try Google Fonts for base Latin and Bengali fallback
    if (baseFont == null || boldFont == null) {
      try {
        baseFont ??= await PdfGoogleFonts.notoSansRegular();
        boldFont ??= await PdfGoogleFonts.notoSansBold();
        bengaliFont ??= await PdfGoogleFonts.notoSansBengaliRegular();
        bengaliBoldFont ??= await PdfGoogleFonts.notoSansBengaliBold();
      } catch (_) {
        baseFont ??= pw.Font.helvetica();
        boldFont ??= pw.Font.helveticaBold();
      }
    }

    final fallbackList = <pw.Font>[
      ?bengaliFont,
      if (bengaliBoldFont != null && bengaliBoldFont != bengaliFont) bengaliBoldFont,
    ];

    final baseTextStyle = pw.TextStyle(
      font: baseFont,
      fontFallback: fallbackList,
      fontSize: 9,
      color: PdfColors.grey900,
    );
    final boldTextStyle = pw.TextStyle(
      font: boldFont,
      fontFallback: fallbackList,
      fontSize: 9.5,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.grey800,
    );

    // 2. Resolve App Logo Image
    Uint8List? resolvedLogo = logoBytes;
    if (resolvedLogo == null) {
      try {
        final data = await rootBundle.load('assets/img/app_Icon.png');
        resolvedLogo = data.buffer.asUint8List();
      } catch (_) {
        resolvedLogo = null;
      }
    }

    final pw.ImageProvider? logoProvider =
        resolvedLogo != null ? pw.MemoryImage(resolvedLogo) : null;

    final dateFormat = DateFormat('dd/MM/yyyy');
    final formattedStart = dateFormat.format(config.startDate);
    final formattedEnd = dateFormat.format(config.endDate);
    final dateRangeStr = '$formattedStart - $formattedEnd';

    // 3. Filter expenses by categories if specific categories are selected
    List<ExpenseEntity> filteredExpenses = expenses;
    final effectiveCategories = config.effectiveCategories;
    if (effectiveCategories.isNotEmpty) {
      final normalizedSet =
          effectiveCategories.map((c) => c.trim().toLowerCase()).toSet();
      filteredExpenses = expenses
          .where((e) => normalizedSet.contains(e.category.trim().toLowerCase()))
          .toList();
    }

    // 4. Compute Totals
    final double totalAmount = filteredExpenses.fold(
      0.0,
      (sum, item) => sum + item.amount,
    );

    // 5. Build Page Theme with Centered Subtle Logo Watermark
    final pageTheme = pw.PageTheme(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.symmetric(horizontal: 32, vertical: 32),
      theme: pw.ThemeData.withFont(
        base: baseFont,
        bold: boldFont,
        fontFallback: fallbackList,
      ),
      buildBackground: (context) {
        if (logoProvider == null) return pw.SizedBox();
        return pw.FullPage(
          ignoreMargins: true,
          child: pw.Center(
            child: pw.Opacity(
              opacity: 0.05,
              child: pw.Image(
                logoProvider,
                width: 220,
                height: 220,
                fit: pw.BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );

    final String currencySymbol = config.currencySymbol.isNotEmpty
        ? config.currencySymbol
        : config.currencyCode;

    // 6. Add MultiPage Document
    pdf.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        header: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      if (logoProvider != null) ...[
                        pw.Container(
                          width: 28,
                          height: 28,
                          margin: const pw.EdgeInsets.only(right: 8),
                          child: pw.Image(logoProvider),
                        ),
                      ],
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Expense Report',
                            style: boldTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.blueGrey900,
                            ),
                          ),
                          pw.SizedBox(height: 2),
                          pw.Text(
                            '$dateRangeStr | ${config.mode.displayName}${effectiveCategories.isEmpty ? "" : " (${effectiveCategories.length <= 3 ? effectiveCategories.join(', ') : '${effectiveCategories.take(2).join(', ')} +${effectiveCategories.length - 2} more'})"}',
                            style: baseTextStyle.copyWith(
                              fontSize: 9.5,
                              color: PdfColors.grey700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'Total Spent',
                        style: baseTextStyle.copyWith(
                          fontSize: 8.5,
                          color: PdfColors.grey600,
                        ),
                      ),
                      pw.SizedBox(height: 1),
                      pw.Text(
                        _formatAmount(totalAmount, currencySymbol),
                        style: boldTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.teal900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Divider(thickness: 0.8, color: PdfColors.grey300),
              pw.SizedBox(height: 6),
            ],
          );
        },
        footer: (context) {
          return pw.Column(
            children: [
              pw.Divider(thickness: 0.5, color: PdfColors.grey300),
              pw.SizedBox(height: 4),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Row(
                    children: [
                      pw.Text(
                        'Generated by ',
                        style: baseTextStyle.copyWith(
                          fontSize: 8.5,
                          color: PdfColors.grey600,
                        ),
                      ),
                      pw.UrlLink(
                        destination: AppStrings.playStoreUrl,
                        child: pw.Text(
                          'FinKeep',
                          style: boldTextStyle.copyWith(
                            fontSize: 8.5,
                            color: PdfColors.teal800,
                            fontWeight: pw.FontWeight.bold,
                            decoration: pw.TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  pw.Text(
                    'Page ${context.pageNumber} of ${context.pagesCount}',
                    style: baseTextStyle.copyWith(
                      fontSize: 8.5,
                      color: PdfColors.grey600,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
        build: (context) {
          if (filteredExpenses.isEmpty) {
            return [
              pw.SizedBox(height: 40),
              pw.Center(
                child: pw.Text(
                  'No expense records found for this selection.',
                  style: baseTextStyle.copyWith(
                    fontSize: 11,
                    color: PdfColors.grey600,
                  ),
                ),
              ),
            ];
          }

          final List<pw.Widget> widgets = [];

          // 1. Optional High / Low / Average Stats
          if (config.includeHighLowAvgMetrics && filteredExpenses.isNotEmpty) {
            widgets.add(
              _buildHighLowAvgSection(
                filteredExpenses: filteredExpenses,
                currencySymbol: currencySymbol,
                baseTextStyle: baseTextStyle,
                boldTextStyle: boldTextStyle,
              ),
            );
            widgets.add(pw.SizedBox(height: 14));
          }

          // 2. Optional Category Summary Section
          if (config.includeCategorySummary) {
            widgets.add(
              _buildCategorySummarySection(
                filteredExpenses: filteredExpenses,
                totalAmount: totalAmount,
                currencySymbol: currencySymbol,
                baseTextStyle: baseTextStyle,
                boldTextStyle: boldTextStyle,
              ),
            );
            widgets.add(pw.SizedBox(height: 14));
          }

          // 3. Optional Monthly Breakdown Section
          if (config.includeMonthlyBreakdown) {
            widgets.add(
              _buildMonthlyBreakdownSection(
                filteredExpenses: filteredExpenses,
                currencySymbol: currencySymbol,
                baseTextStyle: baseTextStyle,
                boldTextStyle: boldTextStyle,
              ),
            );
            widgets.add(pw.SizedBox(height: 14));
          }

          // 4. Optional Payment Method Breakdown Section
          if (config.includePaymentMethodBreakdown) {
            widgets.add(
              _buildPaymentMethodBreakdownSection(
                filteredExpenses: filteredExpenses,
                totalAmount: totalAmount,
                currencySymbol: currencySymbol,
                baseTextStyle: baseTextStyle,
                boldTextStyle: boldTextStyle,
              ),
            );
            widgets.add(pw.SizedBox(height: 14));
          }

          // Section Title for Transactions
          widgets.add(
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  config.mode == ExpenseReportPdfMode.compact
                      ? 'Transactions Summary'
                      : 'Itemized Transactions',
                  style: boldTextStyle.copyWith(
                    fontSize: 11,
                    color: PdfColors.blueGrey900,
                  ),
                ),
                pw.Text(
                  config.mode == ExpenseReportPdfMode.compact
                      ? '${groupExpensesForCompactMode(filteredExpenses).length} grouped records'
                      : '${filteredExpenses.length} transactions',
                  style: baseTextStyle.copyWith(
                    fontSize: 8.5,
                    color: PdfColors.grey600,
                  ),
                ),
              ],
            ),
          );
          widgets.add(pw.SizedBox(height: 6));

          // 5. Main Transactions Table (Compact vs Details)
          if (config.mode == ExpenseReportPdfMode.compact) {
            widgets.add(
              _buildCompactTable(
                filteredExpenses: filteredExpenses,
                currencySymbol: currencySymbol,
                baseTextStyle: baseTextStyle,
                boldTextStyle: boldTextStyle,
              ),
            );
          } else {
            widgets.add(
              _buildDetailsTable(
                filteredExpenses: filteredExpenses,
                currencySymbol: currencySymbol,
                baseTextStyle: baseTextStyle,
                boldTextStyle: boldTextStyle,
              ),
            );
          }

          return widgets;
        },
      ),
    );

    return pdf.save();
  }

  // ==========================================
  // Helper: Format Amount with Comma Separation & Trailing Currency Symbol
  // ==========================================

  String _formatAmount(double amount, String currencySymbol) {
    final formatted = amount.toCurrency(ignorePrivacy: true);
    return currencySymbol.isNotEmpty ? '$formatted $currencySymbol' : formatted;
  }

  // ==========================================
  // Section Builders with Fallback Typography
  // ==========================================

  pw.Widget _buildHighLowAvgSection({
    required List<ExpenseEntity> filteredExpenses,
    required String currencySymbol,
    required pw.TextStyle baseTextStyle,
    required pw.TextStyle boldTextStyle,
  }) {
    double highest = 0.0;
    double lowest = double.infinity;
    double total = 0.0;

    for (final exp in filteredExpenses) {
      if (exp.amount > highest) highest = exp.amount;
      if (exp.amount < lowest) lowest = exp.amount;
      total += exp.amount;
    }
    if (lowest == double.infinity) lowest = 0.0;
    final double avg = filteredExpenses.isEmpty ? 0.0 : total / filteredExpenses.length;

    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey50,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
        border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Highest Single', _formatAmount(highest, currencySymbol), PdfColors.orange800, baseTextStyle, boldTextStyle),
          pw.Container(width: 0.5, height: 26, color: PdfColors.grey300),
          _buildStatItem('Average / Entry', _formatAmount(avg, currencySymbol), PdfColors.blue800, baseTextStyle, boldTextStyle),
          pw.Container(width: 0.5, height: 26, color: PdfColors.grey300),
          _buildStatItem('Lowest Single', _formatAmount(lowest, currencySymbol), PdfColors.green800, baseTextStyle, boldTextStyle),
        ],
      ),
    );
  }

  pw.Widget _buildStatItem(
    String title,
    String value,
    PdfColor valueColor,
    pw.TextStyle baseTextStyle,
    pw.TextStyle boldTextStyle,
  ) {
    return pw.Column(
      children: [
        pw.Text(
          title,
          style: baseTextStyle.copyWith(fontSize: 8, color: PdfColors.grey600),
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          value,
          style: boldTextStyle.copyWith(fontSize: 10.5, color: valueColor, fontWeight: pw.FontWeight.bold),
        ),
      ],
    );
  }

  pw.Widget _buildCategorySummarySection({
    required List<ExpenseEntity> filteredExpenses,
    required double totalAmount,
    required String currencySymbol,
    required pw.TextStyle baseTextStyle,
    required pw.TextStyle boldTextStyle,
  }) {
    final Map<String, double> catTotals = {};
    for (final exp in filteredExpenses) {
      catTotals[exp.category] = (catTotals[exp.category] ?? 0.0) + exp.amount;
    }
    final sortedEntries = catTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Category Summary',
          style: boldTextStyle.copyWith(fontSize: 10.5, color: PdfColors.blueGrey900),
        ),
        pw.SizedBox(height: 4),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey100),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: pw.Text('Category', style: boldTextStyle.copyWith(fontSize: 8.5)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: pw.Text('Amount', textAlign: pw.TextAlign.right, style: boldTextStyle.copyWith(fontSize: 8.5)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: pw.Text('Share %', textAlign: pw.TextAlign.right, style: boldTextStyle.copyWith(fontSize: 8.5)),
                ),
              ],
            ),
            ...sortedEntries.map((entry) {
              final pct = totalAmount > 0 ? (entry.value / totalAmount) * 100 : 0.0;
              return pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    child: pw.Text(entry.key, style: baseTextStyle.copyWith(fontSize: 8.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    child: pw.Text(
                      _formatAmount(entry.value, currencySymbol),
                      textAlign: pw.TextAlign.right,
                      style: baseTextStyle.copyWith(fontSize: 8.5),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    child: pw.Text(
                      '${pct.toStringAsFixed(1)}%',
                      textAlign: pw.TextAlign.right,
                      style: baseTextStyle.copyWith(fontSize: 8.5, color: PdfColors.grey700),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildMonthlyBreakdownSection({
    required List<ExpenseEntity> filteredExpenses,
    required String currencySymbol,
    required pw.TextStyle baseTextStyle,
    required pw.TextStyle boldTextStyle,
  }) {
    final Map<String, double> monthTotals = {};
    for (final exp in filteredExpenses) {
      final key = DateFormat('MMM yyyy').format(exp.date);
      monthTotals[key] = (monthTotals[key] ?? 0.0) + exp.amount;
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Monthly Breakdown',
          style: boldTextStyle.copyWith(fontSize: 10.5, color: PdfColors.blueGrey900),
        ),
        pw.SizedBox(height: 4),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey100),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: pw.Text('Month', style: boldTextStyle.copyWith(fontSize: 8.5)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: pw.Text('Total Spent', textAlign: pw.TextAlign.right, style: boldTextStyle.copyWith(fontSize: 8.5)),
                ),
              ],
            ),
            ...monthTotals.entries.map((entry) {
              return pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    child: pw.Text(entry.key, style: baseTextStyle.copyWith(fontSize: 8.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    child: pw.Text(
                      _formatAmount(entry.value, currencySymbol),
                      textAlign: pw.TextAlign.right,
                      style: baseTextStyle.copyWith(fontSize: 8.5),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildPaymentMethodBreakdownSection({
    required List<ExpenseEntity> filteredExpenses,
    required double totalAmount,
    required String currencySymbol,
    required pw.TextStyle baseTextStyle,
    required pw.TextStyle boldTextStyle,
  }) {
    final Map<String, double> methodTotals = {};
    for (final exp in filteredExpenses) {
      final method = exp.paymentMethod.displayName;
      methodTotals[method] = (methodTotals[method] ?? 0.0) + exp.amount;
    }

    final sortedEntries = methodTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'By Payment Method',
          style: boldTextStyle.copyWith(fontSize: 10.5, color: PdfColors.blueGrey900),
        ),
        pw.SizedBox(height: 4),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey100),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: pw.Text('Payment Method', style: boldTextStyle.copyWith(fontSize: 8.5)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: pw.Text('Amount', textAlign: pw.TextAlign.right, style: boldTextStyle.copyWith(fontSize: 8.5)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: pw.Text('Share %', textAlign: pw.TextAlign.right, style: boldTextStyle.copyWith(fontSize: 8.5)),
                ),
              ],
            ),
            ...sortedEntries.map((entry) {
              final pct = totalAmount > 0 ? (entry.value / totalAmount) * 100 : 0.0;
              return pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    child: pw.Text(entry.key, style: baseTextStyle.copyWith(fontSize: 8.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    child: pw.Text(
                      _formatAmount(entry.value, currencySymbol),
                      textAlign: pw.TextAlign.right,
                      style: baseTextStyle.copyWith(fontSize: 8.5),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    child: pw.Text(
                      '${pct.toStringAsFixed(1)}%',
                      textAlign: pw.TextAlign.right,
                      style: baseTextStyle.copyWith(fontSize: 8.5, color: PdfColors.grey700),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildCompactTable({
    required List<ExpenseEntity> filteredExpenses,
    required String currencySymbol,
    required pw.TextStyle baseTextStyle,
    required pw.TextStyle boldTextStyle,
  }) {
    final groupedRows = groupExpensesForCompactMode(filteredExpenses);
    final rowDateFormat = DateFormat('dd/MM/yyyy');

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(2.2),
        1: const pw.FlexColumnWidth(3.8),
        2: const pw.FlexColumnWidth(2.5),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey100),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
              child: pw.Text('Date', style: boldTextStyle.copyWith(fontSize: 8.5)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
              child: pw.Text('Category', style: boldTextStyle.copyWith(fontSize: 8.5)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
              child: pw.Text('Total Amount', textAlign: pw.TextAlign.right, style: boldTextStyle.copyWith(fontSize: 8.5)),
            ),
          ],
        ),
        ...groupedRows.asMap().entries.map((entry) {
          final index = entry.key;
          final row = entry.value;
          final isEven = index % 2 == 0;

          return pw.TableRow(
            decoration: pw.BoxDecoration(
              color: isEven ? PdfColors.white : PdfColors.grey50,
            ),
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: pw.Text(
                  rowDateFormat.format(row.date),
                  style: baseTextStyle.copyWith(fontSize: 8.5),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: pw.Text(
                  row.category,
                  style: baseTextStyle.copyWith(fontSize: 8.5),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: pw.Text(
                  _formatAmount(row.totalAmount, currencySymbol),
                  textAlign: pw.TextAlign.right,
                  style: boldTextStyle.copyWith(
                    fontSize: 8.5,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey900,
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  pw.Widget _buildDetailsTable({
    required List<ExpenseEntity> filteredExpenses,
    required String currencySymbol,
    required pw.TextStyle baseTextStyle,
    required pw.TextStyle boldTextStyle,
  }) {
    final rowDateFormat = DateFormat('dd/MM/yyyy');

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(2.0),
        1: const pw.FlexColumnWidth(2.5),
        2: const pw.FlexColumnWidth(2.2),
        3: const pw.FlexColumnWidth(3.0),
        4: const pw.FlexColumnWidth(2.2),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey100),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
              child: pw.Text('Date', style: boldTextStyle.copyWith(fontSize: 8.5)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
              child: pw.Text('Category', style: boldTextStyle.copyWith(fontSize: 8.5)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
              child: pw.Text('Payment', style: boldTextStyle.copyWith(fontSize: 8.5)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
              child: pw.Text('Note', style: boldTextStyle.copyWith(fontSize: 8.5)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
              child: pw.Text('Amount', textAlign: pw.TextAlign.right, style: boldTextStyle.copyWith(fontSize: 8.5)),
            ),
          ],
        ),
        ...filteredExpenses.asMap().entries.map((entry) {
          final index = entry.key;
          final exp = entry.value;
          final isEven = index % 2 == 0;

          return pw.TableRow(
            decoration: pw.BoxDecoration(
              color: isEven ? PdfColors.white : PdfColors.grey50,
            ),
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: pw.Text(
                  rowDateFormat.format(exp.date),
                  style: baseTextStyle.copyWith(fontSize: 8.5),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: pw.Text(
                  exp.category,
                  style: baseTextStyle.copyWith(fontSize: 8.5),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: pw.Text(
                  exp.paymentMethod.displayName,
                  style: baseTextStyle.copyWith(fontSize: 8.5),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: pw.Text(
                  exp.description.isNotEmpty ? exp.description : '-',
                  style: baseTextStyle.copyWith(
                    fontSize: 8.5,
                    color: exp.description.isNotEmpty
                        ? PdfColors.grey900
                        : PdfColors.grey500,
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: pw.Text(
                  _formatAmount(exp.amount, currencySymbol),
                  textAlign: pw.TextAlign.right,
                  style: boldTextStyle.copyWith(
                    fontSize: 8.5,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey900,
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
