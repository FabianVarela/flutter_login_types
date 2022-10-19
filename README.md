# Flutter · Login BLoC

Create a different ways to login using Flutter and BLoC pattern state management with RxDart

------

### Firebase · Only for Firebase UI

* You must have a Firebase Project already created.
* You must install ```firebase tools``` and ```FlutterFire CLI``` on your local machine.
    * To install ```firebase tools```, could you
      guide [here](https://firebase.google.com/docs/cli?authuser=0&hl=es#install_the_firebase_cli)
    * After install ```firebase tools```, you must log in with your Google account.
    * To install ```FlutterFire CLI```, you must run the command below.
      ```bash
      dart pub global activate flutterfire_cli
      ```

### Flutter

* Clone this project.
* If you want to rename the bundles for each platform, you must do the steps below.
    * For Android, you must rename the bundle id on ```app/build.gradle```.
    * For iOS in XCode IDE, you select ```Runner``` and change the 'Bundle Identifier' text.
* For Android, you must in the ```android/src/main/res/strings.xml``` directory the values for Facebook login set in the
  file
* For iOS, you must in the ```ios/Runner/Info.plist``` directory the values for Facebook and Google login set in the
  file.
* You must run the ```FlutterFire CLI``` command
  ```bash
  flutterfire configure --project=<YOUR_PROJECT_ID>
  ```
* You must set the **Firebase Auth Client id** as the *Dart Define command* setting the additional run arguments below
  ```
  --dart-define CLIENT_ID=<YOUR_FIREBASE_AUTH_CLIENT_ID>
  ```
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

### Facebook

This scenario recreates the authentication with third providers like Facebook, Twitter, Microsoft, etc. In this case,
only use Facebook.

### Firebase Auth UI

This scenario recreates the login using the UI provided by Firebase, using its own screen to log in or sign up. Also, is
enabled by other providers like Google, Facebook, and Apple. You must enable the Firebase Auth console to use the other
providers.

------

### Used packages

#### Dependencies

- Firebase ([firebase_core](https://pub.dev/packages/firebase_core)
  , [firebase_auth](https://pub.dev/packages/firebase_auth))
- Flutter Facebook auth ([flutter_facebook_auth](https://pub.dev/packages/flutter_facebook_auth))
- Flutter local notifications ([flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications))
- FlutterFire UI - Auth ([flutterfire_ui](https://pub.dev/packages/flutterfire_ui))
- Go Router ([go_router](https://pub.dev/packages/go_router))
- Hooks ([flutter_hooks](https://pub.dev/packages/flutter_hooks))
- Google fonts ([google_fonts](https://pub.dev/packages/google_fonts))
- Google signIn ([google_sign_in](https://pub.dev/packages/google_sign_in))
- Intl ([intl](https://pub.dev/packages/intl))
- Local auth ([local_auth](https://pub.dev/packages/local_auth))
- Pinput ([pinput](https://pub.dev/packages/pinput))
- RxDart ([rxdart](https://pub.dev/packages/rxdart))
- Shared preferences ([shared_preferences](https://pub.dev/packages/shared_preferences))
- SignIn with Apple ([sign_in_with_apple](https://pub.dev/packages/sign_in_with_apple))

#### Dev dependencies

- Very Good Analysis ([very_good_analysis](https://pub.dev/packages/very_good_analysis))
