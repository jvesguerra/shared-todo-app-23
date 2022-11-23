import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week7_networking_discussion/main.dart' as app;

void main() {
  // Define a test
  testWidgets('Test Login Widget', (tester) async {
    // Create the widget by telling the tester to build it along with the provider the widget requires

    app.main();
    //find the widgets by the text or by their keys
    final screenDisplay = find.text('Login');
    final userNameField = find.byKey(const Key("emailField"));
    final passwordField = find.byKey(const Key("pwField"));
    final loginButton = find.byKey(const Key("loginButton"));
    final signUpButton = find.byKey(const Key("signUpButton"));

    // Use the `findsOneWidget` matcher provided by flutter_test to
    // verify that the Text widgets and Button widgets appear exactly once in the widget tree.
    expect(screenDisplay, findsOneWidget);
    expect(userNameField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(loginButton, findsOneWidget);
    expect(signUpButton, findsOneWidget);

    // test sign up page widgets
    await tester.tap(signUpButton);
    final signupDisplay = find.text("Sign Up");
    final sUserNameField = find.byKey(const Key("emailField"));
    final sPasswordField = find.byKey(const Key("pwField"));
    final fnameField = find.byKey(const Key("fNameField"));
    final lnameField = find.byKey(const Key("lNameField"));
    expect(signupDisplay, findsOneWidget);
    expect(sUserNameField, findsOneWidget);
    expect(sPasswordField, findsOneWidget);
    expect(fnameField, findsOneWidget);
    expect(lnameField, findsOneWidget);
  });
}
