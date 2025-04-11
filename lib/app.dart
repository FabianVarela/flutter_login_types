import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_login_types/core/dependencies/dependencies.dart';
import 'package:flutter_login_types/core/notifiers/language_notifier.dart';
import 'package:flutter_login_types/core/router/routes.dart';
import 'package:flutter_login_types/l10n/l10n.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginApp extends HookConsumerWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(appRouterProvider);
    final language = ref.watch(
      languageNotifierProvider.select((value) => value.value),
    );

    useEffect(() {
      ref.read(notificationServiceProvider).init();
      return null;
    }, const []);

    return MaterialApp.router(
      routerConfig: appRouter.router,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        textTheme: GoogleFonts.notoSansTextTheme(Theme.of(context).textTheme),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
        ),
      ),
      locale: language,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) return supportedLocales.first;

        for (final currentLocale in supportedLocales) {
          if (currentLocale.languageCode == locale.languageCode) {
            return currentLocale;
          }
        }
        return supportedLocales.first;
      },
      onGenerateTitle: (context) => context.localizations.appName,
    );
  }
}
