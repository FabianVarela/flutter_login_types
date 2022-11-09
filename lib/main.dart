import 'package:flutter/material.dart';
import 'package:flutter_login_types/app.dart';
import 'package:flutter_login_types/bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrap(appProvider: configureAppProvider(), () => const LoginApp());
}
