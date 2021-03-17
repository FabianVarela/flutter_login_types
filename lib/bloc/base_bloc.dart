import 'package:rxdart/rxdart.dart';

abstract class BaseBloc {
  final loading = PublishSubject<bool>();

  Stream<bool> get isLoading => loading.stream;

  void clean(Subject subject, {dynamic value}) {
    Future.delayed(Duration(milliseconds: 300), () => subject.sink.add(value));
  }

  void dispose();
}
