import 'package:flutter/material.dart';

class HomePageUI extends StatefulWidget {
  const HomePageUI({Key? key}) : super(key: key);

  @override
  _HomePageUIState createState() => _HomePageUIState();
}

class _HomePageUIState extends State<HomePageUI> with WidgetsBindingObserver {
  late AppLifecycleState? _notification;

  @override
  void initState() {
    _notification = null;

    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() => _notification = state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_notification != null) {
      print('App status notification: $_notification');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home page'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Welcome'),
      ),
    );
  }
}
