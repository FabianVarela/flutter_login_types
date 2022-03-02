import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:login_bloc/bloc/login_bloc.dart';
import 'package:login_bloc/common/message_service.dart';
import 'package:login_bloc/common/model/text_field_validator.dart';
import 'package:login_bloc/common/routes.dart';
import 'package:login_bloc/common/utils.dart';
import 'package:login_bloc/ui/common/colors.dart';
import 'package:login_bloc/ui/widgets/custom_button.dart';
import 'package:login_bloc/ui/widgets/custom_textfield.dart';
import 'package:login_bloc/ui/widgets/loading.dart';

class LoginUI extends HookWidget {
  const LoginUI({Key? key}) : super(key: key);

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
                  onGoToScreen: () => _goToHomeScreen(context),
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

  Future<void> _goToHomeScreen(BuildContext context) => Navigator.of(context)
      .pushNamedAndRemoveUntil(Routes.home, (Route<dynamic> route) => false);
}

class _TextFieldEmail extends HookWidget {
  const _TextFieldEmail({Key? key, required this.bloc}) : super(key: key);

  final LoginBloc bloc;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

    return StreamBuilder<TextFieldValidator>(
      stream: bloc.emailStream,
      builder: (_, snapshot) {
        final localizations = AppLocalizations.of(context)!;

        controller.value = controller.value.copyWith(text: bloc.email ?? '');

        return CustomTextField(
          textController: controller,
          hint: localizations.emailPlaceholder,
          isRequired: true,
          requiredMessage: localizations.emailRequiredMessage,
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
  const _TextFieldPassword({Key? key, required this.bloc}) : super(key: key);

  final LoginBloc bloc;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

    return StreamBuilder<TextFieldValidator>(
      stream: bloc.passwordStream,
      builder: (_, snapshot) {
        final localizations = AppLocalizations.of(context)!;

        controller.value = controller.value.copyWith(text: bloc.password ?? '');

        return CustomTextField(
          textController: controller,
          hint: localizations.passwordPlaceholder,
          isRequired: true,
          requiredMessage: localizations.passwordRequiredMessage,
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
    Key? key,
    required this.bloc,
    required this.onSendMessage,
    required this.onGoToScreen,
  }) : super(key: key);

  final LoginBloc bloc;
  final ValueSetter<String> onSendMessage;
  final VoidCallback onGoToScreen;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: bloc.isValidData,
      builder: (_, isValidSnapshot) {
        final localizations = AppLocalizations.of(context)!;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: <Widget>[
              Expanded(
                child: CustomButton(
                  text: localizations.signInButton,
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
    final localizations = AppLocalizations.of(context)!;

    final result = await bloc.authenticate();
    if (result) {
      onGoToScreen();
    } else {
      onSendMessage(localizations.userPasswordIncorrectMessage);
    }
  }
}
