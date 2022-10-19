import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:login_bloc/bloc/passcode_bloc.dart';
import 'package:login_bloc/common/message_service.dart';
import 'package:login_bloc/common/model/text_field_validator.dart';
import 'package:login_bloc/common/notification_service.dart';
import 'package:login_bloc/common/utils.dart';
import 'package:login_bloc/l10n/l10n.dart';
import 'package:login_bloc/ui/common/colors.dart';
import 'package:login_bloc/ui/widgets/custom_button.dart';
import 'package:login_bloc/ui/widgets/custom_textfield.dart';
import 'package:login_bloc/ui/widgets/loading.dart';
import 'package:pinput/pinput.dart';

class LoginPasscodeUI extends HookWidget {
  const LoginPasscodeUI({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();

    useEffect(
      () {
        return passcodeBloc.dispose;
      },
      const [],
    );

    return WillPopScope(
      onWillPop: () async {
        if (passcodeBloc.page == 0) return true;

        passcodeBloc.changePage(0);
        return false;
      },
      child: Stack(
        children: <Widget>[
          Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black,
            ),
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: true,
            backgroundColor: CustomColors.white,
            body: StreamBuilder<int>(
              stream: passcodeBloc.pageStream,
              builder: (_, pageSnapshot) {
                if (pageController.hasClients && pageSnapshot.hasData) {
                  if (pageController.page!.round() != passcodeBloc.page) {
                    pageController.animateToPage(
                      passcodeBloc.page!,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 400),
                    );
                  }
                }

                return PageView(
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    _FormPhone(
                      bloc: passcodeBloc,
                      onSendMessage: (value) => _showSnackBar(context, value),
                    ),
                    _FormPasscode(
                      bloc: passcodeBloc,
                      onGoToScreen: () => context.go('/home'),
                      onSendMessage: (value) => _showSnackBar(context, value),
                    ),
                  ],
                );
              },
            ),
          ),
          StreamBuilder<bool>(
            initialData: false,
            stream: passcodeBloc.isLoading,
            builder: (context, AsyncSnapshot<bool> snapshot) => Offstage(
              offstage: !snapshot.data!,
              child: const Loading(),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) =>
      MessageService.getInstance().showMessage(context, message);
}

class _FormPhone extends HookWidget {
  const _FormPhone({required this.bloc, required this.onSendMessage});

  final PasscodeBloc bloc;
  final ValueSetter<String> onSendMessage;

  @override
  Widget build(BuildContext context) {
    final localization = context.localizations;
    final controller = useTextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            localization.phoneNumberTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: CustomColors.darkBlue, fontSize: 20),
          ),
          const SizedBox(height: 50),
          StreamBuilder<TextFieldValidator>(
            stream: bloc.phoneStream,
            builder: (_, snapshot) {
              final localization = context.localizations;
              controller.value = controller.value.copyWith(text: bloc.phone);

              return CustomTextField(
                textController: controller,
                hint: localization.phoneNumberPlaceholder,
                isRequired: true,
                requiredMessage: localization.phoneNumberRequired,
                onChange: bloc.changePhone,
                inputType: TextInputType.phone,
                errorText: snapshot.hasError
                    ? Utils.getTextValidator(
                        context,
                        (snapshot.error as TextFieldValidator?)!.validator,
                      )
                    : null,
              );
            },
          ),
          const SizedBox(height: 20),
          StreamBuilder<bool>(
            stream: bloc.isValidPhone,
            builder: (_, isValidSnapshot) {
              final localization = context.localizations;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: CustomButton(
                        text: localization.verifyButtonText,
                        onPress: isValidSnapshot.hasData
                            ? () => _onPressButton(context)
                            : null,
                        backgroundColor: CustomColors.lightGreen,
                        foregroundColor: CustomColors.white,
                        icon: const Icon(
                          Icons.verified_outlined,
                          color: CustomColors.white,
                        ),
                        direction: IconDirection.right,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _onPressButton(BuildContext context) async {
    final localization = context.localizations;
    final result = await bloc.verifyPhone();

    if (result) {
      bloc.changePage(1);
      await NotificationService.getInstance().showNotification(
        localization.notificationTitle,
        localization.notificationMessage('0000'),
      );
    } else {
      onSendMessage(localization.phoneNumberIncorrect);
    }
  }
}

class _FormPasscode extends HookWidget {
  const _FormPasscode({
    required this.bloc,
    required this.onSendMessage,
    required this.onGoToScreen,
  });

  final PasscodeBloc bloc;
  final ValueSetter<String> onSendMessage;
  final VoidCallback onGoToScreen;

  @override
  Widget build(BuildContext context) {
    final localization = context.localizations;
    final controller = useTextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            localization.passcodeTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: CustomColors.darkBlue, fontSize: 20),
          ),
          const SizedBox(height: 50),
          Pinput(
            controller: controller,
            onCompleted: (val) {
              bloc.changeCode(val);
              _onSubmitPin(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _onSubmitPin(BuildContext context) async {
    final localization = context.localizations;
    final result = await bloc.verifyCode();

    if (result) {
      onGoToScreen();
    } else {
      onSendMessage(localization.passcodeIncorrect);
    }
  }
}
