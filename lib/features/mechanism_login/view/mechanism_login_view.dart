import 'package:flutter/material.dart';
import 'package:flutter_login_types/core/notifiers/language_notifier.dart';
import 'package:flutter_login_types/core/theme/colors.dart';
import 'package:flutter_login_types/core/widgets/custom_button.dart';
import 'package:flutter_login_types/core/widgets/custom_message.dart';
import 'package:flutter_login_types/features/mechanism_login/dependency.dart';
import 'package:flutter_login_types/features/mechanism_login/notifier/mechanism_login_state.dart';
import 'package:flutter_login_types/l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MechanismLoginView extends HookConsumerWidget {
  const MechanismLoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = context.localizations;
    final language = ref.watch(
      languageNotifierProvider.select((value) => value.value),
    );

    ref.listen(mechanismLoginNotifierProvider, (_, next) {
      if (next.isSuccess) {
        context.go('/home');
      } else if (next.isError) {
        final message = switch (next.mechanismType) {
          MechanismType.azure => localization.azureLoginError,
          MechanismType.auth0 => localization.auth0LoginError,
        };
        CustomMessage.show(context, message);
      }
    });

    return Scaffold(
      appBar: AppBar(),
      backgroundColor: CustomColors.white,
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomButton(
              text: localization.signInText(localization.signInAzureAd),
              onPress: () => ref
                  .read(mechanismLoginNotifierProvider.notifier)
                  .authenticateAzure(lang: language?.languageCode),
              backgroundColor: CustomColors.kingBlue,
              foregroundColor: CustomColors.white,
              icon: const Icon(Icons.window, color: CustomColors.white),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: localization.signInText(localization.signInAuth0),
              onPress: () => ref
                  .read(mechanismLoginNotifierProvider.notifier)
                  .authenticateAuth0(),
              backgroundColor: CustomColors.lightRed,
              foregroundColor: CustomColors.white,
              icon: const Icon(Icons.star, color: CustomColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
