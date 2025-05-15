enum Environment { dev, staging, prod }

class AppConfig {
  final String apiBaseUrl;
  final Environment environment;
  final bool enableLogging;

  static late AppConfig _instance;

  factory AppConfig({
    required String apiBaseUrl,
    required Environment environment,
    required bool enableLogging,
  }) {
    _instance = AppConfig._internal(
      apiBaseUrl: apiBaseUrl,
      environment: environment,
      enableLogging: enableLogging,
    );
    return _instance;
  }

  AppConfig._internal({
    required this.apiBaseUrl,
    required this.environment,
    required this.enableLogging,
  });

  static AppConfig get instance => _instance;

  static bool get isProduction => _instance.environment == Environment.prod;
  static bool get isDevelopment => _instance.environment == Environment.dev;
  static bool get isStaging => _instance.environment == Environment.staging;
}