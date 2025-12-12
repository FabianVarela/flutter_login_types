import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_login_types/core/notifiers/session/session_notifier.dart';
import 'package:flutter_login_types/core/theme/colors.dart';
import 'package:flutter_login_types/core/widgets/custom_button.dart';
import 'package:flutter_login_types/core/widgets/custom_message.dart';
import 'package:flutter_login_types/core/widgets/custom_textfield.dart';
import 'package:flutter_login_types/core/widgets/loading.dart';
import 'package:flutter_login_types/features/simple_login/forms/simple_login_form.dart';
import 'package:flutter_login_types/features/simple_login/forms/simple_login_form_notifier.dart';
import 'package:flutter_login_types/features/simple_login/notifier/simple_login_notifier.dart';
import 'package:flutter_login_types/l10n/l10n.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SimpleLoginView extends ConsumerWidget {
  const SimpleLoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(simpleLoginNotifierProvider);

    ref.listen(simpleLoginNotifierProvider, (_, state) {
      state.whenOrNull(
        data: (data) {
          if (data != null) {
            final notifier = ref.read(sessionNotifierProvider.notifier);
            unawaited(notifier.setSession(session: data.token));
          }
        },
        error: (_, _) {
          CustomMessage.show(
            context,
            context.localizations.userPasswordIncorrectMessage,
          );
        },
      );
    });

    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(),
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: true,
          backgroundColor: CustomColors.white,
          body: Container(
            padding: const EdgeInsets.all(16),
            child: const Column(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _TextFieldEmail(),
                _TextFieldPassword(),
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
    final emailError = emailInput.isNotValid ? emailInput.error : null;

    useEffect(() {
      controller.value = controller.value.copyWith(text: emailInput.value);
      return null;
    }, const []);

    return CustomTextField(
      textController: controller,
      hint: localization.emailPlaceholder,
      isRequired: true,
      requiredMessage: localization.emailRequiredMessage,
      onChange: (value) {
        ref
            .read(loginFormNotifierProvider.notifier)
            .onChangeEmail(value: value);
      },
      inputType: TextInputType.emailAddress,
      action: TextInputAction.next,
      errorText: switch (emailError) {
        EmailInputValidator.empty => localization.emptyValidation,
        EmailInputValidator.invalid => localization.emailValidation,
        _ => null,
      },
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
    final passwordError = passwordInput.isNotValid ? passwordInput.error : null;

    useEffect(() {
      controller.value = controller.value.copyWith(text: passwordInput.value);
      return null;
    }, const []);

    return CustomTextField(
      textController: controller,
      hint: localization.passwordPlaceholder,
      isRequired: true,
      requiredMessage: localization.passwordRequiredMessage,
      onChange: (value) {
        ref
            .read(loginFormNotifierProvider.notifier)
            .onChangePassword(value: value);
      },
      errorText: switch (passwordError) {
        PasswordInputValidator.empty => localization.emptyValidation,
        PasswordInputValidator.invalid => localization.passwordValidation,
        _ => null,
      },
      hasPassword: true,
    );
  }
}

class _SubmitButton extends ConsumerWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFormValid = ref.watch(
      loginFormNotifierProvider.select((form) => form.isValid),
    );

    final (email, password) = ref.watch(
      loginFormNotifierProvider.select(
        (form) => (form.emailInput.value, form.passwordInput.value),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: <Widget>[
          Expanded(
            child: CustomButton(
              text: context.localizations.signInButton,
              onPress: switch (isFormValid) {
                true => () => unawaited(
                  ref
                      .read(simpleLoginNotifierProvider.notifier)
                      .authenticate(email: email, password: password),
                ),
                false => null,
              },
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
