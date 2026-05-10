import 'package:flutter/material.dart';
import 'package:flutter_login_types/core/router/app_route_path.dart';
import 'package:flutter_login_types/core/theme/colors.dart';
import 'package:flutter_login_types/core/widgets/custom_button.dart';
import 'package:flutter_login_types/l10n/l10n.dart';
import 'package:go_router/go_router.dart';

class TotpOptionsView extends StatelessWidget {
  const TotpOptionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = context.localizations;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.totpOptionsTitle,
          textAlign: .center,
          style: const TextStyle(color: CustomColors.darkBlue, fontSize: 20),
        ),
      ),
      backgroundColor: CustomColors.white,
      body: const Padding(
        padding: .symmetric(horizontal: 16),
        child: Column(
          spacing: 20,
          mainAxisAlignment: .center,
          crossAxisAlignment: .stretch,
          children: <Widget>[
            _SimpleTotpButton(),
            _MsalTotpButton(),
            _GoogleTotpButton(),
          ],
        ),
      ),
    );
  }
}

class _SimpleTotpButton extends StatelessWidget {
  const _SimpleTotpButton();

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: context.localizations.signInText(context.localizations.signInTotp),
      onPress: () => context.push(
        AppRoutePath.loginOptions.totpOptions.totp.path,
      ),
      backgroundColor: CustomColors.lightGreen,
      foregroundColor: CustomColors.white,
      icon: const Icon(Icons.lock_clock_outlined, color: CustomColors.white),
    );
  }
}

class _MsalTotpButton extends StatelessWidget {
  const _MsalTotpButton();

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: context.localizations.signInText(context.localizations.signInMsal),
      onPress: () => context.push(
        AppRoutePath.loginOptions.totpOptions.msal.path,
      ),
      backgroundColor: CustomColors.kingBlue,
      foregroundColor: CustomColors.white,
      icon: const Icon(Icons.window, color: CustomColors.white),
    );
  }
}

class _GoogleTotpButton extends StatelessWidget {
  const _GoogleTotpButton();

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: context.localizations.signInText(
        context.localizations.signInGoogleTotp,
      ),
      onPress: () => context.push(
        AppRoutePath.loginOptions.totpOptions.googleTotp.path,
      ),
      backgroundColor: CustomColors.lightKingBlue,
      foregroundColor: CustomColors.white,
      icon: const Icon(Icons.lock_outline, color: CustomColors.white),
    );
  }
}
