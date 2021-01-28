import 'package:flutter/material.dart';
import 'package:login_bloc/bloc/login_bloc.dart';
import 'package:login_bloc/ui/custom_textfield.dart';

class LoginUI extends StatefulWidget {
  @override
  _LoginUIState createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _textEmailController = TextEditingController();
  final TextEditingController _textPasswordController = TextEditingController();

  final bloc = LoginBloc();

  bool isAuthenticated = false;

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
        builder: (_, authSnapshot) {
          if (authSnapshot.hasData && authSnapshot.data) {
            Future.delayed(Duration.zero, () {
              Navigator.of(context).pushReplacementNamed('/home');
            });
          }

          isAuthenticated = (authSnapshot.hasData && !authSnapshot.data);
          Future.delayed(Duration(milliseconds: 100), _showSnackBar);

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
                    StreamBuilder<String>(
                      stream: bloc.email,
                      builder: (context, emailSnapshot) => CustomTextField(
                        label: 'Email',
                        textController: _textEmailController,
                        hint: 'Enter email',
                        isRequired: true,
                        requiredMessage: 'The email is required',
                        onChange: bloc.changeEmail,
                        inputType: TextInputType.emailAddress,
                        errorText: emailSnapshot.error,
                      ),
                    ),
                    SizedBox(height: 20),
                    StreamBuilder<String>(
                      stream: bloc.password,
                      builder: (context, passwordSnapshot) => CustomTextField(
                        label: 'Password',
                        hint: 'Enter password',
                        isRequired: true,
                        requiredMessage: 'The password is required',
                        onChange: bloc.changePassword,
                        errorText: passwordSnapshot.error,
                        hasPassword: true,
                        textController: _textPasswordController,
                      ),
                    ),
                    SizedBox(height: 20),
                    StreamBuilder<bool>(
                      stream: bloc.isValidData,
                      builder: (context, snapshot) => Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: RaisedButton(
                              color: Colors.tealAccent,
                              child: Text('Submit'),
                              onPressed: snapshot.hasData
                                  ? () => bloc.authenticate()
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<bool>(
                stream: bloc.isLoading,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.grey.withOpacity(.7),
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.green,
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              )
            ],
          );
        },
      ),
    );
  }

  void _showSnackBar() {
    if (isAuthenticated) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('User or password incorrect.'),
        duration: Duration(seconds: 3),
      ));
    }
  }
}
