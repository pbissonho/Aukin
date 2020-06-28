import 'package:bloc/bloc.dart';
import 'package:identity_client/identity_client.dart';
import 'package:koin_flutter/koin_bloc.dart';

import 'sign_up_event.dart';
import 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> with Disposable {
  final IdentityClient identityClient;

  SignUpBloc(this.identityClient);

  Stream<SignUpState> _signUpHandler(
      CreateUserWithRegisterCredentials event) async* {
    yield SignUpLoading();
    await Future.delayed(Duration(milliseconds: 700));

    try {
      await identityClient.createUserWithRegisterCredentials(
          password: event.password,
          userEmail: event.email,
          username: event.name);
      yield SuccessRegistered();
      await Future.delayed(Duration(milliseconds: 700));
      yield SignUpCreatedAccount();
    } catch (erro) {
      yield SignUpFailed([
        "Já existe um usuário cadastro com o nome. Digite outro por favor.",
        "Test"
      ]);
    }
  }

  @override
  SignUpState get initialState => SignUpStarted();

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is CreateUserWithRegisterCredentials)
      yield* _signUpHandler(event);
  }

  @override
  void dispose() => close();
}
