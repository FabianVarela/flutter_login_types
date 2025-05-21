// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Login types';

  @override
  String get signInOptionText => 'Chose sign in options';

  @override
  String signInText(String option) {
    return 'Sign in with $option';
  }

  @override
  String get signInUserPassword => 'User / password';

  @override
  String get signInPasscode => 'Passcode';

  @override
  String get signInFingerPrint => 'Fingerprint';

  @override
  String get signInThird => 'Third parties';

  @override
  String get signInFacebook => 'Facebook';

  @override
  String get signInApple => 'Apple';

  @override
  String get signInGoogle => 'Google';

  @override
  String get signInTwitter => 'Twitter';

  @override
  String get signInOtherMechanism => 'other mechanism';

  @override
  String get signInAzureAd => 'Azure AD';

  @override
  String get signInAuth0 => 'Auth0';

  @override
  String get signInThirdInProgress => 'In progress, please wait';

  @override
  String get signInThirdCancelled => 'Cancelled by the user';

  @override
  String get signInThirdError => 'Error to sign in';

  @override
  String get emailPlaceholder => 'Enter email';

  @override
  String get emailRequiredMessage => 'Email is required';

  @override
  String get passwordPlaceholder => 'Enter password';

  @override
  String get passwordRequiredMessage => 'Password is required';

  @override
  String get signInButton => 'Sign In';

  @override
  String get userPasswordIncorrectMessage => 'User or password incorrect.';

  @override
  String get phoneNumberTitle => 'Digit phone number';

  @override
  String get phoneNumberPlaceholder => 'Enter phone number';

  @override
  String get phoneNumberRequired => 'Phone number is required';

  @override
  String get verifyButtonText => 'Verify';

  @override
  String get passcodeTitle => 'Digit verification code';

  @override
  String get phoneNumberIncorrect => 'Phone number is incorrect.';

  @override
  String get passcodeIncorrect => 'Passcode is incorrect.';

  @override
  String get biometricTitle => 'Click to start';

  @override
  String get biometricButtonText => 'Click to start with fingerprint';

  @override
  String get biometricEnabledText =>
      'You must go to settings and \nenable fingerprint or face ID';

  @override
  String get biometricNoSupportedText =>
      'This device no support sign in by fingerprint';

  @override
  String get biometricReason => 'Set fingerprint or face id to start';

  @override
  String get biometricError => 'No authorized';

  @override
  String get azureLoginCancelled => 'Azure login, cancelled';

  @override
  String get azureLoginError => 'Error logging in with Azure';

  @override
  String get auth0LoginCancelled => 'Auth0 login, cancelled';

  @override
  String get auth0LoginError => 'Error logging in with Auth0';

  @override
  String get homeTitle => 'Home page';

  @override
  String get homeText => 'Welcome';

  @override
  String get emptyValidation => 'Text field is empty';

  @override
  String get emailValidation => 'Enter a valid email';

  @override
  String get passwordValidation => 'The password is greater than 4 characters';

  @override
  String get numberValidation => 'Enter a valid number';

  @override
  String get notificationTitle => 'Login types';

  @override
  String notificationMessage(String code) {
    return 'Your code is $code';
  }

  @override
  String get changeLanguageTitle => 'Change language';

  @override
  String get englishLanguage => 'English';

  @override
  String get spanishLanguage => 'Spanish';
}
