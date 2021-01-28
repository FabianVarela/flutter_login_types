import 'package:flutter/material.dart';
import 'package:login_bloc/bloc/login_bloc.dart';
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

  final bloc = LoginBloc();

  @override
  void dispose() {
    _textEmailController.dispose();
    _textPasswordController.dispose();

    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: true,
      body: StreamBuilder<bool>(
        stream: bloc.isAuthenticated,
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
              StreamBuilder<bool>(
                stream: bloc.isLoading,
                builder: (context, AsyncSnapshot<bool> snapshot) =>
                    (snapshot.hasData && snapshot.data)
                        ? Loading()
                        : Container(),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _setTextfieldEmail() => StreamBuilder<String>(
        stream: bloc.email,
        builder: (context, emailSnapshot) => CustomTextField(
          textController: _textEmailController,
          hint: 'Enter email',
          isRequired: true,
          requiredMessage: 'The email is required',
          onChange: bloc.changeEmail,
          inputType: TextInputType.emailAddress,
          action: TextInputAction.next,
          errorText: emailSnapshot.error,
        ),
      );

  Widget _setTextfieldPassword() => StreamBuilder<String>(
        stream: bloc.password,
        builder: (context, passwordSnapshot) => CustomTextField(
          hint: 'Enter password',
          isRequired: true,
          requiredMessage: 'The password is required',
          onChange: bloc.changePassword,
          errorText: passwordSnapshot.error,
          hasPassword: true,
          textController: _textPasswordController,
        ),
      );

  Widget _setButton() => StreamBuilder<bool>(
        stream: bloc.isValidData,
        builder: (context, snapshot) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: RaisedButton(
                  color: CustomColors.lightGreen,
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      color: CustomColors.white,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  onPressed:
                      snapshot.hasData ? () => bloc.authenticate() : null,
                ),
              ),
            ],
          ),
        ),
      );

  void _showSnackBar() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        'User or password incorrect.',
        style: TextStyle(
          color: CustomColors.lightWhite,
        ),
      ),
      duration: Duration(seconds: 3),
    ));
  }
}
