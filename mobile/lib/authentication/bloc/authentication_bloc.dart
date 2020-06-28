import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:koin_flutter/koin_bloc.dart';
import 'package:identity_auth/identity_auth.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState>
    implements Disposable {
  AuthenticationBloc(IdentiyAuth userRepository)
      : assert(userRepository != null),
        _userRepository = userRepository {
    _subscription = _userRepository.authenticationStatus.listen((status) {
      add(AuthenticationStatusChanged(status));
    });
  }

  StreamSubscription<UserAuthenticationStatus> _subscription;
  final IdentiyAuth _userRepository;

  @override
  AuthenticationState get initialState => AuthenticationUnknown();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationStatusChanged) {
      yield _mapAuthenticationStatusChangedToState(event);
    } else if (event is LoggedOut) {
      _userRepository.signOut();
    }
  }

  AuthenticationState _mapAuthenticationStatusChangedToState(
    AuthenticationStatusChanged event,
  ) {
    switch (event.authenticationStatus) {
      case UserAuthenticationStatus.signedIn:
        return AuthenticationAuthenticated();
      case UserAuthenticationStatus.signedOut:
        return AuthenticationUnauthenticated();
      case UserAuthenticationStatus.unknown:
      default:
        return AuthenticationUnknown();
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }

  @override
  void dispose() => close();
}
