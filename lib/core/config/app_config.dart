class AppConfig {
  static final _googleConfig = _GoogleConfig(
    clientIdAndroid: const String.fromEnvironment('GOOGLE_CLIENT_ID_AND'),
    clientIdIos: const String.fromEnvironment('GOOGLE_CLIENT_ID_IOS'),
  );

  static final _appleConfig = _AppleConfig(
    clientId: const String.fromEnvironment('APPLE_CLIENT_ID'),
    redirectUri: const String.fromEnvironment('APPLE_REDIRECT_URI'),
  );

  static final _twitterConfig = _TwitterConfig(
    apiKey: const String.fromEnvironment('TWITTER_API_KEY'),
    apiSecret: const String.fromEnvironment('TWITTER_API_SECRET'),
    redirectUri: const String.fromEnvironment('TWITTER_REDIRECT_URI'),
  );

  static final _azureConfig = _AzureConfig(
    tenantId: const String.fromEnvironment('AZURE_TENANT_ID'),
    tenantName: const String.fromEnvironment('AZURE_TENANT_NAME'),
    clientId: const String.fromEnvironment('AZURE_CLIENT_ID'),
    policyName: const String.fromEnvironment('AZURE_POLICY_NAME'),
    redirectScheme: const String.fromEnvironment('AZURE_REDIRECT_SCHEME'),
    redirectPath: const String.fromEnvironment('AZURE_REDIRECT_PATH'),
  );

  static final _auth0Config = _Auth0Config(
    domain: const String.fromEnvironment('AUTH0_DOMAIN'),
    clientId: const String.fromEnvironment('AUTH0_CLIENT_ID'),
    scheme: const String.fromEnvironment('AUTH0_SCHEME_AND'),
  );

  _GoogleConfig get googleConfig => _googleConfig;

  _AppleConfig get appleConfig => _appleConfig;

  _TwitterConfig get twitterConfig => _twitterConfig;

  _AzureConfig get azureConfig => _azureConfig;

  _Auth0Config get auth0Config => _auth0Config;
}

class _GoogleConfig {
  _GoogleConfig({required this.clientIdAndroid, required this.clientIdIos});

  final String clientIdAndroid;
  final String clientIdIos;
}

class _AppleConfig {
  _AppleConfig({required this.clientId, required this.redirectUri});

  final String clientId;
  final String redirectUri;
}

class _TwitterConfig {
  _TwitterConfig({
    required this.apiKey,
    required this.apiSecret,
    required this.redirectUri,
  });

  final String apiKey;
  final String apiSecret;
  final String redirectUri;
}

class _AzureConfig {
  _AzureConfig({
    required this.tenantId,
    required this.tenantName,
    required this.clientId,
    required this.policyName,
    required this.redirectScheme,
    required this.redirectPath,
  });

  final String tenantId;
  final String tenantName;
  final String clientId;
  final String policyName;
  final String redirectScheme;
  final String redirectPath;
}

class _Auth0Config {
  _Auth0Config({required this.domain, required this.clientId, this.scheme});

  final String domain;
  final String clientId;
  final String? scheme;
}
