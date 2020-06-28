import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginWithCredentials extends LoginEvent {
  final String name;
  final String password;

  LoginWithCredentials(this.name, this.password);

  @override
  List<Object> get props => [name, password];
}
