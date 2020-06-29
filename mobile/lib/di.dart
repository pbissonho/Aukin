import 'package:dio/dio.dart';
import 'package:authentication/authentication/bloc/authentication_bloc.dart';
import 'package:identity_client/identity_client.dart';
import 'package:koin/koin.dart';
import 'package:koin_flutter/koin_bloc.dart';
import 'package:identity_auth/identity_auth.dart';
import 'home/bloc/home_bloc.dart';
import 'home/home_page.dart';
import 'login/bloc/login_bloc.dart';
import 'login/login_page.dart';
import 'signup/bloc/sign_up_bloc.dart';
import 'signup/sign_up_page.dart';

String url = "https://authtest4.azurewebsites.net";

var coreModule = Module()..single((s) => Dio(BaseOptions(baseUrl: url)));
var service = IdentityService(
    Dio(BaseOptions(baseUrl: 'https://authtest4.azurewebsites.net')));
    
var authModule = Module()
  ..single((s) => IdentityClient(
      fresh: IdentityFresh(SecureTokenStorage()),
      httpClient: s.get(),
      identityService: FakeIdentityService()))
  ..single((s) => IdentiyAuth(s.get()))
  ..bloc((s) => AuthenticationBloc(s.get()));

var authScopesModule = module()
  ..scope<Login>((s) {
    s.scopedBloc((s) => LoginBloc(s.get()));
  })
  ..scope<HomePage>((s) {
    s.scopedBloc((s) => HomeBloc(s.get()));
  })
  ..scope<SignUpPage>((s) {
    s.scopedBloc((s) => SignUpBloc(s.get()));
  });
