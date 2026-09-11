import 'package:flutter_login_types/core/theme/colors.dart';
import 'package:material_ui/material_ui.dart';

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
