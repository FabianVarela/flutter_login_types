import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_login_types/core/dependencies/dependencies.dart';
import 'package:flutter_login_types/core/theme/colors.dart';
import 'package:flutter_login_types/core/widgets/custom_button.dart';
import 'package:flutter_login_types/core/widgets/custom_message.dart';
import 'package:flutter_login_types/core/widgets/custom_textfield.dart';
import 'package:flutter_login_types/core/widgets/loading.dart';
import 'package:flutter_login_types/features/passcode_login/dependency.dart';
import 'package:flutter_login_types/features/passcode_login/forms/passcode_login_form.dart';
import 'package:flutter_login_types/features/passcode_login/forms/passcode_login_form_notifier.dart';
import 'package:flutter_login_types/features/passcode_login/notifier/passcode_login_state.dart';
import 'package:flutter_login_types/l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pinput/pinput.dart';

class PasscodeLoginView extends HookConsumerWidget {
  const PasscodeLoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = context.localizations;

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

    ref.listen(passcodeLoginNotifierProvider, (_, next) async {
      if (next.isSuccess) {
        if (next.phaseSuccess == PasscodeLoginPhase.passcode) {
          context.go('/home');
        } else if (next.phaseSuccess == PasscodeLoginPhase.phone) {
          pageValue.value = 1;
          await ref.read(notificationServiceProvider).showNotification(
                localization.notificationTitle,
                localization.notificationMessage('0000'),
              );
        }
      } else if (next.isError) {
        if (next.phaseError == PasscodeLoginPhase.passcode) {
          CustomMessage.show(context, localization.passcodeIncorrect);
        } else if (next.phaseError == PasscodeLoginPhase.phone) {
          CustomMessage.show(context, localization.phoneNumberIncorrect);
        }
      }
    });

    return PopScope(
      canPop: pageValue.value == 0,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        pageValue.value = 0;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
        ),
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        backgroundColor: CustomColors.white,
        body: Stack(
          children: <Widget>[
            PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const <Widget>[_PhoneForm(), _PasscodeForm()],
            ),
            if (passcodeState.isLoading) const Loading(),
          ],
        ),
      ),
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

    useEffect(
      () {
        controller.value = controller.value.copyWith(text: phoneInput.value);
        return null;
      },
      const [],
    );

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
          const SizedBox(height: 50),
          CustomTextField(
            textController: controller,
            hint: localization.phoneNumberPlaceholder,
            isRequired: true,
            requiredMessage: localization.phoneNumberRequired,
            onChange: (value) => ref
                .read(passcodeFormNotifierProvider.notifier)
                .onChangePhone(value),
            inputType: TextInputType.phone,
            errorText: phoneError == null
                ? null
                : phoneError == PhoneInputValidation.empty
                    ? localization.emptyValidation
                    : localization.numberValidation,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: CustomButton(
                    text: localization.verifyButtonText,
                    onPress: isFormValid
                        ? () => ref
                            .read(passcodeLoginNotifierProvider.notifier)
                            .verifyPhone(phoneInput.value)
                        : null,
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
    final localization = context.localizations;
    final controller = useTextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            localization.passcodeTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: CustomColors.darkBlue, fontSize: 20),
          ),
          const SizedBox(height: 50),
          Pinput(
            controller: controller,
            onCompleted: (value) => ref
                .read(passcodeLoginNotifierProvider.notifier)
                .verifyCode(value),
          ),
        ],
      ),
    );
  }
}
