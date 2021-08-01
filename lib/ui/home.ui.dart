import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:login_bloc/bloc/language_bloc.dart';

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
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(localizations.homeText),
            const SizedBox(height: 30),
            StreamBuilder<Locale?>(
              stream: languageBloc.localeStream,
              builder: (_, snapshot) {
                return DropdownButton<Locale>(
                  hint: Text(localizations.changeLanguageTitle),
                  value: snapshot.data,
                  onChanged: (locale) =>
                      languageBloc.setLanguage(locale!.languageCode),
                  items: AppLocalizations.supportedLocales
                      .map((locale) => DropdownMenuItem(
                            value: locale,
                            child: Text(_getText(locale.languageCode)),
                          ))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getText(String lang) {
    final localizations = AppLocalizations.of(context)!;

    switch (lang) {
      case 'es':
        return localizations.spanishLanguage;
      case 'en':
      default:
        return localizations.englishLanguage;
    }
  }
}
