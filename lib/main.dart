import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_bloc/common/notification_service.dart';
import 'package:login_bloc/ui/login_biometric.ui.dart';
import 'package:login_bloc/ui/login_passcode.ui.dart';
import 'package:login_bloc/ui/login_user_pass.ui.dart';
import 'package:login_bloc/ui/sign_in_options.ui.dart';

import 'ui/home.ui.dart';
import 'ui/login_user_pass.ui.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    NotificationService.getInstance().init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
        textTheme: GoogleFonts.notoSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const SignInOptionsUI(),
        '/login_user_pass': (_) => const LoginUI(),
        '/login_passcode': (_) => const LoginPasscodeUI(),
        '/login_biometric': (_) => const LoginBiometric(),
        '/home': (_) => const HomePageUI(),
      },
    );
  }
}
