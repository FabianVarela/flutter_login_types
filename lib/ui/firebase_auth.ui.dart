import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:login_bloc/l10n/l10n.dart';

class FirebaseAuthUI extends StatelessWidget {
  const FirebaseAuthUI({super.key});

  @override
  Widget build(BuildContext context) {
    const clientId = String.fromEnvironment('CLIENT_ID');
    final localization = context.localizations;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return SignInScreen(
              headerBuilder: (_, __, ___) => Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    'https://firebase.flutter.dev/img/flutterfire_300x.png',
                  ),
                ),
              ),
              subtitleBuilder: (_, action) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  action == AuthAction.signIn
                      ? localization.firebaseSubtitleSignIn
                      : localization.firebaseSubtitleSignUp,
                ),
              ),
              providerConfigs: const [
                EmailProviderConfiguration(),
                GoogleProviderConfiguration(clientId: clientId),
                FacebookProviderConfiguration(clientId: clientId),
                AppleProviderConfiguration(),
              ],
              footerBuilder: (_, action) => Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  action == AuthAction.signIn
                      ? localization.firebaseFooterSignIn
                      : localization.firebaseFooterSignUp,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            );
          }

          return const ProfileScreen();
        },
      ),
    );
  }
}
