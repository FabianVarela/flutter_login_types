import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:local_auth/local_auth.dart';
import 'package:login_bloc/bloc/biometric_bloc.dart';
import 'package:login_bloc/common/message_service.dart';
import 'package:login_bloc/common/routes.dart';
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
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: CustomColors.white,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: StreamBuilder<bool>(
              initialData: false,
              stream: _biometricBloc.hasBiometricStream,
              builder: (_, snapshot) => snapshot.data!
                  ? BiometricBody(
                      bloc: _biometricBloc,
                      onGoToScreen: _goToScreen,
                      onSendMessage: _showSnackBar,
                    )
                  : TextMessage(
                      message: localizations.biometricNoSupportedText,
                    ),
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

  void _initBiometric() async {
    await _biometricBloc.checkBiometric();
    await _biometricBloc.getListBiometric();
  }

  void _showSnackBar(String message) =>
      MessageService.getInstance().showMessage(context, message);

  Future<void> _goToScreen() async => await Navigator.of(context)
      .pushNamedAndRemoveUntil(Routes.home, (Route<dynamic> route) => false);
}

class BiometricBody extends StatelessWidget {
  const BiometricBody({
    Key? key,
    required this.bloc,
    required this.onSendMessage,
    required this.onGoToScreen,
  }) : super(key: key);

  final BiometricBloc bloc;
  final ValueSetter<String> onSendMessage;
  final VoidCallback onGoToScreen;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          localizations.biometricTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(color: CustomColors.darkBlue, fontSize: 20),
        ),
        const SizedBox(height: 30),
        StreamBuilder<List<BiometricType>>(
          initialData: const <BiometricType>[],
          stream: bloc.biometricListStream,
          builder: (_, snapshot) {
            if (snapshot.data!.isNotEmpty) {
              return Row(
                children: <Widget>[
                  Expanded(
                    child: CustomButton(
                      text: localizations.biometricButtonText,
                      onPress: () => _onPressButton(context),
                      backgroundColor: CustomColors.darkPurple,
                      foregroundColor: CustomColors.white,
                    ),
                  ),
                ],
              );
            }

            return TextMessage(message: localizations.biometricEnabledText);
          },
        ),
      ],
    );
  }

  void _onPressButton(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    final result = await bloc.authenticate(localizations.biometricReason);

    if (result) {
      onGoToScreen();
    } else {
      onSendMessage(localizations.biometricError);
    }
  }
}

class TextMessage extends StatelessWidget {
  const TextMessage({Key? key, required this.message}) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: CustomColors.darkBlue, fontSize: 25),
      ),
    );
  }
}
