import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {}

class LoginStarted extends LoginState {}

class LoginFailure extends LoginState {
  LoginFailure(this.messages);

  final List<String> messages;
}

class LoginSuccess extends LoginState {}
