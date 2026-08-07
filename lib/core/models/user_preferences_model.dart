class UserPreferencesModel {
  final String themeMode;
  final String language;
  final String currencyCode;
  final int fiscalYearStartMonth;
  final bool dailyReminderEnabled;
  final String dailyReminderTime;
  final bool biometricEnabled;
  final bool autoBackupEnabled;
  final DateTime updatedAt;

  UserPreferencesModel({
    required this.themeMode,
    required this.language,
    required this.currencyCode,
    required this.fiscalYearStartMonth,
    required this.dailyReminderEnabled,
    required this.dailyReminderTime,
    required this.biometricEnabled,
    required this.autoBackupEnabled,
    required this.updatedAt,
  });

  factory UserPreferencesModel.defaultValues() {
    return UserPreferencesModel(
      themeMode: 'system',
      language: 'en',
      currencyCode: 'BDT',
      fiscalYearStartMonth: 7,
      dailyReminderEnabled: true,
      dailyReminderTime: '20:00',
      biometricEnabled: false,
      autoBackupEnabled: true,
      updatedAt: DateTime.now(),
    );
  }

  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) {
    return UserPreferencesModel(
      themeMode: json['themeMode'] as String? ?? 'system',
      language: json['language'] as String? ?? 'en',
      currencyCode: json['currencyCode'] as String? ?? 'BDT',
      fiscalYearStartMonth: json['fiscalYearStartMonth'] as int? ?? 7,
      dailyReminderEnabled: json['dailyReminderEnabled'] as bool? ?? true,
      dailyReminderTime: json['dailyReminderTime'] as String? ?? '20:00',
      biometricEnabled: json['biometricEnabled'] as bool? ?? false,
      autoBackupEnabled: json['autoBackupEnabled'] as bool? ?? true,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode,
      'language': language,
      'currencyCode': currencyCode,
      'fiscalYearStartMonth': fiscalYearStartMonth,
      'dailyReminderEnabled': dailyReminderEnabled,
      'dailyReminderTime': dailyReminderTime,
      'biometricEnabled': biometricEnabled,
      'autoBackupEnabled': autoBackupEnabled,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  UserPreferencesModel copyWith({
    String? themeMode,
    String? language,
    String? currencyCode,
    int? fiscalYearStartMonth,
    bool? dailyReminderEnabled,
    String? dailyReminderTime,
    bool? biometricEnabled,
    bool? autoBackupEnabled,
    DateTime? updatedAt,
  }) {
    return UserPreferencesModel(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      currencyCode: currencyCode ?? this.currencyCode,
      fiscalYearStartMonth: fiscalYearStartMonth ?? this.fiscalYearStartMonth,
      dailyReminderEnabled: dailyReminderEnabled ?? this.dailyReminderEnabled,
      dailyReminderTime: dailyReminderTime ?? this.dailyReminderTime,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      autoBackupEnabled: autoBackupEnabled ?? this.autoBackupEnabled,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
