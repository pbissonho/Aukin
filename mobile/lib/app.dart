import 'package:flutter/material.dart';
import 'package:authentication/authentication/bloc/authentication_bloc.dart';
import 'package:authentication/home/home_page.dart';
import 'package:authentication/shared/hello_page.dart';
import 'package:authentication/splash/splash_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:koin/koin.dart';
import 'di.dart';
import 'theme.dart';

class App extends StatefulWidget {
  const App({
    Key key,
  }) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    startKoin((app) {
      app.printLogger(level: Level.debug);
      app.modules(dev);
    });
  }

  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    final bloc = get<AuthenticationBloc>();
    return MaterialApp(
      theme: ThemeData(primarySwatch: ColorTheme.primarySwatchColor),
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          cubit: bloc,
          listener: (context, state) {
            if (state is AuthenticationAuthenticated) {
              _navigator.pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) {
                  return HomePage();
                }),
                (_) => false,
              );
            } else if (state is AuthenticationUnauthenticated) {
              _navigator.pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) {
                  return HelloPage();
                }),
                (_) => false,
              );
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (settings) {
        if (settings.name == Navigator.defaultRouteName) {
          return SplashPage.route();
        }
        return null;
      },
    );
  }
}
