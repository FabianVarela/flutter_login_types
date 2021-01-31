import 'package:flutter/material.dart';
import 'package:login_bloc/bloc/passcode_bloc.dart';
import 'package:login_bloc/ui/widgets/custom_button.dart';
import 'package:login_bloc/ui/widgets/custom_textfield.dart';
import 'package:login_bloc/ui/widgets/loading.dart';
import 'package:login_bloc/utils/colors.dart';
import 'package:pinput/pin_put/pin_put.dart';

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

  final _passcodeBloc = PasscodeBloc();

  @override
  void dispose() {
    _passcodeBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _returnPageFromBar,
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: true,
        backgroundColor: CustomColors.white,
        body: Stack(
          children: <Widget>[
            Stack(
              children: <Widget>[
                StreamBuilder<int>(
                  initialData: 0,
                  stream: _passcodeBloc.pageStream,
                  builder: (_, AsyncSnapshot<int> pageSnapshot) {
                    if (_pageController.hasClients && pageSnapshot.hasData) {
                      if (_pageController.page.round() != _passcodeBloc.page) {
                        _goToPage(_passcodeBloc.page);
                      }
                    }

                    return StreamBuilder<PasscodeStatus>(
                      stream: _passcodeBloc.passcodeStatusStream,
                      builder: (_, AsyncSnapshot<PasscodeStatus> status) {
                        if (status.hasData) {
                          switch (status.data) {
                            case PasscodeStatus.verifiedError:
                              _showSnackBar(
                                'Número de teléfono incorrecto.',
                              );
                              break;
                            case PasscodeStatus.authenticated:
                              _goToScreen();
                              break;
                            case PasscodeStatus.authenticatedError:
                              _showSnackBar(
                                'Código de verificación incorrecto.',
                              );
                              break;
                            default:
                          }
                        }

                        return PageView(
                          controller: _pageController,
                          physics: NeverScrollableScrollPhysics(),
                          children: <Widget>[
                            FormPhone(bloc: _passcodeBloc),
                            FormPasscode(bloc: _passcodeBloc),
                          ],
                        );
                      },
                    );
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
              stream: _passcodeBloc.isLoading,
              builder: (context, AsyncSnapshot<bool> snapshot) =>
                  (snapshot.hasData && snapshot.data) ? Loading() : Container(),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _returnPageFromBar() {
    if (_passcodeBloc.page == 0) {
      return Future<bool>.value(true);
    }

    _passcodeBloc.changePage(0);
    return Future<bool>.value(false);
  }

  void _returnPage() {
    if (_passcodeBloc.page == 0) {
      Navigator.of(context).pop();
    } else {
      _passcodeBloc.changePage(0);
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
    Future.delayed(
      Duration(milliseconds: 100),
      () => _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: CustomColors.lightWhite,
          ),
        ),
        duration: Duration(seconds: 3),
      )),
    );
  }

  void _goToScreen() {
    Future.delayed(
      Duration.zero,
      () => Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false),
    );
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
            style: TextStyle(color: CustomColors.darkBlue, fontSize: 20),
          ),
          const SizedBox(height: 50),
          _setTextfieldPhone(),
          const SizedBox(height: 20),
          _setVerifyButton(),
        ],
      ),
    );
  }

  Widget _setTextfieldPhone() => StreamBuilder<String>(
        stream: widget.bloc.phoneStream,
        builder: (_, AsyncSnapshot<String> emailSnapshot) {
          _phoneController.value =
              _phoneController.value.copyWith(text: widget.bloc.phone);

          return CustomTextField(
            textController: _phoneController,
            hint: 'Ingrese número telefónico',
            isRequired: true,
            requiredMessage: 'El número de teléfono es requerido',
            onChange: widget.bloc.changePhone,
            inputType: TextInputType.phone,
            errorText: emailSnapshot.error,
          );
        },
      );

  Widget _setVerifyButton() => StreamBuilder<bool>(
        stream: widget.bloc.isValidPhone,
        builder: (_, AsyncSnapshot<bool> isValidSnapshot) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: CustomButton(
                  text: 'Verificar',
                  onPress: isValidSnapshot.hasData
                      ? () => widget.bloc.verifyPhone()
                      : null,
                  backgroundColor: CustomColors.lightGreen,
                  foregroundColor: CustomColors.white,
                  icon: Icon(
                    Icons.verified_outlined,
                    color: CustomColors.white,
                  ),
                  direction: IconDirection.right,
                ),
              ),
            ],
          ),
        ),
      );
}

class FormPasscode extends StatefulWidget {
  const FormPasscode({Key key, @required this.bloc}) : super(key: key);

  final PasscodeBloc bloc;

  @override
  _FormPasscodeState createState() => _FormPasscodeState();
}

class _FormPasscodeState extends State<FormPasscode> {
  final TextEditingController _codeController = TextEditingController();

  final _decoration = BoxDecoration(
    border: Border.all(color: CustomColors.darkPurple),
  );

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
            style: TextStyle(color: CustomColors.darkBlue, fontSize: 20),
          ),
          const SizedBox(height: 50),
          PinPut(
            fieldsCount: 4,
            controller: _codeController,
            onChanged: widget.bloc.changeCode,
            onSubmit: (_) => widget.bloc.verifyCode(),
            submittedFieldDecoration: _decoration.copyWith(
              borderRadius: BorderRadius.circular(20),
            ),
            selectedFieldDecoration: _decoration.copyWith(
              borderRadius: BorderRadius.circular(15),
            ),
            followingFieldDecoration: _decoration.copyWith(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
      ),
    );
  }
}
