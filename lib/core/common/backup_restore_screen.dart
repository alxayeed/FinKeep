import 'package:spendly/core/error/exception_handler.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:spendly/core/config/app_config.dart';
import 'package:spendly/core/services/local_db_service.dart';
import 'package:spendly/core/services/backup_service.dart';
import 'package:spendly/core/styles/app_colors.dart';
import 'package:spendly/core/responsive/responsive.dart';
import 'package:spendly/core/common/widgets/custom_app_bar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

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
      final defaultFileName = 'spendly_backup_$dateStr.spdb';
      
      // Open the Save File dialog and pass the bytes directly (required on Android/iOS)
      savePath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Backup File',
        fileName: defaultFileName,
        type: FileType.any,
        bytes: bytes,
      );
      
      if (savePath == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      
      final file = File(savePath);
      // Fallback: if platform didn't write bytes automatically (e.g. desktop), write manually
      if (!await file.exists() || (await file.length()) == 0) {
        await file.writeAsBytes(bytes);
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Backup saved successfully to: ${savePath.split('/').last}'),
            backgroundColor: AppColors.success,
          ),
        );
      }
      
      // Open the share sheet only after downloading/saving the file
      final xFile = XFile(file.path);
      await Share.shareXFiles([xFile], text: 'Spendly Encrypted Backup - $dateStr');
      
    } catch (e, stackTrace) {
      ExceptionHandler.handle(
        e,
        stackTrace,
        'BackupRestoreScreen._exportBackup${savePath != null ? ' (file: $savePath)' : ''}',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
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

    final envName = AppConfig.environment.name.toUpperCase();
    final isFirestore = AppConfig.firestoreEnabled;

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
                // Environment Card
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryTeal, AppColors.primaryTealLight],
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.white, size: 20.sp),
                          SizedBox(width: 8.w),
                          Text(
                            'Active Configuration Profile',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        envName,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        isFirestore
                            ? 'Cloud database (Firestore) active + Offline local cache'
                            : 'Standalone offline database mode active (Zero-Knowledge)',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

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
                _buildStatRow('Lending People', _personCount, Icons.people_outline, Colors.blue),
                _buildStatRow('Repayments', _repaymentCount, Icons.receipt_long_outlined, Colors.green),

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
