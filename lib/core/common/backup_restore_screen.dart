import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:finkeep/core/common/widgets/custom_app_bar.dart';
import 'package:finkeep/core/error/exception_handler.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/services/backup_service.dart';
import 'package:finkeep/core/services/local_db_service.dart';
import 'package:finkeep/core/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:finkeep/core/common/widgets/app_switch_button.dart';
import 'package:finkeep/core/services/background_backup_service.dart';
import 'package:share_plus/share_plus.dart';

import '../config/app_config.dart';

class BackupRestoreScreen extends StatefulWidget {
  const BackupRestoreScreen({super.key});

  @override
  State<BackupRestoreScreen> createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends State<BackupRestoreScreen> {
  final LocalDbService _localDb = LocalDbService();
  late final BackupService _backupService;

  bool _isLoading = false;
  String _loadingText = '';

  bool _autoBackupEnabled = true;
  String _lastAutoBackupTimeStr = 'Never';
  String _lastAutoBackupPathStr = 'None';

  @override
  void initState() {
    super.initState();
    _backupService = BackupService(localDb: _localDb);
    _loadAutoBackupConfig();
  }

  Future<void> _loadAutoBackupConfig() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _autoBackupEnabled = prefs.getBool('auto_backup_enabled') ?? true;
      final lastTime = prefs.getString('last_auto_backup_time');
      if (lastTime != null) {
        try {
          final dt = DateTime.parse(lastTime);
          _lastAutoBackupTimeStr = '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
        } catch (_) {
          _lastAutoBackupTimeStr = lastTime;
        }
      } else {
        _lastAutoBackupTimeStr = 'Never';
      }
      _lastAutoBackupPathStr = prefs.getString('last_auto_backup_path') ?? 'None';
    });
  }

  Future<void> _toggleAutoBackup(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_backup_enabled', enabled);
    setState(() {
      _autoBackupEnabled = enabled;
    });

    if (enabled) {
      await Workmanager().initialize(
        callbackDispatcher,
      );
      await Workmanager().registerPeriodicTask(
        'finkeep_daily_backup',
        'finkeep_daily_backup_task',
        frequency: const Duration(hours: 24),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
        constraints: Constraints(
          networkType: NetworkType.notRequired,
          requiresBatteryNotLow: true,
          requiresCharging: false,
          requiresDeviceIdle: false,
          requiresStorageNotLow: false,
        ),
      );
    } else {
      await Workmanager().cancelByUniqueName('finkeep_daily_backup');
    }
  }



  Future<void> _exportBackup() async {
    setState(() {
      _isLoading = true;
      _loadingText = 'Generating backup...';
    });
    try {
      final success = await BackgroundBackupService.performBackup();
      if (success) {
        await _loadAutoBackupConfig();
        final backupFile = await BackgroundBackupService.getBackupFile();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Backup saved successfully to:\n${backupFile.path}'),
              backgroundColor: AppColors.success,
            ),
          );

          // Prompt the user to share or save the file outside the sandbox
          await Share.shareXFiles(
            [XFile(backupFile.path)],
            subject: 'FinKeep Backup',
          );
        }
      } else {
        throw Exception('Failed to generate backup.');
      }
    } catch (e, stackTrace) {
      ExceptionHandler.handle(
        e,
        stackTrace,
        'BackupRestoreScreen._exportBackup',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Export failed: ${e.toString().replaceAll('Exception: ', '')}',
            ),
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
      _loadingText = 'Preparing import...';
    });

    String? selectedFilePath;
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.any);

      if (result == null || result.files.single.path == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      selectedFilePath = result.files.single.path!;
      if (!selectedFilePath.endsWith('.spdb') && !selectedFilePath.endsWith('.fkdb')) {
        throw Exception('Please select a valid .spdb or .fkdb backup file.');
      }

      final file = File(selectedFilePath);
      final bytes = await file.readAsBytes();

      setState(() {
        _loadingText = 'Decrypting backup...';
      });
      await _backupService.importEncryptedBackup(
        bytes,
        onProgress: (progress) {
          setState(() {
            _loadingText = progress;
          });
        },
      );
      _loadAutoBackupConfig();
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
            content: Text(
              'Import failed: ${e.toString().replaceAll('Exception: ', '')}',
            ),
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
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: AppColors.primaryTeal),
                  SizedBox(height: 16.h),
                  Text(
                     _loadingText,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : const Color(0xFF64748B),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              children: [
                  // Auto Backup Settings Card
                  Text(
                    'AUTOMATED BACKUP SETTINGS',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: subtitleColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Daily Auto Backup',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Silently back up your data every 24 hours',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontFamily: 'Manrope',
                                  color: subtitleColor,
                                ),
                              ),
                            ],
                          ),
                         ),
                        AppSwitchButton(
                          value: _autoBackupEnabled,
                          onChanged: _toggleAutoBackup,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  
                  // Last Backup Info Card
                  if (_autoBackupEnabled) ...[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.history, color: AppColors.primaryTeal, size: 16.sp),
                              SizedBox(width: 8.w),
                              Text(
                                'Last Backup: $_lastAutoBackupTimeStr',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Location:',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.bold,
                              color: subtitleColor,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          SelectableText(
                            _lastAutoBackupPathStr,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontFamily: 'Courier',
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],

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
                  'Export your database into a secure, encrypted .fkdb file. You can save it to your device or share it via messages, mail, or cloud storage.',
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
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                    ),
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
                  AppConfig.isPersonal
                      ? 'Select an encrypted .spdb or .fkdb backup file to merge with your cloud database. Existing records will be updated and new records will be added.'
                      : 'Select an encrypted .spdb or .fkdb backup file to restore your database. This will merge the backup items with your current local data.',
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
                    backgroundColor: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFE2E8F0),
                    foregroundColor: textColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  icon: const Icon(Icons.file_open_outlined),
                  label: const Text(
                    'Select & Import Backup File',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 32.h),

                // Mock Data Panel
                // Text(
                //   'MOCK DATA UTILITY',
                //   style: TextStyle(
                //     fontSize: 11.sp,
                //     fontFamily: 'Manrope',
                //     fontWeight: FontWeight.bold,
                //     letterSpacing: 1.2,
                //     color: subtitleColor,
                //   ),
                // ),
                // SizedBox(height: 8.h),
                // Text(
                //   'Populate the database with a preset list of realistic expenses, investments, lendings, and budgets. Ideal for store screenshots or UI validation. Note: This will overwrite current local data.',
                //   style: TextStyle(
                //     fontSize: 12.sp,
                //     fontFamily: 'Manrope',
                //     color: subtitleColor,
                //   ),
                // ),
                // SizedBox(height: 12.h),
                // ElevatedButton.icon(
                //   onPressed: _populateMockData,
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.amber.shade700,
                //     foregroundColor: Colors.white,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(16.r),
                //     ),
                //     padding: EdgeInsets.symmetric(vertical: 14.h),
                //   ),
                //   icon: const Icon(Icons.analytics_outlined),
                //   label: const Text(
                //     'Populate Realistic Mock Data',
                //     style: TextStyle(
                //       fontFamily: 'Manrope',
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                SizedBox(height: 60.h),
              ],
            ),
    );
  }
}
