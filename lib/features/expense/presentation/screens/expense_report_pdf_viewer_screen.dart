import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:finkeep/core/common/widgets/custom_app_bar.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/styles/app_colors.dart';
import '../../domain/entities/expense_pdf_report_config.dart';

class ExpenseReportPdfViewerScreen extends StatefulWidget {
  final Uint8List pdfBytes;
  final ExpensePdfReportConfig config;
  final Widget Function(BuildContext, Uint8List)? pdfViewerBuilder;

  const ExpenseReportPdfViewerScreen({
    super.key,
    required this.pdfBytes,
    required this.config,
    this.pdfViewerBuilder,
  });

  @override
  State<ExpenseReportPdfViewerScreen> createState() =>
      _ExpenseReportPdfViewerScreenState();
}

class _ExpenseReportPdfViewerScreenState
    extends State<ExpenseReportPdfViewerScreen> {
  bool _isSharing = false;
  bool _isSaving = false;

  Future<void> _handleShare() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);
    try {
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${tempDir.path}/FinKeep_Expense_Report_$timestamp.pdf');
      await file.writeAsBytes(widget.pdfBytes);

      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'application/pdf')],
        text: 'FinKeep Expense Report (${widget.config.mode.displayName})',
        subject: 'FinKeep Expense Report',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share PDF: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  Future<void> _handleSave() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    try {
      Directory? targetDir;
      if (Platform.isAndroid) {
        targetDir = Directory('/storage/emulated/0/Download');
        if (!await targetDir.exists()) {
          targetDir = await getExternalStorageDirectory();
        }
      } else {
        targetDir = await getApplicationDocumentsDirectory();
      }

      targetDir ??= await getApplicationDocumentsDirectory();

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final savedFile = File(
        '${targetDir.path}/FinKeep_Expense_Report_$timestamp.pdf',
      );
      await savedFile.writeAsBytes(widget.pdfBytes);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved to ${savedFile.path}'),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save PDF: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: CustomAppBar(
        title: 'Report Preview',
        showBackButton: true,
        showPrivacyToggle: false,
        actions: [
          IconButton(
            tooltip: 'Share PDF',
            icon: _isSharing
                ? SizedBox(
                    width: 18.r,
                    height: 18.r,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(
                    Icons.share_rounded,
                    size: 20.sp,
                    color: AppColors.primaryTeal,
                  ),
            onPressed: _handleShare,
          ),
          IconButton(
            tooltip: 'Save PDF',
            icon: _isSaving
                ? SizedBox(
                    width: 18.r,
                    height: 18.r,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(
                    Icons.download_rounded,
                    size: 22.sp,
                    color: isDark ? Colors.white70 : const Color(0xFF475569),
                  ),
            onPressed: _handleSave,
          ),
          SizedBox(width: 4.w),
        ],
      ),
      body: widget.pdfViewerBuilder != null
          ? widget.pdfViewerBuilder!(context, widget.pdfBytes)
          : SfPdfViewer.memory(
              widget.pdfBytes,
              canShowScrollHead: true,
              canShowScrollStatus: true,
              enableDoubleTapZooming: true,
            ),
    );
  }
}
