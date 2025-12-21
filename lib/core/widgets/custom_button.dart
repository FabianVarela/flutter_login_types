import 'package:flutter/material.dart';

enum IconDirection { right, left }

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.text,
    super.key,
    this.onPress,
    this.backgroundColor = Colors.white,
    this.foregroundColor = Colors.black,
    this.icon,
    this.direction = .left,
  });

  final String text;
  final VoidCallback? onPress;
  final Color backgroundColor;
  final Color foregroundColor;
  final Widget? icon;
  final IconDirection direction;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const .symmetric(vertical: 10, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: .circular(8)),
      ),
      onPressed: onPress,
      iconAlignment: switch (direction) {
        .left => .start,
        .right => .end,
      },
      icon: Padding(
        padding: switch (direction) {
          .left => const .only(right: 5),
          .right => const .only(left: 5),
        },
        child: icon,
      ),
      label: Text(
        text,
        textAlign: .center,
        style: TextStyle(
          fontSize: 16,
          height: 1.2,
          fontWeight: .bold,
          color: foregroundColor,
        ),
      ),
    );
  }
}
