

enum AppEnvironment { local, dev, prod, personal }

class AppConfig {
  // Directly resolves standard compile-time '--dart-define=ENV=local/dev/prod/personal'
  static const String _envStr = String.fromEnvironment(
    'ENV',
    defaultValue: 'local',
  );

  static AppEnvironment get environment {
    // log("🚀 [AppConfig DBG] Raw ENV String from compiler: '$_envStr'");
    switch (_envStr) {
      case 'prod':
        return AppEnvironment.prod;
      case 'personal':
        return AppEnvironment.personal;
      case 'dev':
        return AppEnvironment.dev;
      case 'local':
      default:
        return AppEnvironment.local;
    }
  }

  static bool get isLocal => environment == AppEnvironment.local;

  static bool get isProd => environment == AppEnvironment.prod;

  static bool get isPersonal => environment == AppEnvironment.personal;

  static bool get isDev => environment == AppEnvironment.dev;

  // Keep compatibility with older code referencing isDev/isProd or flavor
  static bool get isDevLegacy => !isProd;

  static String get flavor => isProd ? 'prod' : 'dev';

  static String get(String key, {String defaultValue = ''}) {
    if (key == 'DB_SUFFIX') {
      switch (environment) {
        case AppEnvironment.local:
          return '_local';
        case AppEnvironment.dev:
          return '_dev';
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
  static bool get useRemote =>
      environment == AppEnvironment.dev ||
      environment == AppEnvironment.personal;
}
