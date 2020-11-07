import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:identity_auth/identity_auth.dart';

part 'user_event.dart';

class UserBloc extends Bloc<UserEvent, IdentiyUser> {
  UserBloc(this.identiyAuth)
      : super(IdentiyUser(userName: '', email: '', roles: [])) {
    _subscription = identiyAuth.currentUser.listen((onData) {
      add(UserChanged(onData));
    });
  }
  final IdentiyAuth identiyAuth;
  StreamSubscription<IdentiyUser> _subscription;

  @override
  Stream<IdentiyUser> mapEventToState(
    UserEvent event,
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
  String toString() => state.toString();
}
