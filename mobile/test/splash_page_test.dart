import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:authentication/splash/splash_page.dart';

void main() {
  group('SplashPage', () {
    testWidgets('should render "Splash Page"', (tester) async {
      await tester.pumpWidget(MaterialApp(home: SplashPage()));
      expect(find.text('Splash Page'), findsOneWidget);
    });
  });
}
