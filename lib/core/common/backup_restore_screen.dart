import 'package:spendly/core/error/exception_handler.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:spendly/core/services/local_db_service.dart';
import 'package:spendly/core/services/backup_service.dart';
import 'package:spendly/core/styles/app_colors.dart';
import 'package:spendly/core/responsive/responsive.dart';
import 'package:spendly/core/common/widgets/custom_app_bar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class BackupRestoreScreen extends StatefulWidget {
  const BackupRestoreScreen({super.key});

  @override
  State<BackupRestoreScreen> createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends State<BackupRestoreScreen> {
  final LocalDbService _localDb = LocalDbService();
  late final BackupService _backupService;

  int _expenseCount = 0;
  int _investmentCount = 0;
  int _lendingCount = 0;
  int _personCount = 0;
  int _repaymentCount = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _backupService = BackupService(localDb: _localDb);
    _loadStats();
  }

  void _loadStats() {
    setState(() {
      _expenseCount = _localDb.expensesBox.length;
      _investmentCount = _localDb.investmentsBox.length;
      _lendingCount = _localDb.lendingsBox.length;
      _personCount = _localDb.personsBox.length;
      _repaymentCount = _localDb.repaymentsBox.length;
    });
  }

  Future<void> _exportBackup() async {
    setState(() {
      _isLoading = true;
    });
    String? savePath;
    try {
      final bytes = await _backupService.exportEncryptedBackup();
      
      final dateStr = DateTime.now().toIso8601String().split('T').first;
      final fileName = 'spendly_backup_$dateStr.spdb';
      
      File? file;
      
      if (Platform.isAndroid) {
        // Check permission first
        var status = await Permission.manageExternalStorage.status;
        if (!status.isGranted) {
          if (mounted) {
            // Show explanation dialog first before requesting/redirecting to settings
            final bool? proceed = await showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (dialogCtx) {
                final isDark = Theme.of(dialogCtx).brightness == Brightness.dark;
                final textCol = isDark ? Colors.white : const Color(0xFF0F172A);
                final subtextCol = isDark ? Colors.white60 : const Color(0xFF64748B);
                
                return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                  backgroundColor: isDark ? AppColors.cardDark : Colors.white,
                  title: Row(
                    children: [
                      const Icon(Icons.folder_shared_outlined, color: AppColors.primaryTeal),
                      SizedBox(width: 8.w),
                      Text(
                        'Storage Access Required',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: textCol,
                        ),
                      ),
                    ],
                  ),
                  content: Text(
                    'To save your encrypted backup file (.spdb) directly to the public Downloads folder without leaving the app, Spendly requires "All Files Access" permission.\n\nYou will be redirected to the system settings page to enable this permission.',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 13.sp,
                      color: subtextCol,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogCtx, false),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(dialogCtx, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      ),
                      child: Text(
                        'Go to Settings',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );

            if (proceed == true) {
              status = await Permission.manageExternalStorage.request();
            } else {
              throw Exception('Storage permission request cancelled.');
            }
          }
        }

        if (!status.isGranted) {
          throw Exception('Storage permission denied. All Files Access is required to save to the public Downloads folder.');
        }
        
        final pubDownload = Directory('/storage/emulated/0/Download');
        if (!await pubDownload.exists()) {
          await pubDownload.create(recursive: true);
        }
        file = File('${pubDownload.path}/$fileName');
        await file.writeAsBytes(bytes);
      } else {
        // On iOS / other platforms, write to documents directory
        final directory = await getApplicationDocumentsDirectory();
        file = File('${directory.path}/$fileName');
        await file.writeAsBytes(bytes);
      }
      
      savePath = file.path;
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Backup downloaded to:\n$savePath'),
            duration: const Duration(seconds: 10),
            backgroundColor: AppColors.success,
            action: SnackBarAction(
              label: 'Share',
              textColor: Colors.white,
              onPressed: () async {
                final xFile = XFile(file!.path);
                await Share.shareXFiles([xFile], text: 'Spendly Encrypted Backup - $dateStr');
              },
            ),
          ),
        );
      }
      
    } catch (e, stackTrace) {
      ExceptionHandler.handle(
        e,
        stackTrace,
        'BackupRestoreScreen._exportBackup${savePath != null ? ' (file: $savePath)' : ''}',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _importBackup() async {
    setState(() {
      _isLoading = true;
    });

    String? selectedFilePath;
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result == null || result.files.single.path == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      selectedFilePath = result.files.single.path!;
      if (!selectedFilePath.endsWith('.spdb')) {
        throw Exception('Please select a valid .spdb backup file.');
      }

      final file = File(selectedFilePath);
      final bytes = await file.readAsBytes();

      await _backupService.importEncryptedBackup(bytes);
      _loadStats();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Backup imported successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e, stackTrace) {
      ExceptionHandler.handle(
        e,
        stackTrace,
        'BackupRestoreScreen._importBackup${selectedFilePath != null ? ' (file: $selectedFilePath)' : ''}',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Import failed: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildStatRow(String label, int count, IconData icon, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20.sp),
          SizedBox(width: 12.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              '$count records',
              style: TextStyle(
                fontSize: 11.sp,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDark ? Colors.white60 : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: const CustomAppBar(
        title: 'Backup & Restore',
        showBackButton: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal))
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              children: [
                // Statistics
                Text(
                  'LOCAL DATABASE STATE',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: subtitleColor,
                  ),
                ),
                SizedBox(height: 10.h),
                _buildStatRow('Expenses', _expenseCount, Icons.payment_outlined, AppColors.primaryTeal),
                _buildStatRow('Investments', _investmentCount, Icons.trending_up, Colors.orange),
                _buildStatRow('Lendings', _lendingCount, Icons.handshake_outlined, Colors.purple),

                SizedBox(height: 24.h),

                // Actions Card
                Text(
                  'EXPORT BACKUP',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: subtitleColor,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Export your database into a secure, encrypted .spdb file. You can save it to your device or share it via messages, mail, or cloud storage.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: 'Manrope',
                    color: subtitleColor,
                  ),
                ),
                SizedBox(height: 12.h),
                ElevatedButton.icon(
                  onPressed: _exportBackup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  icon: const Icon(Icons.share_outlined),
                  label: const Text(
                    'Export & Share Backup',
                    style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.bold),
                  ),
                ),

                SizedBox(height: 32.h),

                // Import Panel
                Text(
                  'IMPORT BACKUP',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: subtitleColor,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Select an encrypted .spdb backup file to restore your database. Warning: This will completely replace your current local data.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: 'Manrope',
                    color: subtitleColor,
                  ),
                ),
                SizedBox(height: 12.h),
                ElevatedButton.icon(
                  onPressed: _importBackup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                    foregroundColor: textColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  icon: const Icon(Icons.file_open_outlined),
                  label: const Text(
                    'Select & Import Backup File',
                    style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 60.h),
              ],
            ),
    );
  }
}
