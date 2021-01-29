import 'package:flutter/material.dart';
import 'package:login_bloc/bloc/login_bloc.dart';
import 'package:login_bloc/ui/widgets/custom_button.dart';
import 'package:login_bloc/ui/widgets/custom_textfield.dart';
import 'package:login_bloc/ui/widgets/loading.dart';
import 'package:login_bloc/utils/colors.dart';

class LoginUI extends StatefulWidget {
  @override
  _LoginUIState createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _textEmailController = TextEditingController();
  final TextEditingController _textPasswordController = TextEditingController();

  final _bloc = LoginBloc();

  @override
  void dispose() {
    _textEmailController.dispose();
    _textPasswordController.dispose();

    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: true,
      body: StreamBuilder<bool>(
        stream: _bloc.isAuthenticated,
        builder: (_, AsyncSnapshot<bool> authSnapshot) {
          if (authSnapshot.hasData) {
            if (authSnapshot.data) {
              Future.delayed(Duration.zero,
                  () => Navigator.of(context).pushReplacementNamed('/home'));
            } else {
              Future.delayed(Duration(milliseconds: 100), _showSnackBar);
            }
          }

          return Stack(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        _setTextfieldEmail(),
                        SizedBox(height: 20),
                        _setTextfieldPassword(),
                        SizedBox(height: 20),
                        _setButton(),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 30,
                    left: 16,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
              StreamBuilder<bool>(
                stream: _bloc.isLoading,
                builder: (context, AsyncSnapshot<bool> snapshot) =>
                    (snapshot.hasData && snapshot.data)
                        ? Loading()
                        : Container(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _setTextfieldEmail() => StreamBuilder<String>(
        stream: _bloc.email,
        builder: (context, emailSnapshot) => CustomTextField(
          textController: _textEmailController,
          hint: 'Ingrese correo electrónico',
          isRequired: true,
          requiredMessage: 'El correo electrónico es requerido',
          onChange: _bloc.changeEmail,
          inputType: TextInputType.emailAddress,
          action: TextInputAction.next,
          errorText: emailSnapshot.error,
        ),
      );

  Widget _setTextfieldPassword() => StreamBuilder<String>(
        stream: _bloc.password,
        builder: (context, passwordSnapshot) => CustomTextField(
          hint: 'Ingrese la contraseña',
          isRequired: true,
          requiredMessage: 'La contraseña es requerida',
          onChange: _bloc.changePassword,
          errorText: passwordSnapshot.error,
          hasPassword: true,
          textController: _textPasswordController,
        ),
      );

  Widget _setButton() => StreamBuilder<bool>(
        stream: _bloc.isValidData,
        builder: (context, snapshot) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: CustomButton(
                  text: 'Iniciar sesión',
                  onPress: snapshot.hasData ? () => _bloc.authenticate() : null,
                  backgroundColor: CustomColors.lightGreen,
                  foregroundColor: CustomColors.white,
                  icon: Icon(Icons.send, color: CustomColors.white),
                  direction: IconDirection.right,
                ),
              ),
            ],
          ),
        ),
      );

  void _showSnackBar() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        'Usuario o contraseña incorrecta.',
        style: TextStyle(
          color: CustomColors.lightWhite,
        ),
      ),
      duration: Duration(seconds: 3),
    ));
  }
}
