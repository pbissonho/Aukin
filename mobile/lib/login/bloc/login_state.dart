import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {}

class LoginStarted extends LoginState {}

class LoginFailure extends LoginState {
  final String message;

  LoginFailure(this.message);
}

class LoginSuccess extends LoginState {}


