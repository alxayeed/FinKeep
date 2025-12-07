enum AppEnvironment { dev, prod }

class AppConfig {
  static late final AppEnvironment environment;

  static void init({required AppEnvironment env}) {
    environment = env;
  }

  static bool get isDev => environment == AppEnvironment.dev;

  static bool get isProd => environment == AppEnvironment.prod;
}
