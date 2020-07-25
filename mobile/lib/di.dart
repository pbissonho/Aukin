import 'package:dio/dio.dart';
import 'package:authentication/authentication/bloc/authentication_bloc.dart';
import 'package:identity_client/identity_client.dart';
import 'package:koin/koin.dart';
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
import 'package:koin_bloc/koin_bloc.dart';

final dev = [dataModuleFake, authModule];
final prod = [dataModule, authModule];

final dio = Dio(BaseOptions(baseUrl: apiUrl));

final dataModule = Module()
  ..single((scope) => IdentityService(Dio(BaseOptions(baseUrl: apiUrl))))
  ..single((scope) => RepositorySample(dio));

final dataModuleFake = Module()
  ..single<IdentityService>((s) => FakeIdentityService())
  ..single<RepositorySample>((s) => RepositorySampleFake());

final authModule = Module()
  ..single((scope) => IdentityClient(
      fresh: IdentityFresh(SecureTokenStorage()),
      httpClient: dio,
      identityService: scope.get()))
  ..single((scope) => IdentiyAuth(scope.get()))
  ..cubit((scope) => AuthenticationBloc(scope.get()))
  ..scopeOneCubit<LoginBloc, Login>((scope) => LoginBloc(scope.get()))
  ..scopeOneCubit<SignUpBloc, SignUpPage>((scope) => SignUpBloc(scope.get()))
  ..scopeOneCubit<ForgetBloc, ForgetPage>((scope) => ForgetBloc(scope.get()))
  ..scopeOneCubit<UserBloc, HomePage>((scope) => UserBloc(scope.get()));
  
