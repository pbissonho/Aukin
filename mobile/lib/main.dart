import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';

import 'app.dart';

class SimpleBlocDelegate extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    print('onEvent ${bloc.runtimeType} $event');
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print('onTransition ${bloc.runtimeType} $transition');
    super.onTransition(bloc, transition);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(App());
}
