import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_login_types/bloc/login_bloc.dart';
import 'package:flutter_login_types/common/message_service.dart';
import 'package:flutter_login_types/common/model/text_field_validator.dart';
import 'package:flutter_login_types/common/utils.dart';
import 'package:flutter_login_types/l10n/l10n.dart';
import 'package:flutter_login_types/ui/common/colors.dart';
import 'package:flutter_login_types/ui/widgets/custom_button.dart';
import 'package:flutter_login_types/ui/widgets/custom_textfield.dart';
import 'package:flutter_login_types/ui/widgets/loading.dart';
import 'package:go_router/go_router.dart';

class LoginUI extends HookWidget {
  const LoginUI({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(
      () {
        return loginBloc.dispose;
      },
      const [],
    );

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
              children: <Widget>[
                _TextFieldEmail(bloc: loginBloc),
                const SizedBox(height: 20),
                _TextFieldPassword(bloc: loginBloc),
                const SizedBox(height: 20),
                _SubmitButton(
                  bloc: loginBloc,
                  onSendMessage: (value) => _showSnackBar(context, value),
                  onGoToScreen: () => context.go('/home'),
                ),
              ],
            ),
          ),
        ),
        StreamBuilder<bool>(
          initialData: false,
          stream: loginBloc.isLoading,
          builder: (_, loadSnapshot) => Offstage(
            offstage: !loadSnapshot.data!,
            child: const Loading(),
          ),
        ),
      ],
    );
  }

  void _showSnackBar(BuildContext context, String message) => Future.delayed(
        const Duration(milliseconds: 100),
        () => MessageService.getInstance().showMessage(context, message),
      );
}

class _TextFieldEmail extends HookWidget {
  const _TextFieldEmail({required this.bloc});

  final LoginBloc bloc;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

    return StreamBuilder<TextFieldValidator>(
      stream: bloc.emailStream,
      builder: (_, snapshot) {
        final localization = context.localizations;

        controller.value = controller.value.copyWith(text: bloc.email ?? '');

        return CustomTextField(
          textController: controller,
          hint: localization.emailPlaceholder,
          isRequired: true,
          requiredMessage: localization.emailRequiredMessage,
          onChange: bloc.changeEmail,
          inputType: TextInputType.emailAddress,
          action: TextInputAction.next,
          errorText: snapshot.hasError
              ? Utils.getTextValidator(
                  context,
                  (snapshot.error as TextFieldValidator?)!.validator,
                )
              : null,
        );
      },
    );
  }
}

class _TextFieldPassword extends HookWidget {
  const _TextFieldPassword({required this.bloc});

  final LoginBloc bloc;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

    return StreamBuilder<TextFieldValidator>(
      stream: bloc.passwordStream,
      builder: (_, snapshot) {
        final localization = context.localizations;

        controller.value = controller.value.copyWith(text: bloc.password ?? '');

        return CustomTextField(
          textController: controller,
          hint: localization.passwordPlaceholder,
          isRequired: true,
          requiredMessage: localization.passwordRequiredMessage,
          onChange: bloc.changePassword,
          errorText: snapshot.hasError
              ? Utils.getTextValidator(
                  context,
                  (snapshot.error as TextFieldValidator?)!.validator,
                )
              : null,
          hasPassword: true,
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.bloc,
    required this.onSendMessage,
    required this.onGoToScreen,
  });

  final LoginBloc bloc;
  final ValueSetter<String> onSendMessage;
  final VoidCallback onGoToScreen;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: bloc.isValidData,
      builder: (_, isValidSnapshot) {
        final localization = context.localizations;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: <Widget>[
              Expanded(
                child: CustomButton(
                  text: localization.signInButton,
                  onPress: isValidSnapshot.hasData
                      ? () => _onPressButton(context)
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
      },
    );
  }

  Future<void> _onPressButton(BuildContext context) async {
    final localization = context.localizations;

    final result = await bloc.authenticate();
    if (result) {
      onGoToScreen();
    } else {
      onSendMessage(localization.userPasswordIncorrectMessage);
    }
  }
}
