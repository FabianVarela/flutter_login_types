# Flutter Login Types

Flutter application showcasing different authentication methods using Riverpod for state management and dependency injection.

## Prerequisites

Before getting started, make sure you have the following installed:

- **Flutter SDK**: >=3.10.0 <4.0.0
- **Dart SDK**: >=3.10.0 <4.0.0
- **IDE**: VSCode or Android Studio with Flutter extensions
- **Platforms**:
  - For iOS: Xcode (macOS only)
  - For Android: Android Studio or Android SDK

## Initial Setup

### 1. Clone the repository

```bash
git clone <repository-url>
cd flutter_login_types
```

### 2. Install dependencies

```bash
flutter pub get
```

### 5. Configure third-party authentication

This project supports multiple third-party authentication providers. You need to configure each one you plan to use.

#### Create configuration file

Create a `config-keys.json` file in the project's root directory with the following structure:

```json
{
  "GOOGLE_CLIENT_ID_AND": "<YOUR_GOOGLE_CLIENT_ID_AND>",
  "GOOGLE_CLIENT_ID_IOS": "<YOUR_GOOGLE_CLIENT_ID_IOS>",
  "GOOGLE_CLIENT_ID_IOS_REV": "<YOUR_GOOGLE_CLIENT_ID_IOS_IN_REVERSE>",
  "APPLE_CLIENT_ID": "<YOUR_APPLE_CLIENT_ID>",
  "APPLE_REDIRECT_URI": "<YOUR_APPLE_REDIRECT_URI>",
  "FACEBOOK_APP_ID": "<YOUR_FACEBOOK_APP_ID>",
  "FACEBOOK_CLIENT_TOKEN": "<YOUR_FACEBOOK_CLIENT_TOKEN>",
  "FACEBOOK_DISPLAY_NAME": "<YOUR_FACEBOOK_DISPLAY_NAME>",
  "TWITTER_API_KEY": "<YOUR_TWITTER_API_KEY>",
  "TWITTER_API_SECRET": "<YOUR_TWITTER_API_SECRET>",
  "TWITTER_REDIRECT_URI": "<YOUR_TWITTER_REDIRECT_URI>",
  "AZURE_TENANT_NAME": "<YOUR_AZURE_TENANT_NAME>",
  "AZURE_TENANT_ID": "<YOUR_AZURE_TENANT_ID>",
  "AZURE_POLICY_NAME": "<YOUR_AZURE_POLICY_NAME>",
  "AZURE_CLIENT_ID": "<YOUR_AZURE_CLIENT_ID>",
  "AZURE_REDIRECT_SCHEME": "<YOUR_AZURE_REDIRECT_SCHEME>",
  "AZURE_REDIRECT_PATH": "<YOUR_AZURE_REDIRECT_PATH>",
  "AZURE_ENDPOINT_URL": "<YOUR_AZURE_ENDPOINT_URL>",
  "AUTH0_DOMAIN": "<YOUR_AUTH0_DOMAIN>",
  "AUTH0_CLIENT_ID": "<YOUR_AUTH0_CLIENT_ID>",
  "AUTH0_SCHEME_AND": "<YOUR_AUTH0_SCHEME_AND>"
}
```

**Important**: Add `config-keys.json` to `.gitignore` to avoid committing sensitive credentials.

### 5. Generate localization files

The project supports multiple languages. Generate the localization files:

```bash
flutter gen-l10n
```

Translation files are located at:
- `lib/l10n/arb/` directory

## Development

### Run the application

```bash
# Run with dart-define configuration
flutter run --dart-define-from-file=config-keys.json
```

### Run on specific platform

```bash
# iOS
flutter run --dart-define-from-file=config-keys.json -d iPhone

# Android
flutter run --dart-define-from-file=config-keys.json -d android
```

### Build for production

```bash
# iOS
flutter build ios --dart-define-from-file=config-keys.json

# Android (App Bundle)
flutter build appbundle --dart-define-from-file=config-keys.json

# Android (APK)
flutter build apk --dart-define-from-file=config-keys.json
```

## Project Structure

```
lib/
├── l10n/                    # Localization files
│   ├── arb/                # .arb files for translations
│   └── gen/                # Generated localization files
├── core/                   # Core application infrastructure
│   ├── client/            # HTTP client configuration
│   ├── config/            # App configuration
│   ├── dependencies/      # Dependency injection setup
│   ├── enum/              # Enumerations
│   ├── notifiers/         # State notifiers
│   ├── repository/        # Data repositories
│   ├── router/            # Navigation and routing
│   ├── services/          # Business logic services
│   ├── theme/             # App theming
│   └── widgets/           # Shared widgets
└── features/              # Feature modules
    ├── fingerprint_login/ # Biometric authentication
    ├── home/              # Home screen
    ├── login_options/     # Login type selection
    ├── mechanism_login/   # Azure AD B2C / Auth0
    ├── passcode_login/    # PIN code authentication
    ├── simple_login/      # Username/Password login
    └── third_login/       # Social media authentication
```

## Authentication Methods

### 1. User / Password Login

Traditional authentication using username and password credentials. This demonstrates:
- Form validation using `formz` package
- Secure credential handling
- Backend integration patterns

### 2. Passcode Login

Phone number-based authentication with 4-digit verification code. Features:
- Phone number input validation
- PIN code entry with `pinput` package
- Push notification simulation for access code

### 3. Fingerprint / Face ID

Biometric authentication using local device capabilities:
- Fingerprint recognition (Android, iOS)
- Face ID (iOS)
- Local authentication with `local_auth` package
- Secure storage with `flutter_secure_storage`

### 4. Third-Party Sign In

Social media authentication supporting:
- **Google Sign In**: OAuth 2.0 authentication
- **Apple Sign In**: Sign in with Apple ID
- **Facebook Login**: Facebook authentication
- **Twitter Login**: Twitter OAuth

### 5. Other Mechanisms

Enterprise authentication solutions:
- **Azure Active Directory B2C**: Microsoft identity platform
- **Auth0**: Universal authentication platform

Each mechanism supports user/password and social logins within their platforms.

## Third-Party Authentication Configuration

### Google Sign In

**Option 1: Using GoogleService files** (Recommended)

Follow the [official integration guide](https://pub.dev/packages/google_sign_in#platform-integration)

**Option 2: Using dart-define configuration**

Add to your `config-keys.json`:
```json
{
  "GOOGLE_CLIENT_ID_AND": "<YOUR_GOOGLE_CLIENT_ID_AND>",
  "GOOGLE_CLIENT_ID_IOS": "<YOUR_GOOGLE_CLIENT_ID_IOS>",
  "GOOGLE_CLIENT_ID_IOS_REV": "<YOUR_GOOGLE_CLIENT_ID_IOS_IN_REVERSE>"
}
```

Get credentials from [Google Cloud Console](https://console.cloud.google.com/apis/dashboard)

### Apple Sign In

Required configuration in `config-keys.json`:
```json
{
  "APPLE_CLIENT_ID": "<YOUR_APPLE_CLIENT_ID>",
  "APPLE_REDIRECT_URI": "<YOUR_APPLE_REDIRECT_URI>"
}
```

Resources:
- [Apple Developer Portal](https://developer.apple.com)
- [Integration Guide](https://pub.dev/packages/sign_in_with_apple#integration)

### Facebook Sign In

Required configuration in `config-keys.json`:
```json
{
  "FACEBOOK_APP_ID": "<YOUR_FACEBOOK_APP_ID>",
  "FACEBOOK_CLIENT_TOKEN": "<YOUR_FACEBOOK_CLIENT_TOKEN>",
  "FACEBOOK_DISPLAY_NAME": "<YOUR_FACEBOOK_DISPLAY_NAME>"
}
```

Resources:
- [Facebook Developers](https://developers.facebook.com)
- [Android Setup](https://facebook.meedu.app/docs/5.x.x/android)
- [iOS Setup](https://facebook.meedu.app/docs/5.x.x/ios)

### Twitter Sign In

Required configuration in `config-keys.json`:
```json
{
  "TWITTER_API_KEY": "<YOUR_TWITTER_API_KEY>",
  "TWITTER_API_SECRET": "<YOUR_TWITTER_API_SECRET>",
  "TWITTER_REDIRECT_URI": "<YOUR_TWITTER_REDIRECT_URI>"
}
```

Resources:
- [Twitter Developer Portal](https://developer.twitter.com)
- [Integration Guide](https://pub.dev/packages/twitter_login#twitter-configuration)

### Azure AD B2C

Required configuration in `config-keys.json`:
```json
{
  "AZURE_TENANT_NAME": "<YOUR_AZURE_TENANT_NAME>",
  "AZURE_TENANT_ID": "<YOUR_AZURE_TENANT_ID>",
  "AZURE_POLICY_NAME": "<YOUR_AZURE_POLICY_NAME>",
  "AZURE_CLIENT_ID": "<YOUR_AZURE_CLIENT_ID>",
  "AZURE_REDIRECT_SCHEME": "<YOUR_AZURE_REDIRECT_SCHEME>",
  "AZURE_REDIRECT_PATH": "<YOUR_AZURE_REDIRECT_PATH>",
  "AZURE_ENDPOINT_URL": "<YOUR_AZURE_ENDPOINT_URL>"
}
```

Resources:
- [Create Azure B2C Tenant](https://learn.microsoft.com/en-us/azure/active-directory-b2c/tutorial-create-tenant)
- [Register Application](https://learn.microsoft.com/en-us/azure/healthcare-apis/register-application)
- [Create User Flows](https://learn.microsoft.com/en-us/azure/active-directory-b2c/tutorial-create-user-flows?pivots=b2c-user-flow)

### Auth0

Required configuration in `config-keys.json`:
```json
{
  "AUTH0_DOMAIN": "<YOUR_AUTH0_DOMAIN>",
  "AUTH0_CLIENT_ID": "<YOUR_AUTH0_CLIENT_ID>",
  "AUTH0_SCHEME_AND": "<YOUR_AUTH0_SCHEME_AND>"
}
```

**Note**: `AUTH0_SCHEME_AND` is only required for Android custom schemes.

Resources:
- [Auth0 Flutter Quickstart](https://auth0.com/docs/quickstart/native/flutter/interactive)

## Localization (l10n)

### Add new translations

1. Edit the `.arb` files in `lib/l10n/arb/`

2. Add new key/value pairs:
   ```json
   {
     "@@locale": "en",
     "newKey": "New translation",
     "@newKey": {
       "description": "Description of the new key"
     }
   }
   ```

3. Regenerate localization files:
   ```bash
   flutter gen-l10n
   ```

### Add new language

1. Create a new `.arb` file in `lib/l10n/arb/`:
   ```
   intl_fr.arb  # For French
   ```

2. Update iOS localization in `ios/Runner/Info.plist`:
   ```xml
   <key>CFBundleLocalizations</key>
   <array>
     <string>en</string>
     <string>es</string>
     <string>fr</string>
   </array>
   ```

3. Regenerate localization files

## Testing

### Run all tests

```bash
flutter test
```

### Run specific test file

```bash
flutter test test/path/to/test_file.dart
```

### Run tests with coverage

```bash
flutter test --coverage
```

## Code Quality

### Run code analysis

The project uses `very_good_analysis` to maintain code quality:

```bash
flutter analyze
```

### Format code

```bash
flutter format .
```

### Generate code (Freezed)

This project uses `freezed` for code generation:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Main Dependencies

- **hooks_riverpod**: State management and dependency injection
- **flutter_hooks**: React-like hooks for Flutter
- **go_router**: Declarative routing
- **formz**: Form validation
- **freezed**: Code generation for data classes
- **equatable**: Value equality

### Authentication

- **google_sign_in**: Google authentication
- **sign_in_with_apple**: Apple authentication
- **flutter_facebook_auth**: Facebook authentication
- **twitter_login**: Twitter authentication
- **auth0_flutter**: Auth0 integration
- **flutter_appauth**: OAuth 2.0 and OpenID Connect
- **local_auth**: Biometric authentication

### Storage & Security

- **flutter_secure_storage**: Secure key-value storage
- **shared_preferences**: Simple key-value storage

### UI Components

- **google_fonts**: Google Fonts integration
- **pinput**: PIN input widget
- **gap**: Spacing widgets
- **flutter_local_notifications**: Local notifications

### Dev Dependencies

- **build_runner**: Code generation
- **freezed**: Immutable data classes
- **very_good_analysis**: Strict lint rules

## Troubleshooting

### Error: "Flutter SDK not found"
Verify that Flutter is installed correctly and in your PATH:
```bash
flutter doctor
```

### config-keys.json not found
Ensure you have created the `config-keys.json` file in the root directory as described in the configuration section.

### Google Sign In fails
- Verify your Google Client IDs are correct
- Check SHA-1 fingerprint is registered in Firebase Console
- Ensure GoogleService files are properly configured

### Apple Sign In not working
- Verify Sign in with Apple capability is enabled in Xcode
- Check Bundle Identifier matches Apple Developer Portal
- Ensure redirect URI is correctly configured

### Facebook Login errors
- Verify Facebook App ID and Client Token
- Check Facebook app is not in Development Mode (or test users are added)
- Ensure iOS Info.plist and Android strings.xml are properly configured

### Azure AD B2C errors
- Verify all Azure configuration values are correct
- Check user flow is properly configured
- Ensure redirect URI matches your configuration

### l10n generation error
Regenerate localization files:
```bash
flutter gen-l10n
```

### Freezed code generation issues
Clean and rebuild:
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### iOS build fails
Clean and rebuild:
```bash
flutter clean
cd ios
pod install
cd ..
flutter build ios
```

### Android build fails
Clean project:
```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter build apk
```

## Contributing

1. Create a branch from `main`
2. Make your changes
3. Run tests: `flutter test`
4. Run analysis: `flutter analyze`
5. Format code: `flutter format .`
6. Create a Pull Request to `main`

## Security Considerations

- Never commit `config-keys.json` to version control
- Use environment-specific configurations for different builds
- Implement proper token refresh mechanisms
- Use secure storage for sensitive data
- Follow OAuth 2.0 best practices
- Implement certificate pinning for production apps

## License

[Include license information here]
