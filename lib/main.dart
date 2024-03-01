import 'package:flutter_login_types/app.dart';
import 'package:flutter_login_types/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const LoginApp());
}
