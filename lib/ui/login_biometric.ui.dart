import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:login_bloc/ui/widgets/custom_button.dart';
import 'package:login_bloc/utils/colors.dart';

class LoginBiometric extends StatefulWidget {
  @override
  _LoginBiometricState createState() => _LoginBiometricState();
}

class _LoginBiometricState extends State<LoginBiometric> {
  bool _hasBiometricSensors;
  List<BiometricType> _biometricTypeList;

  String _authMessage = 'No authorized';

  final _authentication = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    initBiometric();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  _authMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CustomColors.darkBlue,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: CustomButton(
                        text: 'Click para iniciar con huella',
                        onPress: _authenticate,
                        backgroundColor: CustomColors.darkPurple,
                        foregroundColor: CustomColors.white,
                      ),
                    ),
                  ],
                ),
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
    );
  }

  void initBiometric() async {
    await _checkBiometric();
    await _getListBiometric();
  }

  Future<void> _checkBiometric() async {
    bool hasBiometric;

    try {
      hasBiometric = await _authentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    setState(() => _hasBiometricSensors = hasBiometric);

    print(_hasBiometricSensors);
  }

  Future<void> _getListBiometric() async {
    List<BiometricType> biometricList;

    try {
      biometricList = await _authentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    setState(() => _biometricTypeList = biometricList);

    print(_biometricTypeList);
  }

  Future<void> _authenticate() async {
    var isAuthorized = false;

    try {
      isAuthorized = await _authentication.authenticateWithBiometrics(
        localizedReason: 'Coloca tu huella',
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }

    setState(
      () => _authMessage = isAuthorized ? 'Authorized' : 'No authorized',
    );
  }
}
