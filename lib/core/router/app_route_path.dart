import 'package:go_router_paths/go_router_paths.dart';

class AppRoutePath {
  static LoginOptionsRoutePath get loginOptions => LoginOptionsRoutePath();

  static Path get home => Path('home');
}

class LoginOptionsRoutePath extends Path<LoginOptionsRoutePath> {
  LoginOptionsRoutePath() : super('welcome');

  Path get userPassword => Path('login-user-password', parent: this);

  Path get passcode => Path('login-passcode', parent: this);

  Path get biometric => Path('login-biometric', parent: this);

  Path get third => Path('login-third', parent: this);

  Path get mechanism => Path('login-mechanism', parent: this);

  TotpOptionsRoutePath get totpOptions => TotpOptionsRoutePath(parent: this);
}

class TotpOptionsRoutePath extends Path<TotpOptionsRoutePath> {
  TotpOptionsRoutePath({required Path parent})
    : super('totp-options', parent: parent);

  Path get totp => Path('login-totp', parent: this);

  Path get msal => Path('login-msal', parent: this);

  Path get googleTotp => Path('login-google-totp', parent: this);
}
