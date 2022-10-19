import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:login_bloc/bloc/facebook_bloc.dart';
import 'package:login_bloc/common/message_service.dart';
import 'package:login_bloc/l10n/l10n.dart';
import 'package:login_bloc/ui/common/colors.dart';
import 'package:login_bloc/ui/widgets/custom_button.dart';

class SignInOptionsUI extends StatelessWidget {
  const SignInOptionsUI({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = context.localizations;

    return Scaffold(
      backgroundColor: CustomColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              localization.signInOptionText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: CustomColors.darkBlue,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 30),
            CustomButton(
              text: localization.signInText(localization.signInUserPassword),
              onPress: () => _goScreen(context, '/login_user_pass'),
              backgroundColor: CustomColors.white.withOpacity(.6),
              foregroundColor: CustomColors.darkBlue,
              icon: const Icon(
                Icons.account_circle_outlined,
                color: CustomColors.darkBlue,
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: localization.signInText(localization.signInPasscode),
              onPress: () => _goScreen(context, '/login_passcode'),
              backgroundColor: CustomColors.lightBlue,
              foregroundColor: CustomColors.white,
              icon: const Icon(Icons.sms_outlined, color: CustomColors.white),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: localization.signInText(localization.signInFingerPrint),
              onPress: () => _goScreen(context, '/login_biometric'),
              backgroundColor: CustomColors.darkPurple,
              foregroundColor: CustomColors.white,
              icon: const Icon(
                Icons.fingerprint_outlined,
                color: CustomColors.white,
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: localization.signInText(localization.signInFacebook),
              onPress: () async {
                final result = await facebookBloc.authenticate();

                if (result != null) {
                  _showSnackBar(context, result);
                } else {
                  _goScreen(context, '/home');
                }
              },
              backgroundColor: CustomColors.kingBlue,
              foregroundColor: CustomColors.white,
              icon: const Icon(Icons.face_outlined, color: CustomColors.white),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: localization.signInText(localization.signInFirebase),
              onPress: () => _goScreen(context, '/firebase_auth'),
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
    final localization = context.localizations;
    final String? message;

    switch (state) {
      case FacebookState.inProgress:
        message = localization.signInFacebookInProgress;
        break;
      case FacebookState.cancelled:
        message = localization.signInFacebookCancelled;
        break;
      case FacebookState.error:
        message = localization.signInFacebookError;
        break;
    }

    MessageService.getInstance().showMessage(context, message);
  }

  void _goScreen(BuildContext context, String route) => context.go(route);
}
