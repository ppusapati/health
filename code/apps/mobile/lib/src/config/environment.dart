/// Build-time configuration.
///
/// Only non-secret values belong here. A mobile bundle is extractable, so it
/// never carries server secrets (Domain/Data spec §13.1).
library;

/// Deployment environment.
enum Environment {
  development,
  preproduction,
  production;

  static Environment fromName(String name) => switch (name) {
        'preproduction' => Environment.preproduction,
        'production' => Environment.production,
        _ => Environment.development,
      };

  /// Non-production builds show a persistent banner so nobody enters real
  /// patient data into a test system (SRS-WEB-003 applied to mobile).
  bool get showsEnvironmentBanner => this != Environment.production;
}

/// Runtime configuration, supplied at build time via --dart-define.
class AppConfig {
  const AppConfig({required this.apiBaseUrl, required this.environment});

  final String apiBaseUrl;
  final Environment environment;

  /// Reads configuration from the compile-time environment.
  factory AppConfig.fromEnvironment() {
    const baseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://localhost:8080',
    );
    const env = String.fromEnvironment(
      'ENVIRONMENT',
      defaultValue: 'development',
    );
    return AppConfig(
      apiBaseUrl: baseUrl,
      environment: Environment.fromName(env),
    );
  }
}
