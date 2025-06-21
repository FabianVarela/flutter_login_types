import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_login_types/core/dependencies/dependencies.dart';
import 'package:flutter_login_types/core/notifiers/session/session_notifier.dart';
import 'package:flutter_login_types/core/theme/colors.dart';
import 'package:flutter_login_types/core/widgets/custom_button.dart';
import 'package:flutter_login_types/core/widgets/custom_message.dart';
import 'package:flutter_login_types/core/widgets/custom_textfield.dart';
import 'package:flutter_login_types/core/widgets/loading.dart';
import 'package:flutter_login_types/features/passcode_login/forms/passcode_login_form.dart';
import 'package:flutter_login_types/features/passcode_login/forms/passcode_login_form_notifier.dart';
import 'package:flutter_login_types/features/passcode_login/notifier/passcode_login_notifier.dart';
import 'package:flutter_login_types/l10n/l10n.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pinput/pinput.dart';

class PasscodeLoginView extends HookConsumerWidget {
  const PasscodeLoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();
    final pageValue = useState(0);

    final passcodeState = ref.watch(passcodeLoginNotifierProvider);

    if (pageController.hasClients) {
      if (pageController.page!.round() != pageValue.value) {
        pageController.animateToPage(
          pageValue.value,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 400),
        );
      }
    }

    ref.listen(passcodeLoginNotifierProvider, (_, state) {
      state.whenOrNull(
        data: (data) {
          if (data.mode == PasscodeMode.phone) {
            pageValue.value = 1;
            _sendNotification(context, ref);
          } else if (data.mode == PasscodeMode.passcode) {
            ref
                .read(sessionNotifierProvider.notifier)
                .setSession(session: data.token!);
          }
        },
        error: (_, _) {
          final message = switch (pageValue.value) {
            0 => context.localizations.phoneNumberIncorrect,
            1 => context.localizations.passcodeIncorrect,
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
          ref.read(passcodeLoginNotifierProvider.notifier).restore();
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
              children: const <Widget>[_PhoneForm(), _PasscodeForm()],
            ),
          ),
          if (passcodeState.isLoading) const Loading(),
        ],
      ),
    );
  }

  Future<void> _sendNotification(BuildContext context, WidgetRef ref) async {
    final notification = ref.read(notificationServiceProvider);
    await notification.showNotification(
      title: context.localizations.notificationTitle,
      body: context.localizations.notificationMessage('0000'),
    );
  }
}

class _PhoneForm extends HookConsumerWidget {
  const _PhoneForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = context.localizations;
    final controller = useTextEditingController();

    final isFormValid = ref.watch(
      passcodeFormNotifierProvider.select((f) => f.isValid),
    );

    final phoneInput = ref.watch(
      passcodeFormNotifierProvider.select((form) => form.phoneInput),
    );
    final phoneError = phoneInput.isNotValid ? phoneInput.error : null;

    useEffect(() {
      controller.value = controller.value.copyWith(text: phoneInput.value);
      return null;
    }, const []);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            localization.phoneNumberTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: CustomColors.darkBlue, fontSize: 20),
          ),
          const Gap(50),
          CustomTextField(
            textController: controller,
            hint: localization.phoneNumberPlaceholder,
            isRequired: true,
            requiredMessage: localization.phoneNumberRequired,
            onChange: (value) {
              ref
                  .read(passcodeFormNotifierProvider.notifier)
                  .onChangePhone(value: value);
            },
            inputType: TextInputType.phone,
            errorText: switch (phoneError) {
              PhoneInputValidation.empty => localization.emptyValidation,
              PhoneInputValidation.invalid => localization.numberValidation,
              _ => null,
            },
          ),
          const Gap(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: CustomButton(
                    text: localization.verifyButtonText,
                    onPress: switch (isFormValid) {
                      true => () {
                        ref
                            .read(passcodeLoginNotifierProvider.notifier)
                            .verifyPhone(phoneNumber: phoneInput.value);
                      },
                      false => null,
                    },
                    backgroundColor: CustomColors.lightGreen,
                    foregroundColor: CustomColors.white,
                    icon: const Icon(
                      Icons.verified_outlined,
                      color: CustomColors.white,
                    ),
                    direction: IconDirection.right,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PasscodeForm extends HookConsumerWidget {
  const _PasscodeForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            context.localizations.passcodeTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: CustomColors.darkBlue, fontSize: 20),
          ),
          const Gap(50),
          Pinput(
            controller: controller,
            onCompleted: (value) {
              ref
                  .read(passcodeLoginNotifierProvider.notifier)
                  .verifyCode(passcode: value);
            },
          ),
        ],
      ),
    );
  }
}
