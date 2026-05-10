import 'dart:math';
import 'dart:typed_data';

import 'package:base32/base32.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

typedef QrInfo = ({String issuer, String secret, String accountName});

class TotpCoreService {
  TotpCoreService({required this.flutterSecureStorage});

  final FlutterSecureStorage flutterSecureStorage;

  String generateSecret() {
    final random = Random.secure();
    return base32.encode(
      Uint8List.fromList(List<int>.generate(20, (_) => random.nextInt(256))),
    );
  }

  String generateQrUri({required QrInfo qrInfo}) {
    return 'otpauth://totp/${qrInfo.issuer}:${qrInfo.accountName}'
        '?secret=${qrInfo.secret}&issuer=${qrInfo.issuer}&algorithm=SHA1'
        '&digits=6&period=30';
  }

  Future<String?> getTotpSecret(String userId, String keyPrefix) =>
      flutterSecureStorage.read(key: '$keyPrefix$userId');

  Future<void> saveTotpSecret(String userId, String secret, String keyPrefix) =>
      flutterSecureStorage.write(key: '$keyPrefix$userId', value: secret);

  bool verifyCode({required String secret, required String code}) {
    final currentStep = DateTime.now().millisecondsSinceEpoch ~/ 30000;
    for (var i = -1; i <= 1; i++) {
      if (_generateCode(secret, currentStep + i) == code) return true;
    }
    return false;
  }

  String _generateCode(String secret, int timeStep) {
    final keyBytes = base32.decode(secret.toUpperCase());
    final timeBytes = Uint8List(8)..buffer.asByteData().setUint64(0, timeStep);

    final hmac = Hmac(sha1, keyBytes);
    final digest = hmac.convert(timeBytes).bytes;

    final offset = digest.last & 0x0F;
    final code =
        ((digest[offset] & 0x7F) << 24) |
        ((digest[offset + 1] & 0xFF) << 16) |
        ((digest[offset + 2] & 0xFF) << 8) |
        (digest[offset + 3] & 0xFF);

    return (code % 1000000).toString().padLeft(6, '0');
  }
}
