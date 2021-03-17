import 'package:flutter/material.dart';
import 'package:login_bloc/utils/colors.dart';

class MessageService {
  static final MessageService _instance = MessageService();

  static MessageService getInstance() => _instance;

  void ShowMessage (BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(color: CustomColors.lightWhite),
      ),
      duration: Duration(seconds: 3),
    ));
  }
}
