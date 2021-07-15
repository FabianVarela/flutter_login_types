import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final localizations = AppLocalizations.of(context)!;

    if (_notification != null) {
      print('App status notification: $_notification');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.homeTitle),
        centerTitle: true,
      ),
      body: Center(
        child: Text(localizations.homeText),
      ),
    );
  }
}
