import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_bloc/bloc/language_bloc.dart';
import 'package:login_bloc/common/notification_service.dart';
import 'package:login_bloc/common/routes.dart';
import 'package:login_bloc/ui/login_biometric.ui.dart';
import 'package:login_bloc/ui/login_passcode.ui.dart';
import 'package:login_bloc/ui/login_user_pass.ui.dart';
import 'package:login_bloc/ui/sign_in_options.ui.dart';

import 'ui/home.ui.dart';
import 'ui/login_user_pass.ui.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
        return MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.teal,
            textTheme: GoogleFonts.notoSansTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          locale: snapshot.data,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          initialRoute: Routes.signInOptions,
          localeResolutionCallback: (locale, supportedLocales) {
            print('Locale: $locale · Locales: $supportedLocales');
            if (locale == null) return supportedLocales.first;

            for (final currentLocale in supportedLocales) {
              final isLang = currentLocale.languageCode == locale.languageCode;
              // currentLocale.countryCode == locale.countryCode;

              if (isLang) return currentLocale;
            }
            return supportedLocales.first;
          },
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
          routes: {
            Routes.signInOptions: (_) => const SignInOptionsUI(),
            Routes.signInUserPass: (_) => const LoginUI(),
            Routes.signInPasscode: (_) => const LoginPasscodeUI(),
            Routes.signInBiometric: (_) => const LoginBiometric(),
            Routes.home: (_) => const HomePageUI(),
          },
        );
      },
    );
  }
}
