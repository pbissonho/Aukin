import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:koin_flutter/koin_bloc.dart';
import 'package:meta/meta.dart';
import 'package:identity_auth/identity_auth.dart';

part 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent, IdentiyUser> implements Disposable {
  final IdentiyAuth identiyAuth;

  @override
  IdentiyUser get initialState =>
      IdentiyUser(userName: '', email: '', roles: []);
  StreamSubscription<IdentiyUser> _subscription;

  HomeBloc(this.identiyAuth) {
    _subscription = identiyAuth.currentUser.listen((onData) {
      add(UserChanged(onData));
    });
  }

  @override
  Stream<IdentiyUser> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is UserChanged) {
      yield event.identiyUser;
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  @override
  void dispose() => close();
}
