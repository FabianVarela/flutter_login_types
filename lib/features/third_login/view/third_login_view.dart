import 'package:flutter/material.dart';
import 'package:flutter_login_types/core/theme/colors.dart';
import 'package:flutter_login_types/core/widgets/custom_button.dart';
import 'package:flutter_login_types/core/widgets/custom_message.dart';
import 'package:flutter_login_types/features/third_login/dependency.dart';
import 'package:flutter_login_types/features/third_login/notifier/third_login_notifier.dart';
import 'package:flutter_login_types/l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ThirdLoginView extends ConsumerWidget {
  const ThirdLoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(thirdLoginNotifierProvider, (_, next) {
      if (next == ThirdLoginResult.success) {
        context.go('/home');
      } else {
        _showSnackBar(context, next);
      }
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      backgroundColor: CustomColors.white,
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const <Widget>[
            _FacebookButton(),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, ThirdLoginResult state) {
    final localization = context.localizations;
    String? message;

    switch (state) {
      case ThirdLoginResult.progress:
        message = localization.signInFacebookInProgress;
        break;
      case ThirdLoginResult.cancelled:
        message = localization.signInFacebookCancelled;
        break;
      case ThirdLoginResult.error:
        message = localization.signInFacebookError;
        break;
      default:
        break;
    }

    if (message != null) CustomMessage.show(context, message);
  }
}

class _FacebookButton extends ConsumerWidget {
  const _FacebookButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = context.localizations;

    return CustomButton(
      text: localization.signInText(localization.signInFacebook),
      onPress: () {
        ref.read(thirdLoginNotifierProvider.notifier).authenticate();
      },
      backgroundColor: CustomColors.kingBlue,
      foregroundColor: CustomColors.white,
      icon: const Icon(Icons.face_outlined, color: CustomColors.white),
    );
  }
}
