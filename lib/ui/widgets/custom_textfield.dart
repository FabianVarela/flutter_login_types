import 'package:flutter/material.dart';
import 'package:flutter_login_types/ui/common/colors.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.textController,
    this.hint,
    this.requiredMessage,
    this.errorText,
    this.isRequired = false,
    this.hasPassword = false,
    this.inputType = TextInputType.text,
    this.action = TextInputAction.done,
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
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(width: 4, color: _getBorderColor()),
              ),
              color: _getBackgroundColor(),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                  contentPadding: widget.hasPassword
                      ? const EdgeInsets.only(top: 16)
                      : EdgeInsets.zero,
                  border: InputBorder.none,
                  hintStyle:
                      TextStyle(color: CustomColors.grey.withOpacity(.7)),
                  hintText: (widget.hint != null && widget.hint!.isNotEmpty)
                      ? widget.hint
                      : '',
                  suffixIcon: widget.hasPassword
                      ? IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: _isPasswordActive
                                ? CustomColors.lightGreen.withOpacity(.7)
                                : CustomColors.grey.withOpacity(.7),
                            size: 24,
                          ),
                          onPressed: _visiblePassword,
                        )
                      : null,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 3, 0, 7),
            child: _setRequired(),
          ),
        ],
      );

  Widget _setRequired() => _hasRequired
      ? _getRequiredMessage()
      : widget.errorText != null
          ? _getErrorMessage()
          : Container();

  Widget _getRequiredMessage() => Align(
        alignment: Alignment.topLeft,
        child: Text(
          widget.requiredMessage!,
          style: const TextStyle(color: CustomColors.lightRed),
        ),
      );

  Widget _getErrorMessage() => Align(
        alignment: Alignment.topLeft,
        child: Text(
          widget.errorText!,
          style: const TextStyle(color: CustomColors.lightRed),
        ),
      );

  void _visiblePassword() {
    setState(() {
      _isVisiblePassword = !_isVisiblePassword;
      _isPasswordActive = !_isPasswordActive;
    });
  }

  Color _getBorderColor() => _hasFocus
      ? CustomColors.lightGreen
      : _hasRequired
          ? CustomColors.lightRed
          : widget.errorText != null
              ? CustomColors.lightRed
              : CustomColors.darkBlue;

  Color _getBackgroundColor() => _hasRequired
      ? CustomColors.lightRed.withOpacity(.3)
      : widget.errorText != null
          ? CustomColors.lightRed.withOpacity(.3)
          : CustomColors.lightWhite;
}
