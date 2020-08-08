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
  ..single((s) => IdentiyAuth(s.get())) // 2
  ..cubit((s) => AuthenticationBloc(s.get())) // 3
  ..scopeOneCubit<LoginBloc, Login>((s) => LoginBloc(s.get())) // 4
  ..scopeOneCubit<SignUpBloc, SignUpPage>((s) => SignUpBloc(s.get()))
  ..scopeOneCubit<ForgetBloc, ForgetPage>((s) => ForgetBloc(s.get()))
  ..scopeOneCubit<UserBloc, HomePage>((s) => UserBloc(s.get()));
