import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../models/user_preferences_model.dart';
import '../providers/user_preferences_provider.dart';
import 'local_db_service.dart';

class PreferencesSyncService {
  static final PreferencesSyncService _instance = PreferencesSyncService._internal();
  factory PreferencesSyncService() => _instance;
  PreferencesSyncService._internal();

  final LocalDbService _localDb = LocalDbService();
  static const String _userPrefsKey = 'user_preferences_v1';

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    
    // 1. Check local Hive box first
    final hiveMap = _localDb.preferencesBox.get(_userPrefsKey);
    UserPreferencesModel? model;

    if (hiveMap != null) {
      model = UserPreferencesModel.fromJson(Map<String, dynamic>.from(hiveMap));
    } else {
      // 2. Read existing SharedPreferences to build initial model
      model = _buildFromSharedPreferences(prefs);
      await _localDb.preferencesBox.put(_userPrefsKey, model.toJson());
    }

    // Apply model settings to SharedPreferences & UserPreferencesProvider
    await _applyToApp(model, prefs);

    // 3. If in Personal Mode, subscribe to real-time remote updates from Firestore
    if (AppConfig.isPersonal) {
      _listenToRemoteChanges();
    }
  }

  UserPreferencesModel _buildFromSharedPreferences(SharedPreferences prefs) {
    return UserPreferencesModel(
      themeMode: prefs.getString('theme_mode') ?? 'system',
      language: prefs.getString('language_code') ?? 'en',
      currencyCode: prefs.getString('user_currency') ?? 'BDT',
      fiscalYearStartMonth: prefs.getInt('fiscal_year_start_month') ?? 7,
      dailyReminderEnabled: prefs.getBool('daily_reminder_enabled') ?? true,
      dailyReminderTime: prefs.getString('daily_reminder_time') ?? '20:00',
      biometricEnabled: prefs.getBool('biometric_enabled') ?? false,
      privacyModeEnabled: prefs.getBool('privacy_mode_enabled') ?? false,
      autoBackupEnabled: prefs.getBool('auto_backup_enabled') ?? true,
      updatedAt: DateTime.now(),
    );
  }

  Future<void> _applyToApp(UserPreferencesModel model, SharedPreferences prefs) async {
    await prefs.setString('theme_mode', model.themeMode);
    await prefs.setString('language_code', model.language);
    await prefs.setString('user_currency', model.currencyCode);
    await prefs.setInt('fiscal_year_start_month', model.fiscalYearStartMonth);
    await prefs.setBool('daily_reminder_enabled', model.dailyReminderEnabled);
    await prefs.setString('daily_reminder_time', model.dailyReminderTime);
    await prefs.setBool('biometric_enabled', model.biometricEnabled);
    await prefs.setBool('privacy_mode_enabled', model.privacyModeEnabled);
    await prefs.setBool('auto_backup_enabled', model.autoBackupEnabled);

    // Update single unified UserPreferencesProvider
    UserPreferencesProvider().value = model;
  }

  Future<void> updatePreferences(UserPreferencesModel updatedModel) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Save locally to Hive box
    await _localDb.preferencesBox.put(_userPrefsKey, updatedModel.toJson());

    // Apply to SharedPreferences & Provider
    await _applyToApp(updatedModel, prefs);

    // Sync to Remote Firestore if in Personal Mode
    if (AppConfig.isPersonal) {
      try {
        final firestore = FirebaseFirestore.instance;
        final colName = AppConfig.get('FIRESTORE_SUFFIX').isEmpty
            ? 'user_preferences'
            : 'user_preferences${AppConfig.get('FIRESTORE_SUFFIX')}';
        
        await firestore.collection(colName).doc('main_settings').set(
              updatedModel.toJson(),
              SetOptions(merge: true),
            );
      } catch (_) {
        // Silently handle offline/network state
      }
    }
  }

  void _listenToRemoteChanges() {
    try {
      final firestore = FirebaseFirestore.instance;
      final colName = AppConfig.get('FIRESTORE_SUFFIX').isEmpty
          ? 'user_preferences'
          : 'user_preferences${AppConfig.get('FIRESTORE_SUFFIX')}';

      firestore.collection(colName).doc('main_settings').snapshots().listen((doc) async {
        if (doc.exists && doc.data() != null) {
          final remoteModel = UserPreferencesModel.fromJson(doc.data()!);
          final hiveMap = _localDb.preferencesBox.get(_userPrefsKey);
          
          if (hiveMap != null) {
            final localModel = UserPreferencesModel.fromJson(Map<String, dynamic>.from(hiveMap));
            if (remoteModel.updatedAt.isAfter(localModel.updatedAt)) {
              await _applyToApp(remoteModel, await SharedPreferences.getInstance());
              await _localDb.preferencesBox.put(_userPrefsKey, remoteModel.toJson());
            }
          } else {
            await _applyToApp(remoteModel, await SharedPreferences.getInstance());
            await _localDb.preferencesBox.put(_userPrefsKey, remoteModel.toJson());
          }
        }
      }, onError: (_) {});
    } catch (_) {
      // Safe fallback if offline
    }
  }
}
