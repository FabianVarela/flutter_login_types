# Flutter · Login Types

Create a different ways to login using Flutter Riverpod as state management and dependency injection.

------

### Flutter

* Clone this project.
* If you want to rename the bundles for each platform, you must do the steps below.
    * For Android, you must rename the bundle id on ```app/build.gradle```.
    * For iOS in XCode IDE, you select ```Runner``` and change the 'Bundle Identifier' text.
* For Android, you must in the ```android/src/main/res/strings.xml``` directory the values for Facebook login set in the
  file
* For iOS, you must in the ```ios/Runner/Info.plist``` directory the values for Facebook and Google login set in the
  file.
* Run project and enjoy :smile:

------

## Types of Login

### User / Password

This scenario recreates of type of conventional login (User / Password) like if you try to connect to a backend or
database with the user information and validate if the user and password are corrects.

### Passcode

This scenario recreates a login type with a phone number and receives a push notification with the access code which is
a number with 4 digits.

### Fingerprint / Face Id

This scenario recreates the local auth login with the use of fingerprint (Android, iOS) or face id (iOS).

### Third sign in

This scenario recreates the authentication with third providers like Facebook, Google, Apple and Twitter. In this case,
only use Facebook.

------

### Used packages

#### Dependencies

- Flutter Facebook auth ([flutter_facebook_auth](https://pub.dev/packages/flutter_facebook_auth))
- Flutter local notifications ([flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications))
- Formz ([formz](https://pub.dev/packages/formz))
- Freezed annotation ([freezed_annotation](https://pub.dev/packages/freezed_annotation))
- Go Router ([go_router](https://pub.dev/packages/go_router))
- Google fonts ([google_fonts](https://pub.dev/packages/google_fonts))
- Google signIn ([google_sign_in](https://pub.dev/packages/google_sign_in))
- Hooks ([flutter_hooks](https://pub.dev/packages/flutter_hooks))
- Intl ([intl](https://pub.dev/packages/intl))
- Local auth ([local_auth](https://pub.dev/packages/local_auth))
- Pinput ([pinput](https://pub.dev/packages/pinput))
- Riverpod with Hooks ([hooks_riverpod](https://pub.dev/packages/hooks_riverpod))
- Shared preferences ([shared_preferences](https://pub.dev/packages/shared_preferences))
- SignIn with Apple ([sign_in_with_apple](https://pub.dev/packages/sign_in_with_apple))

#### Dev dependencies

- Build runner ([build_runner](https://pub.dev/packages/build_runner))
- Freezed ([freezed](https://pub.dev/packages/freezed))
- Very Good Analysis ([very_good_analysis](https://pub.dev/packages/very_good_analysis))
