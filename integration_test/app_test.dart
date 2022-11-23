import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:week7_networking_discussion/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:week7_networking_discussion/screens/signup.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('end-to-end test', () {
    testWidgets('Signup form', (tester) async {
      app.main();

      // TODO: TEST FIELD OF LOG IN PAGE
      await tester.pumpAndSettle();

      final screenDisplay = find.text('Login');
      final userNameField = find.byKey(const Key("emailField"));
      final passwordField = find.byKey(const Key("pwField"));
      final loginButton = find.byKey(const Key("loginButton"));
      final signUpButton = find.byKey(const Key("signUpButton"));

      expect(screenDisplay, findsOneWidget);
      expect(userNameField, findsOneWidget);
      expect(passwordField, findsOneWidget);
      expect(loginButton, findsOneWidget);
      expect(signUpButton, findsOneWidget);

      // TODO: TEST EXISTENCE OF FIELDS IN THE SIGN UP PAGE
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      final signupDisplay = find.text("Sign Up");
      final sUserNameField = find.byKey(const Key("emailField"));
      final sPasswordField = find.byKey(const Key("pwField"));
      final fnameField = find.byKey(const Key("fNameField"));
      final lnameField = find.byKey(const Key("lNameField"));
      final backButton = find.byKey(const Key("backButton"));
      final signupButton = find.byKey(const Key("signupButton"));
      expect(sUserNameField, findsOneWidget);
      expect(sPasswordField, findsOneWidget);
      expect(fnameField, findsOneWidget);
      expect(lnameField, findsOneWidget);
      expect(signupDisplay, findsOneWidget);
      expect(backButton, findsOneWidget);
      expect(signupButton, findsOneWidget);

      // TODO: Check if the sign up text in the sign up page becomes not visible if the keyboard would pop out
      await tester.ensureVisible(find.byKey(const Key("signupText")));
      await tester.pumpAndSettle();

      // TODO: Test empty email and password in sign up

      await tester.tap(signupButton);
      await tester.pumpAndSettle();
      expect(find.text("Email required"), findsOneWidget);
      expect(find.text("First Name Required"), findsOneWidget);
      expect(find.text("Last Name Required"), findsOneWidget);
      expect(find.text("Password required"), findsOneWidget);

      // TODO: Fill requirements
      await tester.enterText(sUserNameField, "fantech@gmail.com");
      await tester.enterText(fnameField, "Joshua");
      await tester.enterText(lnameField, "Esguerra");
      await tester.enterText(sPasswordField, "password");
      await tester.tap(signupButton);
      await tester.pumpAndSettle();

      final screenDisplay4 = find.text('Todo'); // optimal
      expect(screenDisplay4, findsOneWidget);
    });

    testWidgets("Sign-in empty or filled", (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final signUpButton = find.byKey(const Key("signUpButton"));
      final loginButton = find.byKey(const Key("loginButton"));

      final userNameField = find.byKey(const Key("emailField"));
      final passwordField = find.byKey(const Key("pwField"));

      expect(signUpButton, findsOneWidget);

      expect(userNameField, findsOneWidget);
      expect(passwordField, findsOneWidget);
      expect(loginButton, findsOneWidget);
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      // TODO: TEST BACK BUTTON
      final backButton = find.byKey(const Key("backButton"));
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      final screenDisplay2 = find.text('Login'); // optimal
      expect(screenDisplay2, findsOneWidget);

      await tester.tap(loginButton);
      await tester.pumpAndSettle();
      expect(find.text("Email required"), findsOneWidget);
      expect(find.text("Password required"), findsOneWidget);

      // TODO: Test sign in with email and password filled
      await tester.enterText(userNameField, "joshua@gmail.com");
      await tester.enterText(passwordField, "password");
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      final screenDisplay3 = find.text('Todo'); // optimal
      expect(screenDisplay3, findsOneWidget);
    });
  });
}
