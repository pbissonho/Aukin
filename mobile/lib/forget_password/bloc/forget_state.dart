part of 'forget_bloc.dart';

enum ForgetStateStatus {
  initial,
  loading,
  failed,
  successForgetCodeSend,
  verifyCodeInitial,
  successVerifyCode,
  resetAccountInitial,
  successAccountReset,
  resetCompleted
}

class ForgetState with EquatableMixin {
  ForgetState(
      {this.email = '',
      this.token = '',
      this.status = ForgetStateStatus.initial});

  final ForgetStateStatus status;
  final String email;
  final String token;

  ForgetState copyWith({
    ForgetStateStatus status,
    String email,
    String token,
  }) {
    return ForgetState(
      status: status ?? this.status,
      email: email ?? this.email,
      token: token ?? this.token,
    );
  }

  @override
  List<Object> get props => [status, email, token];

  @override
  bool get stringify => true;
}
