import 'package:flutter/material.dart';
import 'package:login_bloc/bloc/passcode_bloc.dart';
import 'package:login_bloc/ui/widgets/custom_button.dart';
import 'package:login_bloc/ui/widgets/custom_textfield.dart';
import 'package:login_bloc/ui/widgets/loading.dart';
import 'package:login_bloc/utils/colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class LoginPasscodeUI extends StatefulWidget {
  @override
  _LoginPasscodeUIState createState() => _LoginPasscodeUIState();
}

class _LoginPasscodeUIState extends State<LoginPasscodeUI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  final _bloc = PasscodeBloc();

  int _currentPage = 0;

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _returnPageFromBar,
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: true,
        body: Stack(
          children: <Widget>[
            Stack(
              children: <Widget>[
                StreamBuilder<int>(
                  stream: _bloc.page,
                  builder: (_, AsyncSnapshot<int> pageSnapshot) {
                    if (_pageController.hasClients && pageSnapshot.hasData) {
                      _currentPage = pageSnapshot.data;

                      if (_pageController.page.round() != _currentPage) {
                        _goToPage(_currentPage);
                      }
                    }

                    return StreamBuilder<bool>(
                        stream: _bloc.isVerified,
                        builder: (_, AsyncSnapshot<bool> verifiedSnapshot) {
                          if (verifiedSnapshot.hasData) {
                            if (!verifiedSnapshot.data) {
                              Future.delayed(
                                Duration(milliseconds: 100),
                                () => _showSnackBar(
                                    'Número de teléfono incorrecto.'),
                              );
                            }
                          }

                          return StreamBuilder<bool>(
                              stream: _bloc.isAuthenticated,
                              builder: (_, AsyncSnapshot<bool> authSnapshot) {
                                if (authSnapshot.hasData) {
                                  if (authSnapshot.data) {
                                    Future.delayed(
                                        Duration.zero,
                                        () => Navigator.of(context)
                                            .pushReplacementNamed('/home'));
                                  } else {
                                    Future.delayed(
                                      Duration(milliseconds: 100),
                                      () => _showSnackBar(
                                          'Código de verificación incorrecto.'),
                                    );
                                  }
                                }

                                return PageView(
                                  controller: _pageController,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: <Widget>[
                                    FormPhone(bloc: _bloc),
                                    FormPasscode(bloc: _bloc),
                                  ],
                                );
                              });
                        });
                  },
                ),
                Positioned(
                  top: 30,
                  left: 16,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: _returnPage,
                  ),
                ),
              ],
            ),
            StreamBuilder<bool>(
              stream: _bloc.isLoading,
              builder: (context, AsyncSnapshot<bool> snapshot) =>
                  (snapshot.hasData && snapshot.data) ? Loading() : Container(),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _returnPageFromBar() {
    if (_currentPage == 0) {
      return Future<bool>.value(true);
    }

    _bloc.changePage(0);
    return Future<bool>.value(false);
  }

  void _returnPage() {
    if (_currentPage == 0) {
      Navigator.of(context).pop();
    } else {
      _bloc.changePage(0);
    }
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      curve: Curves.easeOut,
      duration: Duration(milliseconds: 400),
    );
  }

  void _showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: CustomColors.lightWhite,
        ),
      ),
      duration: Duration(seconds: 3),
    ));
  }
}

class FormPhone extends StatefulWidget {
  const FormPhone({Key key, @required this.bloc}) : super(key: key);

  final PasscodeBloc bloc;

  @override
  _FormPhoneState createState() => _FormPhoneState();
}

class _FormPhoneState extends State<FormPhone> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Digite el número de teléfono',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: CustomColors.darkBlue,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 50),
          StreamBuilder<String>(
            stream: widget.bloc.phone,
            builder: (context, emailSnapshot) => CustomTextField(
              textController: _phoneController,
              hint: 'Ingrese número telefónico',
              isRequired: true,
              requiredMessage: 'El número de teléfono es requerido',
              onChange: widget.bloc.changePhone,
              inputType: TextInputType.phone,
              errorText: emailSnapshot.error,
            ),
          ),
          const SizedBox(height: 20),
          StreamBuilder<bool>(
            stream: widget.bloc.isValidPhone,
            builder: (context, snapshot) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: CustomButton(
                      text: 'Verificar',
                      onPress: snapshot.hasData
                          ? () => widget.bloc.verifyPhone()
                          : null,
                      backgroundColor: CustomColors.lightGreen,
                      foregroundColor: CustomColors.white,
                      icon: Icon(Icons.verified_outlined,
                          color: CustomColors.white),
                      direction: IconDirection.right,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FormPasscode extends StatefulWidget {
  const FormPasscode({Key key, @required this.bloc}) : super(key: key);

  final PasscodeBloc bloc;

  @override
  _FormPasscodeState createState() => _FormPasscodeState();
}

class _FormPasscodeState extends State<FormPasscode> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Digite el código de verificación',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: CustomColors.darkBlue,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 50),
          PinCodeTextField(
            appContext: context,
            length: 4,
            obscureText: true,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 50,
              fieldWidth: 40,
              activeFillColor: Colors.white,
            ),
            animationDuration: Duration(milliseconds: 300),
            enableActiveFill: true,
            onCompleted: (_) => widget.bloc.verifyCode(),
            onChanged: (value) {
              print(value);
              widget.bloc.changeCode(value);
            },
          ),
        ],
      ),
    );
  }
}
