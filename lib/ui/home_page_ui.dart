import 'package:flutter/material.dart';

class HomePageUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home page"),
        centerTitle: true,
      ),
      body: Center(
        child: Text("Welcome"),
      ),
    );
  }
}
