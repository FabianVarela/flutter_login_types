import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_login_types/core/enum/login_type.dart';
import 'package:flutter_login_types/core/notifiers/session/session_notifier.dart';
import 'package:flutter_login_types/core/theme/colors.dart';
import 'package:flutter_login_types/core/widgets/custom_button.dart';
import 'package:flutter_login_types/core/widgets/custom_message.dart';
import 'package:flutter_login_types/core/widgets/custom_totp_form.dart';
import 'package:flutter_login_types/core/widgets/loading.dart';
import 'package:flutter_login_types/features/totp_login/oauth_totp_login/notifier/oauth_totp_login_notifier.dart';
import 'package:flutter_login_types/l10n/l10n.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OauthTotpLoginView extends HookConsumerWidget {
  const OauthTotpLoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();
    final pageValue = useState(0);

    final oauthState = ref.watch(oauthTotpLoginNotifierProvider);

    if (pageController.hasClients) {
      if (pageController.page!.round() != pageValue.value) {
        unawaited(
          pageController.animateToPage(
            pageValue.value,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 400),
          ),
        );
      }
    }

    ref.listen(oauthTotpLoginNotifierProvider, (_, state) {
      state.whenOrNull(
        data: (data) {
          if (data.phase == .setup) {
            pageValue.value = 1;
          } else if (data.phase == .verify && data.token == null) {
            pageValue.value = 2;
          } else if (data.token != null) {
            final notifier = ref.read(sessionNotifierProvider.notifier);
            final args = (token: data.token!, loginType: LoginType.oauthTotp);

            unawaited(notifier.setSession(sessionArgs: args));
          }
        },
        error: (_, _) {
          final message = switch (pageValue.value) {
            1 => context.localizations.totpSetupError,
            2 => context.localizations.totpVerifyError,
            _ => context.localizations.oauthLoginError,
          };
          CustomMessage.show(context, message);
        },
      );
    });

    return PopScope(
      canPop: pageValue.value == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          pageValue.value = 0;
          ref.read(oauthTotpLoginNotifierProvider.notifier).restore();
        }
      },
      child: Stack(
        children: <Widget>[
          Scaffold(
            appBar: AppBar(),
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: true,
            backgroundColor: CustomColors.white,
            body: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                const _OAuthSignInForm(),
                CustomTotpQrForm(
                  secret: oauthState.value?.totpSecret ?? '',
                  account: 'Microsoft:${oauthState.value?.oauthUserId ?? ''}',
                  onConfirmSetup: (value) => unawaited(
                    ref
                        .read(oauthTotpLoginNotifierProvider.notifier)
                        .confirmSetup(code: value),
                  ),
                ),
                CustomTotpVerifyForm(
                  onCompleted: (value) => unawaited(
                    ref
                        .read(oauthTotpLoginNotifierProvider.notifier)
                        .authenticate(code: value),
                  ),
                ),
              ],
            ),
          ),
          if (oauthState.isLoading) const Loading(),
        ],
      ),
    );
  }
}

class _OAuthSignInForm extends ConsumerWidget {
  const _OAuthSignInForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = context.localizations;

    return Padding(
      padding: const .symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .stretch,
        children: <Widget>[
          CustomButton(
            text: localization.signInText(localization.signInOauth),
            onPress: () => unawaited(
              ref
                  .read(oauthTotpLoginNotifierProvider.notifier)
                  .signInWithOAuth(),
            ),
            backgroundColor: CustomColors.kingBlue,
            foregroundColor: CustomColors.white,
            icon: const Icon(Icons.window, color: CustomColors.white),
          ),
        ],
      ),
    );
  }
}
