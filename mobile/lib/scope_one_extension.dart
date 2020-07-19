import 'package:koin/koin.dart';
import 'package:koin_flutter/koin_bloc.dart';

extension SopneOneBlocExtension on Module {
  BeanDefinition<T> scopeOneBloc<T extends Disposable, TScope>(
    DefinitionFunction<T> definition, {
    Qualifier qualifier,
    bool createdAtStart = false,
    bool override = false,
  }) {
    final beanDefinition = scopeOne<T, TScope>(definition,
        qualifier: qualifier,
        createdAtStart: createdAtStart,
        override: override);
    beanDefinition.onClose((value) => value.dispose());
    return beanDefinition;
  }
}