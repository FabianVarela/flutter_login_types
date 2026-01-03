# Flutter · Login Types

Create a different ways to login using Flutter Riverpod as state management and dependency injection.

------

### Flutter

* Clone this project.
* If you want to rename the bundles for each platform, you must do the steps below.
    * For Android, you must rename the bundle id on ```app/build.gradle```.
    * For iOS in XCode IDE, you select ```Runner``` and change the 'Bundle Identifier' text.
* You must follow the instructions for setting each third login in the steps follow [this link](#setting-third-logins).
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

This scenario recreates the authentication with third providers like Facebook, Google, Apple and Twitter.

### Other mechanism

This scenario recreates the authentication using different mechanism like Azure Active Directory B2C and/or Auth0,
enabling user/password, third logins, etc.

------

## Setting Third logins

### Setting `dart-define` file

Before to start, you must create a `JSON` file to set the dart-define variables. Create the JSON file
with the name `config-keys.json` on the project's root.

```json5
{
  // Set your key-values here
}
```

* You must set the json file in the *Dart Define command*, setting in the additional run arguments below
  ```
  --dart-define-from-file=config-keys.json
  ```

#### Setting Google sign in

* If you want to set the GoogleServices files
  follow [this link](https://pub.dev/packages/google_sign_in#platform-integration)
* If not, you must set the **Google client id** for Android and iOS, (as reverse mode for iOS) in the *Dart Define
  command* setting the additional run arguments below
  ```json5
  {
    "GOOGLE_CLIENT_ID_AND": "<YOUR_GOOGLE_CLIENT_ID_AND>",
    "GOOGLE_CLIENT_ID_IOS": "<YOUR_GOOGLE_CLIENT_ID_IOS>",
    "GOOGLE_CLIENT_ID_IOS_REV": "<YOUR_GOOGLE_CLIENT_ID_IOS_IN_REVERSE>",
    // More keys here...
  }
  ```

<font size="3">*These values you must get on
the [Google Console](https://console.cloud.google.com/apis/dashboard?project=to-do-app-6da92)*.</font>

#### Setting Apple sign in

* You must set the **Apple client id** and the **redirect url** as the *Dart Define command* setting the additional run
  arguments below
  ```json5
  {
    // keys already exists...
    "APPLE_CLIENT_ID": "<YOUR_APPLE_CLIENT_ID>",
    "APPLE_REDIRECT_URI": "<YOUR_APPLE_REDIRECT_URI>",
    // More keys here...
  }
  ```

<font size="3">*These values you must get on the [Apple Developer Portal](https://developer.apple.com). Also, you can
follow [this link](https://pub.dev/packages/sign_in_with_apple#integration)*</font>

#### Setting Facebook sign in

* You must set the **app id** and the **client token** as the *Dart Define command* setting the additional run
  arguments below.
  ```json5
  {
    // keys already exists...
    "FACEBOOK_APP_ID": "<YOUR_FACEBOOK_APP_ID>",
    "FACEBOOK_CLIENT_TOKEN": "<YOUR_FACEBOOK_CLIENT_TOKEN>",
    "FACEBOOK_DISPLAY_NAME": "<YOUR_FACEBOOK_DISPLAY_NAME>",
    // More keys here...
  }
  ```

<font size="3">*These values you must get on the [Facebook Developers](https://developers.facebook.com). Also, you can
follow [this link for Android](https://facebook.meedu.app/docs/5.x.x/android)
and [this link for iOS](https://facebook.meedu.app/docs/5.x.x/ios)*</font>

#### Setting Twitter sign in

* You must set the **Twitter api key**, **Twitter api secret** and the **redirect url** in the *Dart Define command*
  setting the additional run arguments below
  ```json5
  {
    // keys already exists...
    "TWITTER_API_KEY": "<YOUR_TWITTER_API_KEY>",
    "TWITTER_API_SECRET": "<YOUR_TWITTER_API_SECRET>",
    "TWITTER_REDIRECT_URI": "<YOUR_TWITTER_REDIRECT_URI>",
    // More keys here...
  }
  ```

<font size="3">*These values you must get on the [Twitter Developer](https://developer.twitter.com) or your
apps [here](https://developer.twitter.com/en/apps/). Also, you can
follow [this link](https://pub.dev/packages/twitter_login#twitter-configuration)*</font>

------

## Setting Auth providers

### Setting Azure AD B2C

* You must set the Azure **tenant name**, **tenant id**, **policy name**, **client id** and the **redirect url** in the
  *Dart Define command* setting the additional run arguments below
  ```json5
  {
    "AZURE_TENANT_NAME": "<YOUR_AZURE_TENANT_NAME>",
    "AZURE_TENANT_ID": "<YOUR_AZURE_TENANT_ID>",
    "AZURE_POLICY_NAME": "<YOUR_AZURE_POLICY_NAME>",
    "AZURE_CLIENT_ID": "<YOUR_AZURE_CLIENT_ID>",
    "AZURE_REDIRECT_SCHEME": "<YOUR_AZURE_REDIRECT_SCHEME>",
    "AZURE_REDIRECT_PATH": "<YOUR_AZURE_REDIRECT_PATH>",
    "AZURE_ENDPOINT_URL": "<YOUR_AZURE_ENDPOINT_URL>",
  }
  ```

<font size="3">To get these values, you must follow these links:

* [To create the Azure B2C tenant](https://learn.microsoft.com/en-us/azure/active-directory-b2c/tutorial-create-tenant?WT.mc_id=Portal-Microsoft_AAD_B2CAdmin)
* [To create the Azure AD B2C application](https://learn.microsoft.com/en-us/azure/healthcare-apis/register-application)
* [To create the user flow](https://learn.microsoft.com/en-us/azure/active-directory-b2c/tutorial-create-user-flows?pivots=b2c-user-flow)</font>

### Setting Auth0

* You must set the Auth0 **domain** and **client id** in the *Dart Define command* setting the additional run arguments
  below.
* Android only: If you set a custom scheme you have to set a *Dart Define key* with your custom scheme.
  ```json5
  {
    // keys already exists...
    "AUTH0_DOMAIN": "<YOUR_AUTH0_DOMAIN>",
    "AUTH0_CLIENT_ID": "<YOUR_AUTH0_CLIENT_ID>",
    // Only if you have a custom scheme
    "AUTH0_SCHEME_AND": "<YOUR_AUTH0_SCHEME_AND>",
  }
  ```

<font size="3">You can follow this link to guide:

* [Auth0 with Flutter](https://auth0.com/docs/quickstart/native/flutter/interactive)</font>
