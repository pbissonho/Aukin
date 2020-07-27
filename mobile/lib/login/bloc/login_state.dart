import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class LoginLoading extends LoginState {}

class LoginStarted extends LoginState {}

class LoginFailure extends LoginState {
  LoginFailure(this.messages);

  @override
  List<Object> get props => [messages];

  final List<String> messages;
}

class LoginSuccess extends LoginState {}
