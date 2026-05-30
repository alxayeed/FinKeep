enum AppEnvironment { dev, prod }

class AppConfig {
  // Directly resolves standard compile-time '--dart-define=FLAVOR=prod' or '--dart-define=FLAVOR=dev'
  static const String flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  static bool get isProd => flavor == 'prod';

  static AppEnvironment get environment => isProd ? AppEnvironment.prod : AppEnvironment.dev;

  static bool get isDev => !isProd;

  static String get(String key, {String defaultValue = ''}) {
    if (key == 'DB_SUFFIX') {
      return isProd ? '' : '_dev';
    }
    return String.fromEnvironment(key, defaultValue: defaultValue);
  }
}
