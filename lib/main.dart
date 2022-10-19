import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_bloc/app.dart';
import 'package:login_bloc/bootstrap.dart';
import 'package:login_bloc/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await bootstrap(() => const LoginApp());
}
