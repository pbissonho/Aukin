import 'package:authentication/di.dart';
import 'package:koin_test/koin_test.dart';

void main() {
  testKoinDeclaration('appModules', (app) {
    app.modules([coreModule, authModule, authScopesModule]);
  }, checkParameters: checkParametersOf({}));
}
