import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:login_bloc/bloc/login_bloc.dart';
import 'package:login_bloc/common/message_service.dart';
import 'package:login_bloc/common/routes.dart';
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
  final TextEditingController _textEmailController = TextEditingController();
  final TextEditingController _textPasswordController = TextEditingController();

  final _loginBloc = LoginBloc();

  @override
  void dispose() {
    _textEmailController.dispose();
    _textPasswordController.dispose();

    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: CustomColors.white,
      body: StreamBuilder<bool>(
        stream: _loginBloc.isAuthenticated,
        builder: (_, authSnapshot) {
          if (authSnapshot.hasData) {
            if (authSnapshot.data!) {
              _goToScreen();
            } else {
              _showSnackBar(localizations.userPasswordIncorrectMessage);
            }
          }

          return Stack(
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
                        _setTextFieldEmail(),
                        const SizedBox(height: 20),
                        _setTextFieldPassword(),
                        const SizedBox(height: 20),
                        _setButton(),
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
                stream: _loginBloc.isLoading,
                builder: (_, loadSnapshot) =>
                    (loadSnapshot.hasData && loadSnapshot.data!)
                        ? const Loading()
                        : const Offstage(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _setTextFieldEmail() => StreamBuilder<String>(
      stream: _loginBloc.emailStream,
      builder: (context, emailSnapshot) {
        final localizations = AppLocalizations.of(context)!;

        _textEmailController.value =
            _textEmailController.value.copyWith(text: _loginBloc.email ?? '');

        return CustomTextField(
          textController: _textEmailController,
          hint: localizations.emailPlaceholder,
          isRequired: true,
          requiredMessage: localizations.emailRequiredMessage,
          onChange: _loginBloc.changeEmail,
          inputType: TextInputType.emailAddress,
          action: TextInputAction.next,
          errorText: emailSnapshot.error?.toString(),
        );
      });

  Widget _setTextFieldPassword() => StreamBuilder<String>(
        stream: _loginBloc.passwordStream,
        builder: (context, passwordSnapshot) {
          final localizations = AppLocalizations.of(context)!;

          _textPasswordController.value = _textPasswordController.value
              .copyWith(text: _loginBloc.password ?? '');

          return CustomTextField(
            textController: _textPasswordController,
            hint: localizations.passwordPlaceholder,
            isRequired: true,
            requiredMessage: localizations.passwordRequiredMessage,
            onChange: _loginBloc.changePassword,
            errorText: passwordSnapshot.error?.toString(),
            hasPassword: true,
          );
        },
      );

  Widget _setButton() => StreamBuilder<bool>(
        stream: _loginBloc.isValidData,
        builder: (context, isValidSnapshot) {
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
                        ? _loginBloc.authenticate
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

  void _goToScreen() => Future.delayed(
        Duration.zero,
        () => Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.home, (Route<dynamic> route) => false),
      );

  void _showSnackBar(String message) => Future.delayed(
        const Duration(milliseconds: 100),
        () => MessageService.getInstance().showMessage(context, message),
      );
}
