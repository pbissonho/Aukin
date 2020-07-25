import 'package:flutter/material.dart';
import 'package:authentication/authentication/bloc/authentication_bloc.dart';
import 'package:authentication/home/home_page.dart';
import 'package:authentication/shared/hello_page.dart';
import 'package:authentication/splash/splash_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:koin/koin.dart';
import 'di.dart';

const primaryColor = Color(0xff5d6abe);

class ColorTheme {
  static const MaterialColor primarySwatchColor = MaterialColor(
    _primaryValue,
    <int, Color>{
      50: Color(0xFFecedf7),
      100: Color(0xFFced2ec),
      200: Color(0xFFaeb5df),
      300: Color(0xFF8e97d2),
      400: Color(0xFF7580c8),
      500: Color(0xFF5d6abe),
      600: Color(0xFF5562b8),
      700: Color(0xFF4b57af),
      800: Color(0xFF414da7),
    },
  );
  static const int _primaryValue = 0xFF5d6abe;
}

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
    return MaterialApp(
      theme: ThemeData(primarySwatch: ColorTheme.primarySwatchColor),
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          cubit: get<AuthenticationBloc>(),
          listener: (context, state) {
            if (state is AuthenticationAuthenticated) {
              ;
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
