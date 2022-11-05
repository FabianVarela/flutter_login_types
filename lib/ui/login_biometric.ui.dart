import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_login_types/bloc/biometric_bloc.dart';
import 'package:flutter_login_types/common/message_service.dart';
import 'package:flutter_login_types/l10n/l10n.dart';
import 'package:flutter_login_types/ui/common/colors.dart';
import 'package:flutter_login_types/ui/widgets/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

class LoginBiometric extends HookWidget {
  const LoginBiometric({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = context.localizations;

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
                  onGoToScreen: () => context.go('/home'),
                  onSendMessage: (value) => _showSnackBar(context, value),
                )
              : _TextMessage(message: localization.biometricNoSupportedText),
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
}

class _BiometricBody extends StatelessWidget {
  const _BiometricBody({
    required this.bloc,
    required this.onSendMessage,
    required this.onGoToScreen,
  });

  final BiometricBloc bloc;
  final ValueSetter<String> onSendMessage;
  final VoidCallback onGoToScreen;

  @override
  Widget build(BuildContext context) {
    final localization = context.localizations;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          localization.biometricTitle,
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
                      text: localization.biometricButtonText,
                      onPress: () => _onPressButton(context),
                      backgroundColor: CustomColors.darkPurple,
                      foregroundColor: CustomColors.white,
                    ),
                  ),
                ],
              );
            }

            return _TextMessage(message: localization.biometricEnabledText);
          },
        ),
      ],
    );
  }

  Future<void> _onPressButton(BuildContext context) async {
    final localization = context.localizations;
    final result = await bloc.authenticate(localization.biometricReason);

    if (result) {
      onGoToScreen();
    } else {
      onSendMessage(localization.biometricError);
    }
  }
}

class _TextMessage extends StatelessWidget {
  const _TextMessage({required this.message});

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
