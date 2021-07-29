import 'package:rxdart/rxdart.dart';

abstract class BaseBloc {
  final loading = PublishSubject<bool>();

  Stream<bool> get isLoading => loading.stream;

  void dispose();
}
