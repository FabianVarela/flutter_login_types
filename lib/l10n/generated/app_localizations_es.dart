// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Tipos de inicio de sesión';

  @override
  String get signInOptionText => 'Elige una forma de iniciar sesión';

  @override
  String signInText(String option) {
    return 'Iniciar sesión con $option';
  }

  @override
  String get signInUserPassword => 'Usuario / contraseña';

  @override
  String get signInPasscode => 'Passcode';

  @override
  String get signInFingerPrint => 'Huella';

  @override
  String get signInThird => 'Terceros';

  @override
  String get signInFacebook => 'Facebook';

  @override
  String get signInApple => 'Apple';

  @override
  String get signInGoogle => 'Google';

  @override
  String get signInTwitter => 'Twitter';

  @override
  String get signInOtherMechanism => 'otro mecanísmo';

  @override
  String get signInAzureAd => 'el DA de Azure';

  @override
  String get signInAuth0 => 'Auth0';

  @override
  String get signInThirdInProgress => 'En progreso, por favor espere';

  @override
  String get signInThirdCancelled => 'Cancelado por el usuario';

  @override
  String get signInThirdError => 'Error al iniciar sesión';

  @override
  String get emailPlaceholder => 'Ingrese correo electrónico';

  @override
  String get emailRequiredMessage => 'El correo electrónico es requerido';

  @override
  String get passwordPlaceholder => 'Ingrese la contraseña';

  @override
  String get passwordRequiredMessage => 'La contraseña es requerida';

  @override
  String get signInButton => 'Iniciar sesión';

  @override
  String get userPasswordIncorrectMessage => 'Usuario o contraseña incorrecta.';

  @override
  String get phoneNumberTitle => 'Digite el número de teléfono';

  @override
  String get phoneNumberPlaceholder => 'Ingrese número telefónico';

  @override
  String get phoneNumberRequired => 'El número de teléfono es requerido';

  @override
  String get verifyButtonText => 'Verificar';

  @override
  String get passcodeTitle => 'Digite el código de verificación';

  @override
  String get phoneNumberIncorrect => 'Número de teléfono incorrecto.';

  @override
  String get passcodeIncorrect => 'Código incorrecto.';

  @override
  String get biometricTitle => 'Haz click para iniciar';

  @override
  String get biometricButtonText => 'Click para iniciar con huella';

  @override
  String get biometricEnabledText => 'Debes ir a configuración y habilitar \nla huella o el Face ID';

  @override
  String get biometricNoSupportedText => 'Este dispositivo no soporta inicio de sesión mediante biometría';

  @override
  String get biometricReason => 'Coloca tu huella o cara para iniciar';

  @override
  String get biometricError => 'No autorizado';

  @override
  String get azureLoginCancelled => 'Incio de sesión de Azure, cancelado';

  @override
  String get azureLoginError => 'Error al iniciar sesión con Azure';

  @override
  String get auth0LoginCancelled => 'Incio de sesión de Auth0, cancelado';

  @override
  String get auth0LoginError => 'Error al iniciar sesión con Auth0';

  @override
  String get homeTitle => 'Página de inicio';

  @override
  String get homeText => 'Bienvenido';

  @override
  String get emptyValidation => 'El campo de texto se encuentra vacío';

  @override
  String get emailValidation => 'Ingrese un correo válido';

  @override
  String get passwordValidation => 'La contraseña debe ser mayor que 4 caracteres';

  @override
  String get numberValidation => 'Ingrese un número válido';

  @override
  String get notificationTitle => 'Tipos de inicio de sesión';

  @override
  String notificationMessage(String code) {
    return 'Tu código es $code';
  }

  @override
  String get changeLanguageTitle => 'Cambiar idioma';

  @override
  String get englishLanguage => 'Inglés';

  @override
  String get spanishLanguage => 'Español';
}
