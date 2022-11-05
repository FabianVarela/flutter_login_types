import 'package:flutter/material.dart';
import 'package:flutter_login_types/bloc/language_bloc.dart';
import 'package:flutter_login_types/l10n/l10n.dart';

class HomePageUI extends StatefulWidget {
  const HomePageUI({super.key});

  @override
  _HomePageUIState createState() => _HomePageUIState();
}

class _HomePageUIState extends State<HomePageUI> with WidgetsBindingObserver {
  late AppLifecycleState? _notification;

  @override
  void initState() {
    _notification = null;

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() => _notification = state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = context.localizations;

    if (_notification != null) {
      print('App status notification: $_notification');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.homeTitle),
        centerTitle: true,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(localization.homeText),
            const SizedBox(height: 30),
            StreamBuilder<Locale?>(
              stream: languageBloc.localeStream,
              builder: (_, snapshot) => DropdownButton<Locale>(
                hint: Text(localization.changeLanguageTitle),
                value: snapshot.data,
                onChanged: (l) => languageBloc.setLanguage(l!.languageCode),
                items: <DropdownMenuItem<Locale>>[
                  for (final item in AppLocalizations.supportedLocales)
                    DropdownMenuItem(
                      value: item,
                      child: Text(_getText(item.languageCode)),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getText(String lang) {
    final localization = context.localizations;

    switch (lang) {
      case 'es':
        return localization.spanishLanguage;
      case 'en':
      default:
        return localization.englishLanguage;
    }
  }
}
