import 'package:dio/dio.dart';
import 'package:authentication/authentication/bloc/authentication_bloc.dart';
import 'package:identity_client/identity_client.dart';
import 'package:koin/koin.dart';
import 'package:koin_flutter/koin_bloc.dart';
import 'package:identity_auth/identity_auth.dart';
import 'forget_password/bloc/forget_bloc.dart';
import 'forget_password/forget_page.dart';
import 'home/bloc/user_bloc.dart';
import 'home/home_page.dart';
import 'home/repository_sample.dart';
import 'login/bloc/login_bloc.dart';
import 'login/login_page.dart';
import 'signup/bloc/sign_up_bloc.dart';
import 'signup/sign_up_page.dart';

String url = "https://authtest4.azurewebsites.net";
var coreModule = Module()..single((s) => Dio(BaseOptions(baseUrl: url)));

var dev = authModuleFake + authScopesModuleFake;
var prod = authModule + authScopesModule;

var authModule = Module()
  ..single((s) => IdentityClient(
      fresh: IdentityFresh(SecureTokenStorage()),
      httpClient: s.get(),
      identityService: IdentityService(Dio(BaseOptions(baseUrl: url)))))
  ..single((s) => IdentiyAuth(s.get()))
  ..bloc((s) => AuthenticationBloc(s.get()));

var authScopesModule = module()
  ..scope<Login>((s) {
    s.scopedBloc((s) => LoginBloc(s.get()));
  })
  ..scope<HomePage>((scope) {
    scope
      ..scopedBloc((s) => UserBloc(s.get()))
      ..scoped<RepositorySample>((s) => RepositorySample(s.get()));
  })
  ..scope<SignUpPage>((s) {
    s.scopedBloc((s) => SignUpBloc(s.get()));
  })
  ..scope<ForgetPage>((s) {
    s.scopedBloc((s) => ForgetBloc(s.get()));
  });

var authModuleFake = Module()
  ..single((s) => IdentityClient(
      fresh: IdentityFresh(SecureTokenStorage()),
      httpClient: s.get(),
      identityService: FakeIdentityService()))
  ..single((s) => IdentiyAuth(s.get()))
  ..bloc((s) => AuthenticationBloc(s.get()));

var authScopesModuleFake = module()
  ..scope<Login>((s) {
    s.scopedBloc((s) => LoginBloc(s.get()));
  })
  ..scope<HomePage>((scope) {
    scope
      ..scopedBloc((s) => UserBloc(s.get()))
      ..scoped<RepositorySample>((s) => RepositorySampleFake());
  })
  ..scope<SignUpPage>((s) {
    s.scopedBloc((s) => SignUpBloc(s.get()));
  })
  ..scope<ForgetPage>((s) {
    s.scopedBloc((s) => ForgetBloc(s.get()));
  });
