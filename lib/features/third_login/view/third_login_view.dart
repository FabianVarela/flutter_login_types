import 'package:flutter/material.dart';
import 'package:flutter_login_types/core/theme/colors.dart';
import 'package:flutter_login_types/core/widgets/custom_button.dart';
import 'package:flutter_login_types/core/widgets/custom_message.dart';
import 'package:flutter_login_types/features/third_login/dependency.dart';
import 'package:flutter_login_types/features/third_login/notifier/third_login_notifier.dart';
import 'package:flutter_login_types/l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class ThirdLoginView extends ConsumerWidget {
  const ThirdLoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(thirdLoginNotifierProvider, (_, next) {
      if (next == ThirdLoginResult.success) {
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
      ),
      backgroundColor: CustomColors.white,
      extendBodyBehindAppBar: true,
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _GoogleButton(),
            SizedBox(height: 20),
            _AppleButton(),
            SizedBox(height: 20),
            _FacebookButton(),
            SizedBox(height: 20),
            _TwitterButton(),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, ThirdLoginResult state) {
    final localization = context.localizations;
    final message = switch (state) {
      ThirdLoginResult.progress => localization.signInThirdInProgress,
      ThirdLoginResult.cancelled => localization.signInThirdCancelled,
      ThirdLoginResult.error => localization.signInThirdError,
      _ => null,
    };

    if (message != null) CustomMessage.show(context, message);
  }
}

class _GoogleButton extends ConsumerWidget {
  const _GoogleButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = context.localizations;

    return CustomButton(
      text: localization.signInText(localization.signInGoogle),
      onPress: () {
        ref.read(thirdLoginNotifierProvider.notifier).authenticateGoogle();
      },
      backgroundColor: CustomColors.grey.withOpacity(.4),
      foregroundColor: CustomColors.white,
      icon: const Icon(Icons.g_mobiledata_outlined, color: CustomColors.white),
    );
  }
}

class _AppleButton extends ConsumerWidget {
  const _AppleButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = context.localizations;

    return SignInWithAppleBuilder(
      builder: (context) => CustomButton(
        text: localization.signInText(localization.signInApple),
        onPress: () {
          ref.read(thirdLoginNotifierProvider.notifier).authenticateApple();
        },
        backgroundColor: Colors.black,
        foregroundColor: CustomColors.white,
        icon: const Center(
          child: CustomPaint(
            size: Size(22, 24),
            painter: AppleLogoPainter(color: CustomColors.white),
          ),
        ),
      ),
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
        ref.read(thirdLoginNotifierProvider.notifier).authenticateFacebook();
      },
      backgroundColor: CustomColors.kingBlue,
      foregroundColor: CustomColors.white,
      icon: const Icon(Icons.face_outlined, color: CustomColors.white),
    );
  }
}

class _TwitterButton extends ConsumerWidget {
  const _TwitterButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = context.localizations;

    return CustomButton(
      text: localization.signInText(localization.signInTwitter),
      onPress: () {
        ref.read(thirdLoginNotifierProvider.notifier).authenticateTwitter();
      },
      backgroundColor: CustomColors.lightKingBlue,
      foregroundColor: CustomColors.white,
      icon: const Icon(
        Icons.check_circle_outline_outlined,
        color: CustomColors.white,
      ),
    );
  }
}
