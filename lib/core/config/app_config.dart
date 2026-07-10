enum AppEnvironment { prod, personal }

class AppConfig {
  // Directly resolves standard compile-time '--dart-define=ENV=local/dev/prod/personal'
  static const String _envStr = String.fromEnvironment(
    'ENV',
    defaultValue: 'prod',
  );

  static AppEnvironment get environment {
    // log("🚀 [AppConfig DBG] Raw ENV String from compiler: '$_envStr'");
    switch (_envStr) {
      case 'prod':
        return AppEnvironment.prod;
      case 'personal':
        return AppEnvironment.personal;
      default:
        return AppEnvironment.prod;
    }
  }

  static bool get isProd => environment == AppEnvironment.prod;

  static bool get isPersonal => environment == AppEnvironment.personal;

  // Keep compatibility with older code referencing isDev/isProd or flavor
  static bool get isDevLegacy => !isProd;

  static String get flavor => isProd ? 'prod' : 'personal';

  static String get(String key, {String defaultValue = ''}) {
    if (key == 'DB_SUFFIX') {
      switch (environment) {
        case AppEnvironment.personal:
          return '_personal';
        case AppEnvironment.prod:
          return '';
      }
    }
    if (key == 'APP_ENV') {
      return _envStr;
    }
    if (key == 'FIRESTORE_SUFFIX') {
      return String.fromEnvironment(
        'FIRESTORE_SUFFIX',
        defaultValue: defaultValue,
      );
    }
    return String.fromEnvironment(key, defaultValue: defaultValue);
  }

  static bool get firestoreEnabled => isPersonal;

  // New flag: remote data source for dev and personal; local otherwise
  static bool get useRemote => environment == AppEnvironment.personal;
}
