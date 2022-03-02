import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:login_bloc/bloc/facebook_bloc.dart';
import 'package:login_bloc/common/message_service.dart';
import 'package:login_bloc/common/routes.dart';
import 'package:login_bloc/ui/common/colors.dart';
import 'package:login_bloc/ui/widgets/custom_button.dart';

class SignInOptionsUI extends StatelessWidget {
  const SignInOptionsUI({Key? key}) : super(key: key);

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
              onPress: () => _pushScreen(context, Routes.signInUserPass),
              backgroundColor: CustomColors.white.withOpacity(.6),
              foregroundColor: CustomColors.darkBlue,
              icon: const Icon(Icons.account_circle_outlined),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: localizations.signInText(localizations.signInPasscode),
              onPress: () => _pushScreen(context, Routes.signInPasscode),
              backgroundColor: CustomColors.lightBlue,
              foregroundColor: CustomColors.white,
              icon: const Icon(Icons.sms_outlined, color: CustomColors.white),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: localizations.signInText(localizations.signInFingerPrint),
              onPress: () => _pushScreen(context, Routes.signInBiometric),
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
                  _showSnackBar(context, result);
                } else {
                  await _goToHomeScreen(context);
                }
              },
              backgroundColor: CustomColors.kingBlue,
              foregroundColor: CustomColors.white,
              icon: const Icon(Icons.face_outlined, color: CustomColors.white),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: localizations.signInText(localizations.signInFirebase),
              onPress: () => _pushScreen(context, Routes.firebaseAuth),
              backgroundColor: CustomColors.darkYellow,
              foregroundColor: CustomColors.white,
              icon: const Icon(
                Icons.local_fire_department_outlined,
                color: CustomColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, FacebookState state) {
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

  Future<void> _goToHomeScreen(BuildContext context) => Navigator.of(context)
      .pushNamedAndRemoveUntil(Routes.home, (Route<dynamic> route) => false);

  Future<void> _pushScreen(BuildContext context, String routeName) =>
      Navigator.of(context).pushNamed(routeName);
}
