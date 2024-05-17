import 'package:flutter/foundation.dart';
import 'package:flutter_login_types/core/router/page_routes.dart';
import 'package:flutter_login_types/features/fingerprint_login/view/fingerprint_login_view.dart';
import 'package:flutter_login_types/features/home/view/home_view.dart';
import 'package:flutter_login_types/features/login_options/view/login_options_view.dart';
import 'package:flutter_login_types/features/mechanism_login/view/mechanism_login_view.dart';
import 'package:flutter_login_types/features/passcode_login/view/passcode_login_view.dart';
import 'package:flutter_login_types/features/simple_login/view/simple_login_view.dart';
import 'package:flutter_login_types/features/third_login/view/third_login_view.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      pageBuilder: (_, state) => ScreenPage<dynamic>(
        key: state.pageKey,
        child: const LoginOptionsView(),
      ),
      routes: <GoRoute>[
        GoRoute(
          path: 'login_user_pass',
          pageBuilder: (_, state) => ScreenPage<dynamic>(
            key: state.pageKey,
            child: const SimpleLoginView(),
          ),
        ),
        GoRoute(
          path: 'login_passcode',
          pageBuilder: (_, state) => ScreenPage<dynamic>(
            key: state.pageKey,
            child: const PasscodeLoginView(),
          ),
        ),
        GoRoute(
          path: 'login_biometric',
          pageBuilder: (_, state) => ScreenPage<dynamic>(
            key: state.pageKey,
            child: const FingerPrintLoginView(),
          ),
        ),
        GoRoute(
          path: 'third_login',
          pageBuilder: (_, state) => ScreenPage<dynamic>(
            key: state.pageKey,
            child: const ThirdLoginView(),
          ),
        ),
        GoRoute(
          path: 'mechanism_login',
          pageBuilder: (_, state) => ScreenPage<dynamic>(
            key: state.pageKey,
            child: const MechanismLoginView(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (_, state) => ScreenPage<dynamic>(
        key: state.pageKey,
        child: const HomeView(),
      ),
    ),
  ],
  debugLogDiagnostics: kDebugMode,
);
