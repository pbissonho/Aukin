import 'package:equatable/equatable.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  bool get stringify => true;
  
  @override
  List<Object> get props => [];
}

class SignUpLoading extends SignUpState {}

class SignUpStarted extends SignUpState {}

class SuccessRegistered extends SignUpState {}

class SignUpCreatedAccount extends SignUpState {}

class SignUpFailed extends SignUpState {
  SignUpFailed(this.messages);

  final List<String> messages;

  @override
  List<Object> get props => [messages];
}
