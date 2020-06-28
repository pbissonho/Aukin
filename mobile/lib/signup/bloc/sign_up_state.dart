import 'package:equatable/equatable.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

class SignUpLoading extends SignUpState {}

class SignUpStarted extends SignUpState {}

class SuccessRegistered extends SignUpState {}

class SignUpCreatedAccount extends SignUpState {}

class SignUpFailed extends SignUpState {
  final List<String> messages;

  SignUpFailed(this.messages);

  List<Object> get props => [messages];
}
