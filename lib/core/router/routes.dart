import 'package:flutter/foundation.dart';
import 'package:flutter_login_types/core/router/app_route_path.dart';
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
  initialLocation: AppRoutePath.loginOptions.goRoute,
  routes: <GoRoute>[
    GoRoute(
      path: AppRoutePath.loginOptions.goRoute,
      pageBuilder: (_, state) => ScreenPage<dynamic>(
        key: state.pageKey,
        child: const LoginOptionsView(),
      ),
      routes: <GoRoute>[
        GoRoute(
          path: AppRoutePath.loginOptions.userPassword.goRoute,
          pageBuilder: (_, state) => ScreenPage<dynamic>(
            key: state.pageKey,
            child: const SimpleLoginView(),
          ),
        ),
        GoRoute(
          path: AppRoutePath.loginOptions.passcode.goRoute,
          pageBuilder: (_, state) => ScreenPage<dynamic>(
            key: state.pageKey,
            child: const PasscodeLoginView(),
          ),
        ),
        GoRoute(
          path: AppRoutePath.loginOptions.biometric.goRoute,
          pageBuilder: (_, state) => ScreenPage<dynamic>(
            key: state.pageKey,
            child: const FingerPrintLoginView(),
          ),
        ),
        GoRoute(
          path: AppRoutePath.loginOptions.third.goRoute,
          pageBuilder: (_, state) => ScreenPage<dynamic>(
            key: state.pageKey,
            child: const ThirdLoginView(),
          ),
        ),
        GoRoute(
          path: AppRoutePath.loginOptions.mechanism.goRoute,
          pageBuilder: (_, state) => ScreenPage<dynamic>(
            key: state.pageKey,
            child: const MechanismLoginView(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutePath.home.goRoute,
      pageBuilder: (_, state) => ScreenPage<dynamic>(
        key: state.pageKey,
        child: const HomeView(),
      ),
    ),
  ],
  debugLogDiagnostics: kDebugMode,
);
