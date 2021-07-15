import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:login_bloc/bloc/facebook_bloc.dart';
import 'package:login_bloc/common/message_service.dart';
import 'package:login_bloc/common/routes.dart';
import 'package:login_bloc/ui/widgets/custom_button.dart';
import 'package:login_bloc/utils/colors.dart';

class SignInOptionsUI extends StatefulWidget {
  const SignInOptionsUI({Key? key}) : super(key: key);

  @override
  _SignInOptionsUIState createState() => _SignInOptionsUIState();
}

class _SignInOptionsUIState extends State<SignInOptionsUI> {
  final _facebookBloc = FacebookBloc();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: CustomColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              localizations.signInOptionText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: CustomColors.darkBlue,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 30),
            CustomButton(
              text: localizations.signInText(localizations.signInUserPassword),
              onPress: () => Navigator.of(context).pushNamed(
                Routes.signInUserPass,
              ),
              backgroundColor: CustomColors.white.withOpacity(.6),
              foregroundColor: CustomColors.darkBlue,
              icon: const Icon(Icons.account_circle_outlined),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: localizations.signInText(localizations.signInPasscode),
              onPress: () => Navigator.of(context).pushNamed(
                Routes.signInPasscode,
              ),
              backgroundColor: CustomColors.lightBlue,
              foregroundColor: CustomColors.white,
              icon: const Icon(Icons.sms_outlined, color: CustomColors.white),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: localizations.signInText(localizations.signInFingerPrint),
              onPress: () => Navigator.of(context).pushNamed(
                Routes.signInBiometric,
              ),
              backgroundColor: CustomColors.darkPurple,
              foregroundColor: CustomColors.white,
              icon: const Icon(
                Icons.fingerprint_outlined,
                color: CustomColors.white,
              ),
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
                  text: localizations.signInText(localizations.signInFacebook),
                  onPress: _facebookBloc.authenticate,
                  backgroundColor: CustomColors.kingBlue,
                  foregroundColor: CustomColors.white,
                  icon: const Icon(
                    Icons.face_outlined,
                    color: CustomColors.white,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message) => Future.delayed(
        const Duration(milliseconds: 100),
        () => MessageService.getInstance().showMessage(context, message),
      );

  void _goToScreen() => Future.delayed(
        Duration.zero,
        () => Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.home, (Route<dynamic> route) => false),
      );
}
