import 'package:flutter/material.dart';
import 'package:login_bloc/ui/login_ui.dart';

import 'ui/home_page_ui.dart';
import 'ui/login_ui.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/',
      routes: {
        '/': (context) {
          return LoginUI();
        },
        '/home': (context) {
          return HomePageUI();
        },
      },
    );
  }
}
