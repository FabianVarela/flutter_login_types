import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:login_bloc/bloc/login_bloc.dart';
import 'package:login_bloc/common/message_service.dart';
import 'package:login_bloc/common/model/text_field_validator.dart';
import 'package:login_bloc/common/routes.dart';
import 'package:login_bloc/common/utils.dart';
import 'package:login_bloc/ui/widgets/custom_button.dart';
import 'package:login_bloc/ui/widgets/custom_textfield.dart';
import 'package:login_bloc/ui/widgets/loading.dart';
import 'package:login_bloc/utils/colors.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({Key? key}) : super(key: key);

  @override
  _LoginUIState createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  final _loginBloc = LoginBloc();

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: CustomColors.white,
      body: Stack(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    TextFieldEmail(bloc: _loginBloc),
                    const SizedBox(height: 20),
                    TextFieldPassword(bloc: _loginBloc),
                    const SizedBox(height: 20),
                    SubmitButton(
                      bloc: _loginBloc,
                      onSendMessage: _showSnackBar,
                      onGoToScreen: _goToHomeScreen,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 30,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
          StreamBuilder<bool>(
            initialData: false,
            stream: _loginBloc.isLoading,
            builder: (_, loadSnapshot) => Offstage(
              offstage: !loadSnapshot.data!,
              child: const Loading(),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) => Future.delayed(
        const Duration(milliseconds: 100),
        () => MessageService.getInstance().showMessage(context, message),
      );

  Future<void> _goToHomeScreen() async => await Navigator.of(context)
      .pushNamedAndRemoveUntil(Routes.home, (Route<dynamic> route) => false);
}

class TextFieldEmail extends HookWidget {
  const TextFieldEmail({Key? key, required this.bloc}) : super(key: key);

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
                  context, (snapshot.error as TextFieldValidator).validator)
              : null,
        );
      },
    );
  }
}

class TextFieldPassword extends HookWidget {
  const TextFieldPassword({Key? key, required this.bloc}) : super(key: key);

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
                  context, (snapshot.error as TextFieldValidator).validator)
              : null,
          hasPassword: true,
        );
      },
    );
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({
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
                flex: 1,
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

  void _onPressButton(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;

    final result = await bloc.authenticate();
    if (result) {
      onGoToScreen();
    } else {
      onSendMessage(localizations.userPasswordIncorrectMessage);
    }
  }
}
