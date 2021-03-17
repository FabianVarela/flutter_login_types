import 'package:flutter/material.dart';
import 'package:login_bloc/bloc/facebook_bloc.dart';
import 'package:login_bloc/common/message_service.dart';
import 'package:login_bloc/ui/widgets/custom_button.dart';
import 'package:login_bloc/utils/colors.dart';

class SignInOptionsUI extends StatefulWidget {
  @override
  _SignInOptionsUIState createState() => _SignInOptionsUIState();
}

class _SignInOptionsUIState extends State<SignInOptionsUI> {
  final _facebookBloc = FacebookBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Elige una forma de iniciar sesión',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CustomColors.darkBlue,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 30),
            CustomButton(
              text: 'Iniciar con usuario / contraseña',
              onPress: () => Navigator.of(context).pushNamed(
                '/login_user_pass',
              ),
              foregroundColor: CustomColors.darkBlue,
              icon: Icon(Icons.account_circle_outlined),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Iniciar con passcode',
              onPress: () => Navigator.of(context).pushNamed(
                '/login_passcode',
              ),
              backgroundColor: CustomColors.lightBlue,
              foregroundColor: CustomColors.white,
              icon: Icon(Icons.sms_outlined, color: CustomColors.white),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Iniciar con huella',
              onPress: () => Navigator.of(context).pushNamed(
                '/login_biometric',
              ),
              backgroundColor: CustomColors.darkPurple,
              foregroundColor: CustomColors.white,
              icon: Icon(Icons.fingerprint_outlined, color: CustomColors.white),
            ),
            const SizedBox(height: 20),
            StreamBuilder<String>(
              stream: _facebookBloc.message,
              builder: (_, AsyncSnapshot<String> messageSnapshot) {
                if (messageSnapshot.hasData) {
                  if (messageSnapshot.data!.isNotEmpty) {
                    _showSnackBar(messageSnapshot.data!);
                  } else {
                    _goToScreen();
                  }
                }

                return CustomButton(
                  text: 'Iniciar con Facebook',
                  onPress: _facebookBloc.authenticate,
                  backgroundColor: CustomColors.kingBlue,
                  foregroundColor: CustomColors.white,
                  icon: Icon(Icons.face_outlined, color: CustomColors.white),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message) => Future.delayed(
        Duration(milliseconds: 100),
        () => MessageService.getInstance().ShowMessage(context, message),
      );

  void _goToScreen() => Future.delayed(
        Duration.zero,
        () => Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false),
      );
}
