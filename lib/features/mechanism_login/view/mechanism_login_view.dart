import 'package:flutter/material.dart';
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
    final language = ref.watch(
      languageNotifierProvider.select((value) => value.value),
    );

    ref.listen(mechanismLoginNotifierProvider, (_, state) {
      state.whenOrNull(
        data: (data) {
          if (data.type != MechanismType.none && data.token != null) {
            ref
                .read(sessionNotifierProvider.notifier)
                .setSession(session: data.token!);
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
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                CustomButton(
                  text: localization.signInText(localization.signInAzureAd),
                  onPress: () {
                    ref
                        .read(mechanismLoginNotifierProvider.notifier)
                        .authenticateAzure(language: language?.languageCode);
                  },
                  backgroundColor: CustomColors.kingBlue,
                  foregroundColor: CustomColors.white,
                  icon: const Icon(Icons.window, color: CustomColors.white),
                ),
                CustomButton(
                  text: localization.signInText(localization.signInAuth0),
                  onPress: () {
                    ref
                        .read(mechanismLoginNotifierProvider.notifier)
                        .authenticateAuth0();
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
      MechanismType.azure => switch (exception.error) {
        MechanismError.cancelled => localization.azureLoginCancelled,
        MechanismError.error => localization.azureLoginError,
      },
      MechanismType.auth0 => switch (exception.error) {
        MechanismError.cancelled => localization.auth0LoginCancelled,
        MechanismError.error => localization.auth0LoginError,
      },
      _ => null,
    };
    if (message != null) CustomMessage.show(context, message);
  }
}
