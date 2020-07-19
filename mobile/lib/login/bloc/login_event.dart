import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginWithCredentials extends LoginEvent {
  LoginWithCredentials(this.name, this.password);

  final String name;
  final String password;

  @override
  List<Object> get props => [name, password];
}
