import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

class ScreenPage<T> extends Page<T> {
  const new({required super.key, required this.child});

  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) {
    return switch (defaultTargetPlatform) {
      .iOS || .macOS => CupertinoPageRoute<T>(
        settings: this,
        builder: (_) => child,
      ),
      _ => MaterialPageRoute<T>(settings: this, builder: (_) => child),
    };
  }
}
