import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_login_types/core/enum/login_type.dart';
import 'package:flutter_login_types/core/notifiers/language_notifier.dart';
import 'package:flutter_login_types/core/notifiers/session/session_notifier.dart';
import 'package:flutter_login_types/core/theme/colors.dart';
import 'package:flutter_login_types/core/widgets/custom_button.dart';
import 'package:flutter_login_types/core/widgets/custom_message.dart';
import 'package:flutter_login_types/core/widgets/loading.dart';
import 'package:flutter_login_types/features/mechanism_login/notifier/mechanism_login_notifier.dart';
import 'package:flutter_login_types/l10n/l10n.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MechanismLoginView extends HookConsumerWidget {
  const MechanismLoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = context.localizations;

    final mechanismLogin = ref.watch(mechanismLoginNotifierProvider);
    final language = ref.watch(languageNotifierProvider);

    ref.listen(mechanismLoginNotifierProvider, (_, state) {
      state.whenOrNull(
        data: (data) {
          if (data.type != MechanismType.none && data.token != null) {
            final notifier = ref.read(sessionNotifierProvider.notifier);
            final loginType = switch (data.type) {
              .auth0 => LoginType.auth0,
              _ => LoginType.azure,
            };

            unawaited(
              notifier.setSession(
                sessionArgs: (token: data.token!, loginType: loginType),
              ),
            );
          }
        },
        error: (e, _) {
          if (e is MechanismException) _showErrorMessage(context, e);
        },
      );
    });

    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(),
          backgroundColor: CustomColors.white,
          extendBodyBehindAppBar: true,
          body: Padding(
            padding: const .symmetric(horizontal: 24),
            child: Column(
              spacing: 20,
              mainAxisAlignment: .center,
              crossAxisAlignment: .stretch,
              children: <Widget>[
                CustomButton(
                  text: localization.signInText(localization.signInAzureAd),
                  onPress: () {
                    final notifier = ref.read(
                      mechanismLoginNotifierProvider.notifier,
                    );
                    unawaited(
                      notifier.authenticateAzure(
                        language: language?.languageCode,
                      ),
                    );
                  },
                  backgroundColor: CustomColors.kingBlue,
                  foregroundColor: CustomColors.white,
                  icon: const Icon(Icons.window, color: CustomColors.white),
                ),
                CustomButton(
                  text: localization.signInText(localization.signInAuth0),
                  onPress: () {
                    final notifier = ref.read(
                      mechanismLoginNotifierProvider.notifier,
                    );
                    unawaited(notifier.authenticateAuth0());
                  },
                  backgroundColor: CustomColors.lightRed,
                  foregroundColor: CustomColors.white,
                  icon: const Icon(Icons.star, color: CustomColors.white),
                ),
              ],
            ),
          ),
        ),
        if (mechanismLogin.isLoading) const Loading(),
      ],
    );
  }

  void _showErrorMessage(BuildContext context, MechanismException exception) {
    final localization = context.localizations;
    final message = switch (exception.type) {
      .azure => switch (exception.error) {
        .cancelled => localization.azureLoginCancelled,
        .error => localization.azureLoginError,
      },
      .auth0 => switch (exception.error) {
        .cancelled => localization.auth0LoginCancelled,
        .error => localization.auth0LoginError,
      },
      _ => null,
    };
    if (message != null) CustomMessage.show(context, message);
  }
}
