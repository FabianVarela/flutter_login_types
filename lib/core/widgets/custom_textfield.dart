import 'package:flutter/material.dart';
import 'package:flutter_login_types/core/theme/colors.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.textController,
    this.hint,
    this.requiredMessage,
    this.errorText,
    this.isRequired = false,
    this.hasPassword = false,
    this.inputType = .text,
    this.action = .done,
    this.onChange,
  });

  final TextEditingController? textController;
  final String? hint;
  final String? requiredMessage;
  final String? errorText;
  final bool isRequired;
  final bool hasPassword;
  final TextInputType inputType;
  final TextInputAction action;
  final ValueChanged<String>? onChange;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _textController;

  bool _hasFocus = false;
  bool _hasRequired = false;

  bool _isVisiblePassword = false;
  bool _isPasswordActive = false;

  final FocusNode _customFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _textController = widget.textController ?? TextEditingController();
    _isVisiblePassword = widget.hasPassword;

    _customFocusNode.addListener(() {
      if (_customFocusNode.hasFocus) {
        setState(() {
          _hasFocus = true;
          _hasRequired = false;
        });
      } else {
        setState(() {
          _hasFocus = false;
          _hasRequired =
              (widget.isRequired) && _textController.value.text.isEmpty;
        });
      }
    });
  }

  @override
  void dispose() {
    _customFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasRequiredWithText = _hasRequired || widget.errorText != null;

    return Column(
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                width: 4,
                color: switch (_hasFocus) {
                  true => CustomColors.lightGreen,
                  false => switch (hasRequiredWithText) {
                    true => CustomColors.lightRed,
                    false => CustomColors.darkBlue,
                  },
                },
              ),
            ),
            color: switch (hasRequiredWithText) {
              true => CustomColors.lightRed.withValues(alpha: .3),
              false => CustomColors.lightWhite,
            },
          ),
          child: Padding(
            padding: const .symmetric(horizontal: 8, vertical: 3),
            child: TextField(
              controller: _textController,
              cursorColor: CustomColors.lightGreen,
              keyboardType: widget.inputType,
              textInputAction: widget.action,
              onChanged: widget.onChange,
              obscureText: _isVisiblePassword,
              style: const TextStyle(
                color: CustomColors.darkBlue,
                fontSize: 15,
              ),
              focusNode: _customFocusNode,
              decoration: InputDecoration(
                contentPadding: switch (widget.hasPassword) {
                  true => const .only(top: 16),
                  false => .zero,
                },
                border: .none,
                hintStyle: TextStyle(
                  color: CustomColors.grey.withValues(alpha: .7),
                ),
                hintText: ((widget.hint ?? '').isNotEmpty) ? widget.hint : '',
                suffixIcon: switch (widget.hasPassword) {
                  true => IconButton(
                    padding: .zero,
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: switch (_isPasswordActive) {
                        true => CustomColors.lightGreen.withValues(alpha: .7),
                        false => CustomColors.grey.withValues(alpha: .7),
                      },
                      size: 24,
                    ),
                    onPressed: _visiblePassword,
                  ),
                  false => null,
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: const .fromLTRB(6, 3, 0, 7),
          child: _ErrorMessage(
            message: switch (_hasRequired) {
              true => widget.requiredMessage,
              false => widget.errorText ?? '',
            },
          ),
        ),
      ],
    );
  }

  void _visiblePassword() {
    setState(() {
      _isVisiblePassword = !_isVisiblePassword;
      _isPasswordActive = !_isPasswordActive;
    });
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    if (message == null) return const Offstage();
    return Align(
      alignment: .topLeft,
      child: Text(
        message!,
        style: const TextStyle(color: CustomColors.lightRed),
      ),
    );
  }
}
