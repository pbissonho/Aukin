import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {}

class LoginStarted extends LoginState {}

class LoginFailure extends LoginState {
  final List<String> messages;

  LoginFailure(this.messages);
}

class LoginSuccess extends LoginState {}
