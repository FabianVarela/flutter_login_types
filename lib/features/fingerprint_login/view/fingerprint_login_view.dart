import 'package:flutter/material.dart';
import 'package:flutter_login_types/core/router/app_route_path.dart';
import 'package:flutter_login_types/core/theme/colors.dart';
import 'package:flutter_login_types/core/widgets/custom_button.dart';
import 'package:flutter_login_types/core/widgets/custom_message.dart';
import 'package:flutter_login_types/core/widgets/loading.dart';
import 'package:flutter_login_types/features/fingerprint_login/notifier/fingerprint_login_notifier.dart';
import 'package:flutter_login_types/l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FingerPrintLoginView extends HookConsumerWidget {
  const FingerPrintLoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = context.localizations;

    final hasBiometric = ref.watch(hasBiometricProvider);
    final localAuth = ref.watch(localAuthNotifierProvider);

    ref.listen(localAuthNotifierProvider, (_, state) {
      state.whenOrNull(
        data: (data) {
          if (data == LocalAuthOption.granted) {
            context.go(AppRoutePath.home.path);
          } else if (data == LocalAuthOption.denied) {
            CustomMessage.show(context, localization.biometricError);
          }
        },
      );
    });

    return Scaffold(
      appBar: AppBar(),
      backgroundColor: CustomColors.white,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: hasBiometric.when(
              data: (data) => data
                  ? const _BiometricBody()
                  : _TextMessage(
                      message: localization.biometricNoSupportedText,
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => _TextMessage(
                message: localization.biometricNoSupportedText,
              ),
            ),
          ),
          if (localAuth.isLoading) const Loading(),
        ],
      ),
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          localization.biometricTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(color: CustomColors.darkBlue, fontSize: 20),
        ),
        const SizedBox(height: 30),
        biometricList.when(
          data: (data) => data.isNotEmpty
              ? CustomButton(
                  text: localization.biometricButtonText,
                  onPress: () => ref
                      .read(localAuthNotifierProvider.notifier)
                      .authenticate(localization.biometricReason),
                  backgroundColor: CustomColors.darkPurple,
                  foregroundColor: CustomColors.white,
                )
              : _TextMessage(message: localization.biometricEnabledText),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => _TextMessage(
            message: localization.biometricEnabledText,
          ),
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
        textAlign: TextAlign.center,
        style: const TextStyle(color: CustomColors.darkBlue, fontSize: 25),
      ),
    );
  }
}
