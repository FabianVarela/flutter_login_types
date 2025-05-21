import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// App title
  ///
  /// In en, this message translates to:
  /// **'Login types'**
  String get appName;

  /// Sign in option title
  ///
  /// In en, this message translates to:
  /// **'Chose sign in options'**
  String get signInOptionText;

  /// Sign in with parameter text
  ///
  /// In en, this message translates to:
  /// **'Sign in with {option}'**
  String signInText(String option);

  /// Sign in user/password text
  ///
  /// In en, this message translates to:
  /// **'User / password'**
  String get signInUserPassword;

  /// Sign in with passcode text
  ///
  /// In en, this message translates to:
  /// **'Passcode'**
  String get signInPasscode;

  /// Sign in with fingerprint text
  ///
  /// In en, this message translates to:
  /// **'Fingerprint'**
  String get signInFingerPrint;

  /// Sign in with third parties text
  ///
  /// In en, this message translates to:
  /// **'Third parties'**
  String get signInThird;

  /// Sign in with facebook text
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get signInFacebook;

  /// Sign in with apple text
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get signInApple;

  /// Sign in with google text
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get signInGoogle;

  /// Sign in with twitter text
  ///
  /// In en, this message translates to:
  /// **'Twitter'**
  String get signInTwitter;

  /// Sign in with other mechanism text
  ///
  /// In en, this message translates to:
  /// **'other mechanism'**
  String get signInOtherMechanism;

  /// Sign in with azure ad text
  ///
  /// In en, this message translates to:
  /// **'Azure AD'**
  String get signInAzureAd;

  /// Sign in with auth0 text
  ///
  /// In en, this message translates to:
  /// **'Auth0'**
  String get signInAuth0;

  /// Sign in with third in progress text message
  ///
  /// In en, this message translates to:
  /// **'In progress, please wait'**
  String get signInThirdInProgress;

  /// Sign in with third cancelled text message
  ///
  /// In en, this message translates to:
  /// **'Cancelled by the user'**
  String get signInThirdCancelled;

  /// Sign in with third error text message
  ///
  /// In en, this message translates to:
  /// **'Error to sign in'**
  String get signInThirdError;

  /// Email text field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get emailPlaceholder;

  /// Message if email is required
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequiredMessage;

  /// Password text field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get passwordPlaceholder;

  /// Message if password is required
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequiredMessage;

  /// Sign in button text
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInButton;

  /// Message when user or password are incorrect
  ///
  /// In en, this message translates to:
  /// **'User or password incorrect.'**
  String get userPasswordIncorrectMessage;

  /// Phone number screen title
  ///
  /// In en, this message translates to:
  /// **'Digit phone number'**
  String get phoneNumberTitle;

  /// phone number text field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get phoneNumberPlaceholder;

  /// Message if phone number is required
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneNumberRequired;

  /// Verify button text
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verifyButtonText;

  /// Passcode screen title
  ///
  /// In en, this message translates to:
  /// **'Digit verification code'**
  String get passcodeTitle;

  /// Message when phone number is incorrect
  ///
  /// In en, this message translates to:
  /// **'Phone number is incorrect.'**
  String get phoneNumberIncorrect;

  /// Message when passcode is incorrect
  ///
  /// In en, this message translates to:
  /// **'Passcode is incorrect.'**
  String get passcodeIncorrect;

  /// Biometric screen title
  ///
  /// In en, this message translates to:
  /// **'Click to start'**
  String get biometricTitle;

  /// Biometric button text
  ///
  /// In en, this message translates to:
  /// **'Click to start with fingerprint'**
  String get biometricButtonText;

  /// Message when biometric is disabled in device
  ///
  /// In en, this message translates to:
  /// **'You must go to settings and \nenable fingerprint or face ID'**
  String get biometricEnabledText;

  /// Message when biometric is not supported in this device
  ///
  /// In en, this message translates to:
  /// **'This device no support sign in by fingerprint'**
  String get biometricNoSupportedText;

  /// Message when biometric show dialog
  ///
  /// In en, this message translates to:
  /// **'Set fingerprint or face id to start'**
  String get biometricReason;

  /// Biometric message when user is not authorized
  ///
  /// In en, this message translates to:
  /// **'No authorized'**
  String get biometricError;

  /// Azure login message when user cancel
  ///
  /// In en, this message translates to:
  /// **'Azure login, cancelled'**
  String get azureLoginCancelled;

  /// Azure login message when user is not authorized
  ///
  /// In en, this message translates to:
  /// **'Error logging in with Azure'**
  String get azureLoginError;

  /// Auth0 login message when user cancel
  ///
  /// In en, this message translates to:
  /// **'Auth0 login, cancelled'**
  String get auth0LoginCancelled;

  /// Auth0 login message when user is not authorized
  ///
  /// In en, this message translates to:
  /// **'Error logging in with Auth0'**
  String get auth0LoginError;

  /// Home app bar title
  ///
  /// In en, this message translates to:
  /// **'Home page'**
  String get homeTitle;

  /// Home text in page
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get homeText;

  /// Message in text field when is empty
  ///
  /// In en, this message translates to:
  /// **'Text field is empty'**
  String get emptyValidation;

  /// Message in text field when email is invalid
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get emailValidation;

  /// Message in text field when password is invalid
  ///
  /// In en, this message translates to:
  /// **'The password is greater than 4 characters'**
  String get passwordValidation;

  /// Message in text field when text is not numeric
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get numberValidation;

  /// Notification title when send a code
  ///
  /// In en, this message translates to:
  /// **'Login types'**
  String get notificationTitle;

  /// Notification text when send a code
  ///
  /// In en, this message translates to:
  /// **'Your code is {code}'**
  String notificationMessage(String code);

  /// Change language title
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get changeLanguageTitle;

  /// Change language first option text
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLanguage;

  /// Change language second option text
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanishLanguage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
