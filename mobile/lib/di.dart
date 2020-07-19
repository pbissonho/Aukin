import 'package:dio/dio.dart';
import 'package:authentication/authentication/bloc/authentication_bloc.dart';
import 'package:identity_client/identity_client.dart';
import 'package:koin/koin.dart';
import 'package:koin_flutter/koin_bloc.dart';
import 'package:identity_auth/identity_auth.dart';
import 'config.dart';
import 'forget_password/bloc/forget_bloc.dart';
import 'forget_password/forget_page.dart';
import 'home/bloc/user_bloc.dart';
import 'home/home_page.dart';
import 'home/repository_sample.dart';
import 'login/bloc/login_bloc.dart';
import 'login/login_page.dart';
import 'signup/bloc/sign_up_bloc.dart';
import 'signup/sign_up_page.dart';
import 'scope_one_extension.dart';

final dev = [dataModuleFake, authModule];
final prod = [dataModule, authModule];

final dio = Dio(BaseOptions(baseUrl: apiUrl));

final dataModule = Module()
  ..single((s) => IdentityService(Dio(BaseOptions(baseUrl: apiUrl))))
  ..single((s) => RepositorySample(dio));

final dataModuleFake = Module()
  ..single<IdentityService>((s) => FakeIdentityService())
  ..single<RepositorySample>((s) => RepositorySampleFake());

final authModule = Module()
  ..single((s) => IdentityClient(
      fresh: IdentityFresh(SecureTokenStorage()),
      httpClient: dio,
      identityService: s.get()))
  ..single((s) => IdentiyAuth(s.get()))
  ..bloc((s) => AuthenticationBloc(s.get()))
  ..scopeOneBloc<LoginBloc, Login>((scope) => LoginBloc(scope.get()))
  ..scopeOneBloc<UserBloc, HomePage>((scope) => UserBloc(scope.get()))
  ..scopeOneBloc<SignUpBloc, SignUpPage>((scope) => SignUpBloc(scope.get()))
  ..scopeOneBloc<ForgetBloc, ForgetPage>((scope) => ForgetBloc(scope.get()));


