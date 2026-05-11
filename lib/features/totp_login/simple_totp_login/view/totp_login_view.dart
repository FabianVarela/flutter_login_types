import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_login_types/core/enum/login_type.dart';
import 'package:flutter_login_types/core/notifiers/session/session_notifier.dart';
import 'package:flutter_login_types/core/theme/colors.dart';
import 'package:flutter_login_types/core/widgets/custom_message.dart';
import 'package:flutter_login_types/core/widgets/custom_totp_form.dart';
import 'package:flutter_login_types/core/widgets/loading.dart';
import 'package:flutter_login_types/features/totp_login/simple_totp_login/notifier/totp_login_notifier.dart';
import 'package:flutter_login_types/l10n/l10n.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TotpLoginView extends HookConsumerWidget {
  const TotpLoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();
    final pageValue = useState(0);

    final totpState = ref.watch(totpLoginNotifierProvider);

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

    ref.listen(totpLoginNotifierProvider, (_, state) {
      state.whenOrNull(
        data: (data) {
          if (data.phase == .verify && data.token == null) {
            pageValue.value = 1;
          } else if (data.token != null) {
            final notifier = ref.read(sessionNotifierProvider.notifier);
            final args = (token: data.token!, loginType: LoginType.totp);

            unawaited(notifier.setSession(sessionArgs: args));
          }
        },
        error: (_, _) {
          final message = switch (pageValue.value) {
            0 => context.localizations.totpSetupError,
            1 => context.localizations.totpVerifyError,
            _ => null,
          };
          if (message != null) CustomMessage.show(context, message);
        },
      );
    });

    return PopScope(
      canPop: pageValue.value == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          pageValue.value = 0;
          ref.read(totpLoginNotifierProvider.notifier).restore();
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
                CustomTotpQrForm(
                  secret: totpState.value?.secret ?? '',
                  account: 'demo@flutter.dev',
                  onConfirmSetup: (value) => unawaited(
                    ref
                        .read(totpLoginNotifierProvider.notifier)
                        .confirmSetup(code: value),
                  ),
                ),
                CustomTotpVerifyForm(
                  onCompleted: (value) => unawaited(
                    ref
                        .read(totpLoginNotifierProvider.notifier)
                        .authenticate(code: value),
                  ),
                ),
              ],
            ),
          ),
          if (totpState.isLoading) const Loading(),
        ],
      ),
    );
  }
}
