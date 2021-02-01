import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:login_bloc/bloc/biometric_bloc.dart';
import 'package:login_bloc/ui/widgets/custom_button.dart';
import 'package:login_bloc/utils/colors.dart';

class LoginBiometric extends StatefulWidget {
  @override
  _LoginBiometricState createState() => _LoginBiometricState();
}

class _LoginBiometricState extends State<LoginBiometric> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _biometricBloc = BiometricBloc();

  @override
  void initState() {
    super.initState();
    _initBiometric();
  }

  @override
  void dispose() {
    _biometricBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.white,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: StreamBuilder<bool>(
              stream: _biometricBloc.hasBiometricStream,
              builder: (_, AsyncSnapshot<bool> hasBiometricSnapshot) {
                if (hasBiometricSnapshot.hasData) {
                  if (hasBiometricSnapshot.data) {
                    return _setBiometricLoginBody();
                  } else {
                    return _setEmptyMessage();
                  }
                }

                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: CustomColors.lightGreen,
                  ),
                );
              },
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
    );
  }

  Widget _setBiometricLoginBody() {
    return StreamBuilder<String>(
      stream: _biometricBloc.messageStream,
      builder: (_, AsyncSnapshot<String> messageSnapshot) {
        if (messageSnapshot.hasData) {
          if (messageSnapshot.data.isNotEmpty) {
            _showSnackBar(messageSnapshot.data);
          } else {
            _goToScreen();
          }
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Haz click para iniciar',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CustomColors.darkBlue,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 30),
            StreamBuilder<List<BiometricType>>(
              initialData: <BiometricType>[],
              stream: _biometricBloc.biometricListStream,
              builder: (_, AsyncSnapshot<List<BiometricType>> snapshot) {
                if (snapshot.data.isNotEmpty) {
                  return Row(
                    children: <Widget>[
                      Expanded(
                        child: CustomButton(
                          text: 'Click para iniciar con huella',
                          onPress: _biometricBloc.authenticate,
                          backgroundColor: CustomColors.darkPurple,
                          foregroundColor: CustomColors.white,
                        ),
                      ),
                    ],
                  );
                }

                return Center(
                  child: Text(
                    'Debes ir a configuración y habilitar la huella o el Face ID',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CustomColors.darkBlue,
                      fontSize: 20,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _setEmptyMessage() => Center(
        child: Text(
          'Este dispositivo no soporta inicio de sesión mediante biometría',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: CustomColors.darkBlue,
            fontSize: 25,
          ),
        ),
      );

  void _initBiometric() async {
    await _biometricBloc.checkBiometric();
    await _biometricBloc.getListBiometric();
  }

  void _goToScreen() => Future.delayed(
        Duration.zero,
        () => Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false),
      );

  void _showSnackBar(String message) => Future.delayed(
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
