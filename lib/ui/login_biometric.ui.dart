import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:local_auth/local_auth.dart';
import 'package:login_bloc/bloc/biometric_bloc.dart';
import 'package:login_bloc/common/message_service.dart';
import 'package:login_bloc/ui/widgets/custom_button.dart';
import 'package:login_bloc/utils/colors.dart';

class LoginBiometric extends StatefulWidget {
  const LoginBiometric({Key? key}) : super(key: key);

  @override
  _LoginBiometricState createState() => _LoginBiometricState();
}

class _LoginBiometricState extends State<LoginBiometric> {
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
      backgroundColor: CustomColors.white,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: StreamBuilder<bool>(
              stream: _biometricBloc.hasBiometricStream,
              builder: (_, hasBiometricSnapshot) {
                if (hasBiometricSnapshot.hasData) {
                  if (hasBiometricSnapshot.data!) {
                    return _setBiometricLoginBody();
                  } else {
                    return _setEmptyMessage();
                  }
                }

                return const Center(
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
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _setBiometricLoginBody() {
    return StreamBuilder<String?>(
      stream: _biometricBloc.messageStream,
      builder: (context, messageSnapshot) {
        final localizations = AppLocalizations.of(context)!;

        if (messageSnapshot.hasData) {
          if (messageSnapshot.data!.isNotEmpty) {
            _showSnackBar(messageSnapshot.data!);
          } else {
            _goToScreen();
          }
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              localizations.biometricTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: CustomColors.darkBlue,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 30),
            StreamBuilder<List<BiometricType>>(
              initialData: const <BiometricType>[],
              stream: _biometricBloc.biometricListStream,
              builder: (_, bioSnapshot) {
                if (bioSnapshot.hasData && bioSnapshot.data!.isNotEmpty) {
                  return Row(
                    children: <Widget>[
                      Expanded(
                        child: CustomButton(
                          text: localizations.biometricButtonText,
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
                    localizations.biometricEnabledText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
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
          AppLocalizations.of(context)!.biometricNoSupportedText,
          textAlign: TextAlign.center,
          style: const TextStyle(
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
        () => Navigator.of(context).pushNamedAndRemoveUntil(
          '/home',
          (Route<dynamic> route) => false,
        ),
      );

  void _showSnackBar(String message) => Future.delayed(
        const Duration(milliseconds: 100),
        () => MessageService.getInstance().showMessage(context, message),
      );
}
