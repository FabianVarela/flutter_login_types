import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:login_bloc/ui/firebase_auth.ui.dart';
import 'package:login_bloc/ui/home.ui.dart';
import 'package:login_bloc/ui/login_biometric.ui.dart';
import 'package:login_bloc/ui/login_passcode.ui.dart';
import 'package:login_bloc/ui/login_user_pass.ui.dart';
import 'package:login_bloc/ui/sign_in_options.ui.dart';

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
            return _setPageRoute(state.pageKey, const LoginUI());
          },
        ),
        GoRoute(
          path: 'login_passcode',
          pageBuilder: (_, state) {
            return _setPageRoute(state.pageKey, const LoginPasscodeUI());
          },
        ),
        GoRoute(
          path: 'login_biometric',
          pageBuilder: (_, state) {
            return _setPageRoute(state.pageKey, const LoginBiometric());
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
