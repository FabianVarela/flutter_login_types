import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_login_types/common/message_service.dart';
import 'package:flutter_login_types/core/widgets/custom_button.dart';
import 'package:flutter_login_types/core/widgets/custom_textfield.dart';
import 'package:flutter_login_types/core/widgets/loading.dart';
import 'package:flutter_login_types/features/simple_login/dependency.dart';
import 'package:flutter_login_types/features/simple_login/forms/simple_login_form.dart';
import 'package:flutter_login_types/features/simple_login/forms/simple_login_form_notifier.dart';
import 'package:flutter_login_types/features/simple_login/notifier/simple_login_state.dart';
import 'package:flutter_login_types/l10n/l10n.dart';
import 'package:flutter_login_types/ui/common/colors.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SimpleLoginView extends ConsumerWidget {
  const SimpleLoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(simpleLoginNotifierProvider);

    ref.listen(simpleLoginNotifierProvider, (_, next) {
      if (next.isSuccess) {
        context.go('/home');
      } else if (next.isError) {
        MessageService.getInstance().showMessage(
          context,
          context.localizations.userPasswordIncorrectMessage,
        );
      }
    });

    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
          ),
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: true,
          backgroundColor: CustomColors.white,
          body: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                _TextFieldEmail(),
                SizedBox(height: 20),
                _TextFieldPassword(),
                SizedBox(height: 20),
                _SubmitButton(),
              ],
            ),
          ),
        ),
        if (loginState.isLoading) const Loading(),
      ],
    );
  }
}

class _TextFieldEmail extends HookConsumerWidget {
  const _TextFieldEmail();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = context.localizations;
    final controller = useTextEditingController();

    final emailInput = ref.watch(
      loginFormNotifierProvider.select((form) => form.emailInput),
    );
    final emailError = emailInput.invalid ? emailInput.error : null;

    useEffect(
      () {
        controller.value = controller.value.copyWith(text: emailInput.value);
        return null;
      },
      const [],
    );

    return CustomTextField(
      textController: controller,
      hint: localization.emailPlaceholder,
      isRequired: true,
      requiredMessage: localization.emailRequiredMessage,
      onChange: (value) {
        ref.read(loginFormNotifierProvider.notifier).onChangeEmail(value);
      },
      inputType: TextInputType.emailAddress,
      action: TextInputAction.next,
      errorText: emailError == null
          ? null
          : emailError == EmailInputValidator.empty
              ? localization.emptyValidation
              : localization.emailValidation,
    );
  }
}

class _TextFieldPassword extends HookConsumerWidget {
  const _TextFieldPassword();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = context.localizations;
    final controller = useTextEditingController();

    final passwordInput = ref.watch(
      loginFormNotifierProvider.select((form) => form.passwordInput),
    );
    final passwordError = passwordInput.invalid ? passwordInput.error : null;

    useEffect(
      () {
        controller.value = controller.value.copyWith(text: passwordInput.value);
        return null;
      },
      const [],
    );

    return CustomTextField(
      textController: controller,
      hint: localization.passwordPlaceholder,
      isRequired: true,
      requiredMessage: localization.passwordRequiredMessage,
      onChange: (value) {
        ref.read(loginFormNotifierProvider.notifier).onChangePassword(value);
      },
      errorText: passwordError == null
          ? null
          : passwordError == PasswordInputValidator.empty
              ? localization.emptyValidation
              : localization.passwordValidation,
      hasPassword: true,
    );
  }
}

class _SubmitButton extends ConsumerWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = context.localizations;
    final isFormValid = ref.watch(
      loginFormNotifierProvider.select((f) => f.status == FormzStatus.valid),
    );

    final emailValue = ref.watch(
      loginFormNotifierProvider.select((form) => form.emailInput.value),
    );
    final passwordValue = ref.watch(
      loginFormNotifierProvider.select((form) => form.passwordInput.value),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: <Widget>[
          Expanded(
            child: CustomButton(
              text: localization.signInButton,
              onPress: isFormValid
                  ? () => ref
                      .read(simpleLoginNotifierProvider.notifier)
                      .authenticate(emailValue, passwordValue)
                  : null,
              backgroundColor: CustomColors.lightGreen,
              foregroundColor: CustomColors.white,
              icon: const Icon(Icons.send, color: CustomColors.white),
              direction: IconDirection.right,
            ),
          ),
        ],
      ),
    );
  }
}
