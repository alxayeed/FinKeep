import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:finkeep/core/common/widgets/app_toast.dart';
import 'package:finkeep/core/common/widgets/custom_app_bar.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/styles/app_colors.dart';
import '../../domain/entities/expense_pdf_report_config.dart';

class ExpenseReportPdfViewerScreen extends StatefulWidget {
  final Uint8List pdfBytes;
  final ExpensePdfReportConfig config;
  final Widget Function(BuildContext, Uint8List)? pdfViewerBuilder;
  final Future<void> Function(String filePath)? fileOpener;
  final Future<Directory?> Function()? targetDirectoryProvider;
  final Future<void> Function(File file, Uint8List bytes)? fileSaver;

  const ExpenseReportPdfViewerScreen({
    super.key,
    required this.pdfBytes,
    required this.config,
    this.pdfViewerBuilder,
    this.fileOpener,
    this.targetDirectoryProvider,
    this.fileSaver,
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
        AppToast.showError(context, message: 'Failed to share PDF: $e');
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
      if (widget.targetDirectoryProvider != null) {
        targetDir = await widget.targetDirectoryProvider!();
      } else {
        try {
          if (Platform.isAndroid) {
            final downloadDir = Directory('/storage/emulated/0/Download');
            if (await downloadDir.exists()) {
              targetDir = downloadDir;
            } else {
              targetDir = await getExternalStorageDirectory();
            }
          } else {
            targetDir = await getApplicationDocumentsDirectory();
          }
        } catch (_) {
          targetDir = Directory.systemTemp;
        }
      }

      targetDir ??= Directory.systemTemp;

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final savedFile = File(
        '${targetDir.path}/FinKeep_Expense_Report_$timestamp.pdf',
      );
      if (widget.fileSaver != null) {
        await widget.fileSaver!(savedFile, widget.pdfBytes);
      } else {
        await savedFile.writeAsBytes(widget.pdfBytes);
      }

      if (mounted) {
        AppToast.showSuccess(
          context,
          message: 'Download successful',
          actionLabel: 'View',
          onAction: () async {
            try {
              if (widget.fileOpener != null) {
                await widget.fileOpener!(savedFile.path);
              } else {
                await OpenFilex.open(savedFile.path);
              }
            } catch (_) {}
          },
        );
      }
    } catch (e) {
      if (mounted) {
        AppToast.showError(context, message: 'Failed to save PDF: $e');
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
