import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_bloc/bloc/language_bloc.dart';
import 'package:login_bloc/common/notification_service.dart';
import 'package:login_bloc/l10n/l10n.dart';
import 'package:login_bloc/router/routes.dart';

class LoginApp extends StatefulWidget {
  const LoginApp({super.key});

  @override
  _LoginAppState createState() => _LoginAppState();
}

class _LoginAppState extends State<LoginApp> {
  @override
  void initState() {
    super.initState();

    NotificationService.getInstance().init();
    languageBloc.getLanguage();
  }

  @override
  void dispose() {
    languageBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Locale?>(
      stream: languageBloc.localeStream,
      builder: (_, snapshot) {
        return MaterialApp.router(
          routerConfig: appRouter,
          theme: ThemeData(
            primarySwatch: Colors.teal,
            textTheme: GoogleFonts.notoSansTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          locale: snapshot.data,
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
      },
    );
  }
}
