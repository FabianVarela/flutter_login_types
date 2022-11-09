import 'package:flutter/material.dart';
import 'package:flutter_login_types/core/theme/colors.dart';
import 'package:flutter_login_types/core/widgets/custom_button.dart';
import 'package:flutter_login_types/core/widgets/custom_message.dart';
import 'package:flutter_login_types/features/login_options/dependency.dart';
import 'package:flutter_login_types/features/login_options/notifier/facebook_login_notifier.dart';
import 'package:flutter_login_types/l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginOptionsView extends ConsumerWidget {
  const LoginOptionsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = context.localizations;

    ref.listen(facebookLoginNotifierProvider, (_, next) {
      if (next == FacebookLoginResult.success) {
        context.go('/home');
      } else {
        _showSnackBar(context, next);
      }
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Text(
          localization.signInOptionText,
          textAlign: TextAlign.center,
          style: const TextStyle(color: CustomColors.darkBlue, fontSize: 20),
        ),
      ),
      backgroundColor: CustomColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const <Widget>[
            _SimpleLoginButton(),
            SizedBox(height: 20),
            _PasscodeButton(),
            SizedBox(height: 20),
            _FingerprintButton(),
            SizedBox(height: 20),
            _FacebookButton(),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, FacebookLoginResult state) {
    final localization = context.localizations;
    String? message;

    switch (state) {
      case FacebookLoginResult.progress:
        message = localization.signInFacebookInProgress;
        break;
      case FacebookLoginResult.cancelled:
        message = localization.signInFacebookCancelled;
        break;
      case FacebookLoginResult.error:
        message = localization.signInFacebookError;
        break;
      default:
        break;
    }

    if (message != null) CustomMessage.show(context, message);
  }
}

class _SimpleLoginButton extends StatelessWidget {
  const _SimpleLoginButton();

  @override
  Widget build(BuildContext context) {
    final localization = context.localizations;

    return CustomButton(
      text: localization.signInText(localization.signInUserPassword),
      onPress: () => context.go('/login_user_pass'),
      backgroundColor: CustomColors.white.withOpacity(.6),
      foregroundColor: CustomColors.darkBlue,
      icon: const Icon(
        Icons.account_circle_outlined,
        color: CustomColors.darkBlue,
      ),
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
      onPress: () => context.go('/login_passcode'),
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
      onPress: () => context.go('/login_biometric'),
      backgroundColor: CustomColors.darkPurple,
      foregroundColor: CustomColors.white,
      icon: const Icon(Icons.fingerprint_outlined, color: CustomColors.white),
    );
  }
}

class _FacebookButton extends ConsumerWidget {
  const _FacebookButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = context.localizations;

    return CustomButton(
      text: localization.signInText(localization.signInFacebook),
      onPress: () {
        ref.read(facebookLoginNotifierProvider.notifier).authenticate();
      },
      backgroundColor: CustomColors.kingBlue,
      foregroundColor: CustomColors.white,
      icon: const Icon(Icons.face_outlined, color: CustomColors.white),
    );
  }
}
