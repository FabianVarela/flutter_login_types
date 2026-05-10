import 'dart:async';

import 'package:flutter_login_types/core/dependencies/dependencies.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Account name could be Microsoft, Google, empty etc adding userId.
typedef QrData = ({String secret, String account});

class GenerateQrNotifier extends AsyncNotifier<String> {
  GenerateQrNotifier(this.data);

  final QrData data;

  static const _issuer = 'FlutterLoginTypes';

  @override
  FutureOr<String> build() async {
    final totpCore = ref.watch(totpCoreServiceProvider);
    return totpCore.generateQrUri(
      qrInfo: (issuer: _issuer, secret: data.secret, accountName: data.account),
    );
  }
}

final generateQrProvider = AsyncNotifierProvider.autoDispose
    .family<GenerateQrNotifier, String, QrData>(GenerateQrNotifier.new);
