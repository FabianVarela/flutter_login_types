import 'package:flutter/material.dart';
import 'package:login_bloc/bloc/login_bloc.dart';
import 'package:login_bloc/ui/home_page_ui.dart';

class LoginUI extends StatefulWidget {
  @override
  _LoginUIState createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  final bloc = LoginBloc();

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: bloc.isAuthenticated,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data) {
          return HomePageUI();
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text("Login with BLoC"),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        StreamBuilder<String>(
                          stream: bloc.email,
                          builder: (context, snapshot) => TextField(
                                onChanged: bloc.changeEmail,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Enter email",
                                  labelText: "Email",
                                  errorText: snapshot.error,
                                ),
                              ),
                        ),
                        SizedBox(height: 20),
                        StreamBuilder<String>(
                          stream: bloc.password,
                          builder: (context, snapshot) => TextField(
                                onChanged: bloc.changePassword,
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Enter password",
                                  labelText: "Password",
                                  errorText: snapshot.error,
                                ),
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
                                      child: Text("Submit"),
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
              ),
            ),
          );
        }
      },
    );
  }
}
