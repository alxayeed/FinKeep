enum AppEnvironment { local, prod, personal }

class AppConfig {
  // Directly resolves standard compile-time '--dart-define=ENV=local/prod/personal'
  static const String _envStr = String.fromEnvironment('ENV', defaultValue: 'local');

  static AppEnvironment get environment {
    switch (_envStr) {
      case 'prod':
        return AppEnvironment.prod;
      case 'personal':
        return AppEnvironment.personal;
      case 'local':
      default:
        return AppEnvironment.local;
    }
  }

  static bool get isLocal => environment == AppEnvironment.local;
  static bool get isProd => environment == AppEnvironment.prod;
  static bool get isPersonal => environment == AppEnvironment.personal;

  // Keep compatibility with older code referencing isDev/isProd or flavor
  static bool get isDev => !isProd;
  static String get flavor => isProd ? 'prod' : 'dev';

  static String get(String key, {String defaultValue = ''}) {
    if (key == 'DB_SUFFIX') {
      switch (environment) {
        case AppEnvironment.local:
          return '_local';
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
      return String.fromEnvironment('FIRESTORE_SUFFIX', defaultValue: defaultValue);
    }
    return String.fromEnvironment(key, defaultValue: defaultValue);
  }

  static bool get firestoreEnabled => isPersonal;
}
