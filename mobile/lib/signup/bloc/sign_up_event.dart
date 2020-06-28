import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class CreateUserWithRegisterCredentials extends SignUpEvent {
  final String email;
  final String name;
  final String password;
  final String confirmPassword;

  CreateUserWithRegisterCredentials(
      {@required this.email,
      @required this.password,
      @required this.confirmPassword,
      @required this.name});

  @override
  List<Object> get props => [email, password, confirmPassword];
}
