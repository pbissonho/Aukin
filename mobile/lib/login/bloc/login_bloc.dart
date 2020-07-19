import 'package:bloc/bloc.dart';
import 'package:koin_flutter/koin_bloc.dart';
import 'package:identity_auth/identity_auth.dart';
import 'login_event.dart';
import 'login_state.dart';
import 'package:identity_client/identity_client.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> with Disposable {
  LoginBloc(this.identiyAuth) : super(LoginStarted());

  final IdentiyAuth identiyAuth;

  Stream<LoginState> _signInWithCredentials(LoginWithCredentials event) async* {
    yield LoginLoading();
    // Delayed Just for test
    await Future.delayed(Duration(milliseconds: 500));

    try {
      await identiyAuth.signInWithAccessCredentials(
        username: event.name,
        password: event.password,
      );
      yield LoginSuccess();
    } on ServerException catch (data) {
      yield LoginFailure(data.error.messages);
    } on Exception catch (_) {
      yield LoginFailure(["Login failed."]);
    }
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginWithCredentials) yield* _signInWithCredentials(event);
  }

  @override
  void dispose() => close();
}
