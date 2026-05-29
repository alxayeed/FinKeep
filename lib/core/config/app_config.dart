enum AppEnvironment { dev, prod }

class AppConfig {
  // Directly resolves to true when '--dart-define=prod=true' or '--dart-define=prod' is provided
  static const bool isProd = bool.fromEnvironment('prod', defaultValue: false);

  static AppEnvironment get environment => isProd ? AppEnvironment.prod : AppEnvironment.dev;

  static bool get isDev => !isProd;

  static String get(String key, {String defaultValue = ''}) {
    if (key == 'DB_SUFFIX') {
      return isProd ? '' : '_dev';
    }
    return String.fromEnvironment(key, defaultValue: defaultValue);
  }
}
