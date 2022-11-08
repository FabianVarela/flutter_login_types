import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_types/features/fingerprint_login/view/fingerprint_login_view.dart';
import 'package:flutter_login_types/features/passcode_login/view/passcode_login_view.dart';
import 'package:flutter_login_types/features/simple_login/view/simple_login_view.dart';
import 'package:flutter_login_types/ui/firebase_auth.ui.dart';
import 'package:flutter_login_types/ui/home.ui.dart';
import 'package:flutter_login_types/ui/sign_in_options.ui.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      pageBuilder: (_, state) {
        return _setPageRoute(state.pageKey, const SignInOptionsUI());
      },
      routes: <GoRoute>[
        GoRoute(
          path: 'login_user_pass',
          pageBuilder: (_, state) {
            return _setPageRoute(state.pageKey, const SimpleLoginView());
          },
        ),
        GoRoute(
          path: 'login_passcode',
          pageBuilder: (_, state) {
            return _setPageRoute(state.pageKey, const PasscodeLoginView());
          },
        ),
        GoRoute(
          path: 'login_biometric',
          pageBuilder: (_, state) {
            return _setPageRoute(state.pageKey, const FingerPrintLoginView());
          },
        ),
        GoRoute(
          path: 'firebase_auth',
          pageBuilder: (_, state) {
            return _setPageRoute(state.pageKey, const FirebaseAuthUI());
          },
        ),
      ],
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (_, state) {
        return _setPageRoute(state.pageKey, const HomePageUI());
      },
    ),
  ],
);

Page<dynamic> _setPageRoute(LocalKey pageKey, Widget child) {
  if (Platform.isIOS || Platform.isMacOS) {
    return CupertinoPage(key: pageKey, child: child);
  }
  return MaterialPage(key: pageKey, child: child);
}
