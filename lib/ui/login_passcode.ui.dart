import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:login_bloc/bloc/passcode_bloc.dart';
import 'package:login_bloc/common/message_service.dart';
import 'package:login_bloc/common/model/text_field_validator.dart';
import 'package:login_bloc/common/notification_service.dart';
import 'package:login_bloc/common/routes.dart';
import 'package:login_bloc/common/utils.dart';
import 'package:login_bloc/ui/widgets/custom_button.dart';
import 'package:login_bloc/ui/widgets/custom_textfield.dart';
import 'package:login_bloc/ui/common/colors.dart';
import 'package:login_bloc/ui/widgets/loading.dart';
import 'package:pinput/pin_put/pin_put.dart';

class LoginPasscodeUI extends StatefulWidget {
  const LoginPasscodeUI({Key? key}) : super(key: key);

  @override
  _LoginPasscodeUIState createState() => _LoginPasscodeUIState();
}

class _LoginPasscodeUIState extends State<LoginPasscodeUI> {
  final PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  final _passcodeBloc = PasscodeBloc();

  @override
  void dispose() {
    _passcodeBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _returnPageFromBar,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: CustomColors.white,
        body: Stack(
          children: <Widget>[
            Stack(
              children: <Widget>[
                StreamBuilder<int>(
                  stream: _passcodeBloc.pageStream,
                  builder: (_, pageSnapshot) {
                    if (_pageController.hasClients && pageSnapshot.hasData) {
                      if (_pageController.page!.round() != _passcodeBloc.page) {
                        _goToPage(_passcodeBloc.page!);
                      }
                    }

                    return PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        FormPhone(
                          bloc: _passcodeBloc,
                          onSendMessage: _showSnackBar,
                        ),
                        FormPasscode(
                          bloc: _passcodeBloc,
                          onGoToScreen: _goToScreen,
                          onSendMessage: _showSnackBar,
                        ),
                      ],
                    );
                  },
                ),
                Positioned(
                  top: 30,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: _returnPage,
                  ),
                ),
              ],
            ),
            StreamBuilder<bool>(
              initialData: false,
              stream: _passcodeBloc.isLoading,
              builder: (context, AsyncSnapshot<bool> snapshot) => Offstage(
                offstage: !snapshot.data!,
                child: const Loading(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _returnPageFromBar() {
    if (_passcodeBloc.page == 0) return Future<bool>.value(true);

    _passcodeBloc.changePage(0);
    return Future<bool>.value(false);
  }

  void _returnPage() {
    if (_passcodeBloc.page == 0) {
      Navigator.of(context).pop();
    } else {
      _passcodeBloc.changePage(0);
    }
  }

  void _goToPage(int page) => _pageController.animateToPage(page,
      curve: Curves.easeOut, duration: const Duration(milliseconds: 400));

  void _showSnackBar(String message) =>
      MessageService.getInstance().showMessage(context, message);

  Future<void> _goToScreen() async => await Navigator.of(context)
      .pushNamedAndRemoveUntil(Routes.home, (Route<dynamic> route) => false);
}

class FormPhone extends HookWidget {
  const FormPhone({Key? key, required this.bloc, required this.onSendMessage})
      : super(key: key);

  final PasscodeBloc bloc;
  final ValueSetter<String> onSendMessage;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final controller = useTextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            localizations.phoneNumberTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: CustomColors.darkBlue, fontSize: 20),
          ),
          const SizedBox(height: 50),
          StreamBuilder<TextFieldValidator>(
            stream: bloc.phoneStream,
            builder: (_, snapshot) {
              final localizations = AppLocalizations.of(context)!;
              controller.value = controller.value.copyWith(text: bloc.phone);

              return CustomTextField(
                textController: controller,
                hint: localizations.phoneNumberPlaceholder,
                isRequired: true,
                requiredMessage: localizations.phoneNumberRequired,
                onChange: bloc.changePhone,
                inputType: TextInputType.phone,
                errorText: snapshot.hasError
                    ? Utils.getTextValidator(context,
                        (snapshot.error as TextFieldValidator).validator)
                    : null,
              );
            },
          ),
          const SizedBox(height: 20),
          StreamBuilder<bool>(
            stream: bloc.isValidPhone,
            builder: (_, isValidSnapshot) {
              final localizations = AppLocalizations.of(context)!;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: CustomButton(
                        text: localizations.verifyButtonText,
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

  void _onPressButton(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    final result = await bloc.verifyPhone();

    if (result) {
      bloc.changePage(1);
      await NotificationService.getInstance().showNotification(
        localizations.notificationTitle,
        localizations.notificationMessage('0000'),
      );
    } else {
      onSendMessage(localizations.phoneNumberIncorrect);
    }
  }
}

class FormPasscode extends HookWidget {
  const FormPasscode({
    Key? key,
    required this.bloc,
    required this.onSendMessage,
    required this.onGoToScreen,
  }) : super(key: key);

  final PasscodeBloc bloc;
  final ValueSetter<String> onSendMessage;
  final VoidCallback onGoToScreen;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final controller = useTextEditingController();

    final _decoration = BoxDecoration(
      border: Border.all(color: CustomColors.darkPurple),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            localizations.passcodeTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: CustomColors.darkBlue, fontSize: 20),
          ),
          const SizedBox(height: 50),
          PinPut(
            fieldsCount: 4,
            controller: controller,
            onChanged: bloc.changeCode,
            onSubmit: (_) => _onSubmitPin(context),
            submittedFieldDecoration: _decoration.copyWith(
              borderRadius: BorderRadius.circular(20),
            ),
            selectedFieldDecoration: _decoration.copyWith(
              borderRadius: BorderRadius.circular(15),
            ),
            followingFieldDecoration: _decoration.copyWith(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
      ),
    );
  }

  void _onSubmitPin(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    final result = await bloc.verifyCode();

    if (result) {
      onGoToScreen();
    } else {
      onSendMessage(localizations.passcodeIncorrect);
    }
  }
}
