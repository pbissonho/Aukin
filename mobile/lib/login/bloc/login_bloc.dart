import 'package:bloc/bloc.dart';
import 'package:identity_auth/identity_auth.dart';
import 'login_state.dart';
import 'package:identity_client/identity_client.dart';

class LoginBloc extends Cubit<LoginState> {
  LoginBloc(this.identiyAuth) : super(LoginStarted());

  final IdentiyAuth identiyAuth;

  Future<void> signInWithCredentials(String name, String password) async {
    emit(LoginLoading());
    // Delayed Just for test
    await Future.delayed(Duration(milliseconds: 500));
    try {
      await identiyAuth.signInWithAccessCredentials(
        username: name,
        password: password,
      );
      emit(LoginSuccess());
    } on ServerException catch (data) {
      emit(LoginFailure(data.error.messages));
    } on Exception catch (_) {
      emit(LoginFailure(['Login failed.']));
    }
  }

  @override
  String toString() {
    return state.toString();
  }
}
