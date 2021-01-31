import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_bloc/ui/login_biometric.ui.dart';
import 'package:login_bloc/ui/login_passcode.dart';
import 'package:login_bloc/ui/login_user_pass.ui.dart';
import 'package:login_bloc/ui/sign_in_options.ui.dart';

import 'ui/home.ui.dart';
import 'ui/login_user_pass.ui.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
        '/': (_) => SignInOptionsUI(),
        '/login_user_pass': (_) => LoginUI(),
        '/login_passcode': (_) => LoginPasscodeUI(),
        '/login_biometric': (_) => LoginBiometric(),
        '/home': (_) => HomePageUI(),
      },
    );
  }
}
