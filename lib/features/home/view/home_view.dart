import 'package:flutter/material.dart';
import 'package:flutter_login_types/core/notifiers/language_notifier.dart';
import 'package:flutter_login_types/core/notifiers/session/session_notifier.dart';
import 'package:flutter_login_types/l10n/generated/app_localizations.dart'
    show AppLocalizations;
import 'package:flutter_login_types/l10n/l10n.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  _HomePageUIState createState() => _HomePageUIState();
}

class _HomePageUIState extends ConsumerState<HomeView>
    with WidgetsBindingObserver {
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
    if (_notification != null) print('App status notification: $_notification');
    final language = ref.watch(
      languageNotifierProvider.select((value) => value.value),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(context.localizations.homeTitle),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              ref.read(sessionNotifierProvider.notifier).removeSession();
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(context.localizations.homeText),
            const Gap(30),
            DropdownButton<Locale>(
              hint: Text(context.localizations.changeLanguageTitle),
              value: language,
              onChanged: (language) => ref
                  .read(languageNotifierProvider.notifier)
                  .setLanguage(language: language!.languageCode),
              items: <DropdownMenuItem<Locale>>[
                for (final item in AppLocalizations.supportedLocales)
                  DropdownMenuItem(
                    value: item,
                    child: Text(_getText(item.languageCode)),
                  ),
              ],
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
