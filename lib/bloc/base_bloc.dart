import 'package:rxdart/rxdart.dart';

abstract class BaseBloc {
  final loading = PublishSubject<bool>();

  Stream<bool> get isLoading => loading.stream;

  void clean(Subject subject) {
    Future.delayed(Duration(milliseconds: 200), () => subject.sink.add(null));
  }

  void dispose();
}
