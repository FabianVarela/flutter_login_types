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
}
