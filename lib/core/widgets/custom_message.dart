import 'package:flutter/material.dart';
import 'package:flutter_login_types/core/theme/colors.dart';

class CustomMessage {
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: CustomColors.lightWhite),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
