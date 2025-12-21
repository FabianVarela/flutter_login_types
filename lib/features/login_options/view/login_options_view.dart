import 'package:flutter/material.dart';
import 'package:flutter_login_types/core/router/app_route_path.dart';
import 'package:flutter_login_types/core/theme/colors.dart';
import 'package:flutter_login_types/core/widgets/custom_button.dart';
import 'package:flutter_login_types/l10n/l10n.dart';
import 'package:go_router/go_router.dart';

class LoginOptionsView extends StatelessWidget {
  const LoginOptionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = context.localizations;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.signInOptionText,
          textAlign: .center,
          style: const TextStyle(color: CustomColors.darkBlue, fontSize: 20),
        ),
      ),
      backgroundColor: CustomColors.white,
      body: const Padding(
        padding: .symmetric(horizontal: 16),
        child: Column(
          spacing: 20,
          mainAxisAlignment: .center,
          crossAxisAlignment: .stretch,
          children: <Widget>[
            _SimpleLoginButton(),
            _PasscodeButton(),
            _FingerprintButton(),
            _ThirdLoginButton(),
            _MechanismLoginButton(),
          ],
        ),
      ),
    );
  }
}

class _SimpleLoginButton extends StatelessWidget {
  const _SimpleLoginButton();

  @override
  Widget build(BuildContext context) {
    final localization = context.localizations;

    return CustomButton(
      text: localization.signInText(localization.signInUserPassword),
      onPress: () => context.push(AppRoutePath.loginOptions.userPassword.path),
      backgroundColor: CustomColors.white.withValues(alpha: .6),
      foregroundColor: CustomColors.darkBlue,
      icon: const Icon(Icons.login, color: CustomColors.darkBlue),
    );
  }
}

class _PasscodeButton extends StatelessWidget {
  const _PasscodeButton();

  @override
  Widget build(BuildContext context) {
    final localization = context.localizations;

    return CustomButton(
      text: localization.signInText(localization.signInPasscode),
      onPress: () => context.push(AppRoutePath.loginOptions.passcode.path),
      backgroundColor: CustomColors.lightBlue,
      foregroundColor: CustomColors.white,
      icon: const Icon(Icons.sms_outlined, color: CustomColors.white),
    );
  }
}

class _FingerprintButton extends StatelessWidget {
  const _FingerprintButton();

  @override
  Widget build(BuildContext context) {
    final localization = context.localizations;

    return CustomButton(
      text: localization.signInText(localization.signInFingerPrint),
      onPress: () => context.push(AppRoutePath.loginOptions.biometric.path),
      backgroundColor: CustomColors.darkPurple,
      foregroundColor: CustomColors.white,
      icon: const Icon(Icons.fingerprint_outlined, color: CustomColors.white),
    );
  }
}

class _ThirdLoginButton extends StatelessWidget {
  const _ThirdLoginButton();

  @override
  Widget build(BuildContext context) {
    final localization = context.localizations;

    return CustomButton(
      text: localization.signInText(localization.signInThird),
      onPress: () => context.push(AppRoutePath.loginOptions.third.path),
      backgroundColor: CustomColors.darkYellow,
      foregroundColor: CustomColors.white,
      icon: const Icon(
        Icons.account_circle_outlined,
        color: CustomColors.white,
      ),
    );
  }
}

class _MechanismLoginButton extends StatelessWidget {
  const _MechanismLoginButton();

  @override
  Widget build(BuildContext context) {
    final localization = context.localizations;

    return CustomButton(
      text: localization.signInText(localization.signInOtherMechanism),
      onPress: () => context.push(AppRoutePath.loginOptions.mechanism.path),
      backgroundColor: CustomColors.lightRed,
      foregroundColor: CustomColors.white,
      icon: const Icon(Icons.account_balance, color: CustomColors.white),
    );
  }
}
