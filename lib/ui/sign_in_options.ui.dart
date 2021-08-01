import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:login_bloc/bloc/facebook_bloc.dart';
import 'package:login_bloc/common/message_service.dart';
import 'package:login_bloc/common/routes.dart';
import 'package:login_bloc/ui/common/colors.dart';
import 'package:login_bloc/ui/widgets/custom_button.dart';

class SignInOptionsUI extends StatefulWidget {
  const SignInOptionsUI({Key? key}) : super(key: key);

  @override
  _SignInOptionsUIState createState() => _SignInOptionsUIState();
}

class _SignInOptionsUIState extends State<SignInOptionsUI> {
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
              onPress: () => _pushScreen(Routes.signInUserPass),
              backgroundColor: CustomColors.white.withOpacity(.6),
              foregroundColor: CustomColors.darkBlue,
              icon: const Icon(Icons.account_circle_outlined),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: localizations.signInText(localizations.signInPasscode),
              onPress: () => _pushScreen(Routes.signInPasscode),
              backgroundColor: CustomColors.lightBlue,
              foregroundColor: CustomColors.white,
              icon: const Icon(Icons.sms_outlined, color: CustomColors.white),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: localizations.signInText(localizations.signInFingerPrint),
              onPress: () => _pushScreen(Routes.signInBiometric),
              backgroundColor: CustomColors.darkPurple,
              foregroundColor: CustomColors.white,
              icon: const Icon(
                Icons.fingerprint_outlined,
                color: CustomColors.white,
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: localizations.signInText(localizations.signInFacebook),
              onPress: () async {
                final result = await facebookBloc.authenticate();

                if (result != null) {
                  _showSnackBar(result);
                } else {
                  await _goToHomeScreen();
                }
              },
              backgroundColor: CustomColors.kingBlue,
              foregroundColor: CustomColors.white,
              icon: const Icon(Icons.face_outlined, color: CustomColors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(FacebookState state) {
    final localizations = AppLocalizations.of(context)!;
    final String? message;

    switch (state) {
      case FacebookState.inProgress:
        message = localizations.signInFacebookInProgress;
        break;
      case FacebookState.cancelled:
        message = localizations.signInFacebookCancelled;
        break;
      case FacebookState.error:
        message = localizations.signInFacebookError;
        break;
    }

    MessageService.getInstance().showMessage(context, message);
  }

  Future<void> _goToHomeScreen() async => await Navigator.of(context)
      .pushNamedAndRemoveUntil(Routes.home, (Route<dynamic> route) => false);

  Future<void> _pushScreen(String routeName) async =>
      await Navigator.of(context).pushNamed(routeName);
}
