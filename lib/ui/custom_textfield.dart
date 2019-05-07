import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final String requiredMessage;
  final String errorText;
  final bool isRequired;
  final bool hasPassword;
  final ValueChanged<String> onChange;
  final TextInputType inputType;

  CustomTextField({
    @required this.label,
    this.hint,
    this.isRequired = false,
    this.requiredMessage,
    this.onChange,
    this.inputType,
    this.hasPassword = false,
    this.errorText,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final _borderTextFieldNormal = Color(0xFF3F5769);
  final _backgroundTextFieldNormal = Color(0xFFBDD4DF).withOpacity(.5);

  final _borderTextFieldRequired = Color(0xFFFF7171);
  final _backgroundTextFieldRequired = Color(0xFFFFEAEA);

  final _borderTextFieldFocus = Color(0xFF5AC7D8);

  final _foregroundText = Color(0xFF3F5769);
  final _hintTextField = Color(0xFF9fabb4);

  final _requiredColor = Color(0xFFFF7171);

  bool _hasFocus = false;
  bool _hasRequired = false;
  FocusNode _customFocusNode = FocusNode();
  TextEditingController _customTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _customFocusNode.addListener(() {
      if (_customFocusNode.hasFocus) {
        setState(() {
          _hasFocus = true;
          _hasRequired = false;
        });
      } else {
        setState(() {
          _hasFocus = false;
          _hasRequired = ((widget.isRequired != null && widget.isRequired) &&
              _customTextController.value.text == "");
        });
      }
    });
  }

  @override
  void dispose() {
    _customFocusNode.dispose();
    _customTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(width: 4, color: _getBorderColor()),
            ),
            color: _getBackgroundColor(),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 3, left: 8, right: 8, bottom: 6),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget.label,
                    style: TextStyle(color: _foregroundText, fontSize: 12),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 3, left: 8, right: 8, bottom: 12),
                child: TextField(
                  controller: _customTextController,
                  cursorColor: _borderTextFieldFocus,
                  keyboardType: (widget.inputType != null)
                      ? widget.inputType
                      : TextInputType.text,
                  onChanged: widget.onChange,
                  obscureText: widget.hasPassword != null && widget.hasPassword,
                  style: TextStyle(color: _foregroundText, fontSize: 15),
                  focusNode: _customFocusNode,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: _hintTextField),
                    hintText: (widget.hint != null && widget.hint.length > 0)
                        ? widget.hint
                        : "",
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 1, bottom: 7, left: 6),
          child: _setRequired(),
        ),
      ],
    );
  }

  Color _getBorderColor() {
    if (_hasFocus) return _borderTextFieldFocus;

    if (_hasRequired) return _borderTextFieldRequired;

    if (widget.errorText != null) return _borderTextFieldRequired;

    return _borderTextFieldNormal;
  }

  Color _getBackgroundColor() {
    if (_hasRequired) return _backgroundTextFieldRequired;

    if (widget.errorText != null) return _backgroundTextFieldRequired;

    return _backgroundTextFieldNormal;
  }

  Widget _setRequired() {
    if (_hasRequired) return _getRequiredMessage();
    if (widget.errorText != null) return _getErrorMessage();

    return Container();
  }

  Widget _getRequiredMessage() {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        widget.requiredMessage,
        style: TextStyle(color: _requiredColor),
      ),
    );
  }

  Widget _getErrorMessage() {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        widget.errorText,
        style: TextStyle(color: _requiredColor),
      ),
    );
  }
}
