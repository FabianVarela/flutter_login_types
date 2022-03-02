import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:local_auth/local_auth.dart';
import 'package:login_bloc/bloc/biometric_bloc.dart';
import 'package:login_bloc/common/message_service.dart';
import 'package:login_bloc/common/routes.dart';
import 'package:login_bloc/ui/common/colors.dart';
import 'package:login_bloc/ui/widgets/custom_button.dart';

class LoginBiometric extends HookWidget {
  const LoginBiometric({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    useEffect(
      () {
        Future.microtask(_initBiometric);
        return biometricBloc.dispose;
      },
      const [],
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      backgroundColor: CustomColors.white,
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: StreamBuilder<bool>(
          initialData: false,
          stream: biometricBloc.hasBiometricStream,
          builder: (_, snapshot) => snapshot.data!
              ? _BiometricBody(
                  bloc: biometricBloc,
                  onGoToScreen: () => _goToScreen(context),
                  onSendMessage: (value) => _showSnackBar(context, value),
                )
              : _TextMessage(message: localizations.biometricNoSupportedText),
        ),
      ),
    );
  }

  Future<void> _initBiometric() async {
    await biometricBloc.checkBiometric();
    await biometricBloc.getListBiometric();
  }

  void _showSnackBar(BuildContext context, String message) =>
      MessageService.getInstance().showMessage(context, message);

  Future<void> _goToScreen(BuildContext context) => Navigator.of(context)
      .pushNamedAndRemoveUntil(Routes.home, (Route<dynamic> route) => false);
}

class _BiometricBody extends StatelessWidget {
  const _BiometricBody({
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

            return _TextMessage(message: localizations.biometricEnabledText);
          },
        ),
      ],
    );
  }

  Future<void> _onPressButton(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    final result = await bloc.authenticate(localizations.biometricReason);

    if (result) {
      onGoToScreen();
    } else {
      onSendMessage(localizations.biometricError);
    }
  }
}

class _TextMessage extends StatelessWidget {
  const _TextMessage({Key? key, required this.message}) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) => Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: CustomColors.darkBlue, fontSize: 25),
        ),
      );
}
