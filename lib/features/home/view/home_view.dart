import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_types/core/notifiers/language_notifier.dart';
import 'package:flutter_login_types/core/notifiers/session/session_notifier.dart';
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
    if (_notification != null) {
      if (kDebugMode) print('App status notification: $_notification');
    }

    final language = ref.watch(languageNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.localizations.homeTitle),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () => unawaited(
              ref.read(sessionNotifierProvider.notifier).clear(),
            ),
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          mainAxisAlignment: .center,
          children: <Widget>[
            Text(context.localizations.homeText),
            const Gap(30),
            DropdownButton<Locale>(
              hint: Text(context.localizations.changeLanguageTitle),
              value: language,
              onChanged: (language) {
                final notifier = ref.read(languageNotifierProvider.notifier);
                unawaited(
                  notifier.setLanguage(language: language!.languageCode),
                );
              },
              items: <DropdownMenuItem<Locale>>[
                for (final item in AppLocalizations.supportedLocales)
                  DropdownMenuItem(
                    value: item,
                    child: Text(
                      switch (item.languageCode) {
                        'es' => context.localizations.spanishLanguage,
                        _ => context.localizations.englishLanguage,
                      },
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
