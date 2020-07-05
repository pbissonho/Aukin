import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:identity_auth/identity_auth.dart';
import 'package:koin_flutter/koin_bloc.dart';
import 'package:meta/meta.dart';

part 'forget_event.dart';
part 'forget_state.dart';

class ForgetBloc extends Bloc<ForgetEvent, ForgetState> implements Disposable {
  final IdentiyAuth identiyAuth;

  ForgetBloc(this.identiyAuth);

  @override
  ForgetState get initialState => ForgetState();

  @override
  Stream<ForgetState> mapEventToState(
    ForgetEvent event,
  ) async* {
    if (event is SendEmailEvent) {
      try {
        yield state.copyWith(status: ForgetStateStatus.loading);
        await identiyAuth.generatePasswordResetToken(email: event.email);
        yield state.copyWith(
            email: event.email,
            status: ForgetStateStatus.successForgetCodeSend);
        await Future.delayed(Duration(milliseconds: 800));
        yield state.copyWith(
            email: event.email, status: ForgetStateStatus.verifyCodeInitial);
      } catch (error) {
        yield state.copyWith(
            email: event.email, status: ForgetStateStatus.failed);
      }
    }

    if (event is VerifiyCodeEvent) {
      try {
        yield state.copyWith(status: ForgetStateStatus.loading);
        var token =
            await identiyAuth.verifyCode(email: state.email, code: event.code);
        yield state.copyWith(
            token: token, status: ForgetStateStatus.successVerifyCode);
        await Future.delayed(Duration(milliseconds: 800));
        yield state.copyWith(status: ForgetStateStatus.resetAccountInitial);
      } catch (error) {
        yield state.copyWith(status: ForgetStateStatus.failed);
      }
    }

    if (event is ResetAccountEvent) {
      try {
        yield state.copyWith(status: ForgetStateStatus.loading);
        await identiyAuth.resetPassword(
            email: state.email,
            token: state.token,
            confirmPassword: event.confirmpassword,
            password: event.password);
        yield state.copyWith(status: ForgetStateStatus.successAccountReset);
        await Future.delayed(Duration(milliseconds: 800));
        yield state.copyWith(status: ForgetStateStatus.resetCompleted);
      } catch (error) {
        yield state.copyWith(status: ForgetStateStatus.failed);
      }
    }
  }

  @override
  void dispose() => close();
}
