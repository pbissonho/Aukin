part of 'forget_bloc.dart';

@immutable
abstract class ForgetEvent {}

class SendEmailEvent extends ForgetEvent {
  SendEmailEvent({@required this.email});
  final String email;
}

class VerifiyCodeEvent extends ForgetEvent {
  VerifiyCodeEvent({@required this.code});
  final String code;
}

class ResetAccountEvent extends ForgetEvent {
  ResetAccountEvent({
    @required this.password,
    @required this.confirmpassword,
  });
  final String password;
  final String confirmpassword;
}
