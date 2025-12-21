import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_login_types/core/notifiers/session/session_notifier.dart';
import 'package:flutter_login_types/core/theme/colors.dart';
import 'package:flutter_login_types/core/widgets/custom_button.dart';
import 'package:flutter_login_types/core/widgets/custom_message.dart';
import 'package:flutter_login_types/core/widgets/loading.dart';
import 'package:flutter_login_types/features/fingerprint_login/notifier/fingerprint_login_notifier.dart';
import 'package:flutter_login_types/l10n/l10n.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FingerPrintLoginView extends HookConsumerWidget {
  const FingerPrintLoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = context.localizations;

    final hasBiometric = ref.watch(hasBiometricProvider);
    final localAuthState = ref.watch(localAuthNotifierProvider);

    ref.listen(localAuthNotifierProvider, (_, state) {
      state.whenOrNull(
        data: (data) {
          if (data.option == .granted) {
            final notifier = ref.read(sessionNotifierProvider.notifier);
            unawaited(notifier.setSession(session: data.token!));
          } else if (data.option == .denied) {
            CustomMessage.show(context, localization.biometricError);
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
          body: Padding(
            padding: const .symmetric(horizontal: 24),
            child: hasBiometric.when(
              data: (data) {
                return switch (data) {
                  true => const _BiometricBody(),
                  false => _TextMessage(
                    message: localization.biometricNoSupportedText,
                  ),
                };
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) {
                return _TextMessage(
                  message: localization.biometricNoSupportedText,
                );
              },
            ),
          ),
        ),
        if (localAuthState.isLoading) const Loading(),
      ],
    );
  }
}

class _BiometricBody extends ConsumerWidget {
  const _BiometricBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = context.localizations;
    final biometricList = ref.watch(listBiometricProvider);

    return Column(
      mainAxisAlignment: .center,
      crossAxisAlignment: .stretch,
      children: <Widget>[
        Text(
          localization.biometricTitle,
          textAlign: .center,
          style: const TextStyle(color: CustomColors.darkBlue, fontSize: 20),
        ),
        const Gap(30),
        biometricList.when(
          data: (data) {
            if (data.isEmpty) {
              _TextMessage(message: localization.biometricEnabledText);
            }

            return CustomButton(
              text: localization.biometricButtonText,
              onPress: () {
                final notifier = ref.read(localAuthNotifierProvider.notifier);
                unawaited(
                  notifier.authenticate(reason: localization.biometricReason),
                );
              },
              backgroundColor: CustomColors.darkPurple,
              foregroundColor: CustomColors.white,
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) {
            return _TextMessage(message: localization.biometricEnabledText);
          },
        ),
      ],
    );
  }
}

class _TextMessage extends StatelessWidget {
  const _TextMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        textAlign: .center,
        style: const TextStyle(color: CustomColors.darkBlue, fontSize: 25),
      ),
    );
  }
}
