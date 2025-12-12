import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_login_types/core/notifiers/session/session_notifier.dart';
import 'package:flutter_login_types/core/theme/colors.dart';
import 'package:flutter_login_types/core/widgets/custom_button.dart';
import 'package:flutter_login_types/core/widgets/custom_message.dart';
import 'package:flutter_login_types/core/widgets/loading.dart';
import 'package:flutter_login_types/features/third_login/notifier/third_login_notifier.dart';
import 'package:flutter_login_types/l10n/l10n.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class ThirdLoginView extends ConsumerWidget {
  const ThirdLoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thirdLogin = ref.watch(thirdLoginNotifierProvider);

    ref.listen(thirdLoginNotifierProvider, (_, state) {
      state.whenOrNull(
        data: (data) {
          if (data.result == ThirdLoginResult.success) {
            final notifier = ref.read(sessionNotifierProvider.notifier);
            unawaited(notifier.setSession(session: data.token!));
          } else {
            _showSnackBar(context, data.result);
          }
        },
      );
    });

    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(),
          backgroundColor: CustomColors.white,
          extendBodyBehindAppBar: true,
          body: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _GoogleButton(),
                _AppleButton(),
                _FacebookButton(),
                _TwitterButton(),
              ],
            ),
          ),
        ),
        if (thirdLogin.isLoading) const Loading(),
      ],
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
      onPress: () => unawaited(
        ref.read(thirdLoginNotifierProvider.notifier).authenticateGoogle(),
      ),
      backgroundColor: CustomColors.grey.withValues(alpha: .4),
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
      builder: (context) {
        return CustomButton(
          text: localization.signInText(localization.signInApple),
          onPress: () => unawaited(
            ref.read(thirdLoginNotifierProvider.notifier).authenticateApple(),
          ),
          backgroundColor: Colors.black,
          foregroundColor: CustomColors.white,
          icon: const Center(
            child: CustomPaint(
              size: Size(22, 24),
              painter: AppleLogoPainter(color: CustomColors.white),
            ),
          ),
        );
      },
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
      onPress: () => unawaited(
        ref.read(thirdLoginNotifierProvider.notifier).authenticateFacebook(),
      ),
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
      onPress: () => unawaited(
        ref.read(thirdLoginNotifierProvider.notifier).authenticateTwitter(),
      ),
      backgroundColor: CustomColors.lightKingBlue,
      foregroundColor: CustomColors.white,
      icon: const Icon(
        Icons.check_circle_outline_outlined,
        color: CustomColors.white,
      ),
    );
  }
}
