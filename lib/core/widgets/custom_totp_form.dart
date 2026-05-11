import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_login_types/core/notifiers/generate_qr_notifier.dart';
import 'package:flutter_login_types/core/theme/colors.dart';
import 'package:flutter_login_types/core/widgets/custom_button.dart';
import 'package:flutter_login_types/l10n/l10n.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CustomTotpQrForm extends HookConsumerWidget {
  const CustomTotpQrForm({
    required this.secret,
    required this.account,
    required this.onConfirmSetup,
    super.key,
  });

  final String secret;
  final String account;
  final ValueSetter<String>? onConfirmSetup;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = context.localizations;

    final controller = useTextEditingController();
    final qrUri = ref.watch(
      generateQrProvider((secret: secret, account: account)),
    );

    return SingleChildScrollView(
      padding: const .symmetric(horizontal: 24),
      child: Column(
        children: <Widget>[
          const Gap(100),
          Text(
            localization.totpSetupTitle,
            textAlign: .center,
            style: const TextStyle(
              color: CustomColors.darkBlue,
              fontSize: 20,
              fontWeight: .bold,
            ),
          ),
          const Gap(12),
          Text(
            localization.totpSetupDescription,
            textAlign: .center,
            style: const TextStyle(color: CustomColors.darkBlue),
          ),
          const Gap(24),
          qrUri.maybeWhen(
            data: (data) => DecoratedBox(
              decoration: BoxDecoration(
                color: CustomColors.white,
                borderRadius: .circular(12),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const .all(12),
                child: QrImageView(
                  data: data,
                  size: 200,
                  backgroundColor: CustomColors.white,
                ),
              ),
            ),
            orElse: Offstage.new,
          ),
          const Gap(16),
          Text(
            localization.totpManualEntry,
            style: const TextStyle(color: CustomColors.darkBlue, fontSize: 13),
          ),
          const Gap(6),
          SelectableText(
            secret,
            textAlign: .center,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 13,
              color: CustomColors.darkBlue,
              letterSpacing: 2,
            ),
          ),
          const Gap(32),
          Text(
            localization.totpConfirmCodeTitle,
            textAlign: .center,
            style: const TextStyle(color: CustomColors.darkBlue, fontSize: 16),
          ),
          const Gap(16),
          Pinput(controller: controller, length: 6),
          const Gap(24),
          Row(
            children: <Widget>[
              Expanded(
                child: CustomButton(
                  text: localization.totpConfirmButton,
                  onPress: () {
                    final code = controller.text.trim();
                    if (code.length == 6) onConfirmSetup?.call(code);
                  },
                  backgroundColor: CustomColors.lightGreen,
                  foregroundColor: CustomColors.white,
                  icon: const Icon(
                    Icons.verified_outlined,
                    color: CustomColors.white,
                  ),
                  direction: .right,
                ),
              ),
            ],
          ),
          const Gap(32),
        ],
      ),
    );
  }
}

class CustomTotpVerifyForm extends HookWidget {
  const CustomTotpVerifyForm({required this.onCompleted, super.key});

  final ValueSetter<String>? onCompleted;

  @override
  Widget build(BuildContext context) {
    final localization = context.localizations;
    final controller = useTextEditingController();

    return Padding(
      padding: const .symmetric(horizontal: 24),
      child: Column(
        spacing: 50,
        mainAxisAlignment: .center,
        children: <Widget>[
          Column(
            spacing: 12,
            children: <Widget>[
              Text(
                localization.totpVerifyTitle,
                textAlign: .center,
                style: const TextStyle(
                  color: CustomColors.darkBlue,
                  fontSize: 20,
                ),
              ),
              Text(
                localization.totpVerifyDescription,
                textAlign: .center,
                style: const TextStyle(color: CustomColors.darkBlue),
              ),
            ],
          ),
          Pinput(controller: controller, length: 6, onCompleted: onCompleted),
        ],
      ),
    );
  }
}
