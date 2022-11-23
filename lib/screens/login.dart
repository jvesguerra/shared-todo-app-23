// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
/*
  Author: Joshua V. Esguerra
  Section: C4L
  Date created: November 22, 2022
  Exercise number: 7
  Program Description: User Authentication and Automated Tests
  */
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/screens/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    String _error = "";
    final formKey = GlobalKey<FormState>();
    //Future<String> _error;
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    final email = TextFormField(
      key: const Key('emailField'),
      controller: emailController,
      decoration: const InputDecoration(
        hintText: "Email",
      ),
      validator: (email) {
        if (email!.isEmpty) {
          return 'Email required';
        } else if (!EmailValidator.validate(email)) {
          return 'Email a valid email';
        } else {
          return null;
        }
      },
    );

    final password = TextFormField(
        key: const Key('pwField'),
        controller: passwordController,
        obscureText: true,
        decoration: const InputDecoration(
          hintText: 'Password',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Password required';
          } else {
            return null;
          }
        });

    // Future<String> getError() async {
    //   _error = await context
    //       .read<AuthProvider>()
    //       .signIn(emailController.text, passwordController.text);
    //   return _error;
    // }

    final loginButton = Padding(
      key: const Key('loginButton'),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          final isValidForm = formKey.currentState!.validate();
          if (isValidForm) {
            context
                .read<AuthProvider>()
                .signIn(emailController.text, passwordController.text);
            //getError();
          }
        },
        child: const Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final signUpButton = Padding(
      key: const Key('signUpButton'),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SignupPage(),
            ),
          );
        },
        child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
      ),
    );

    // Widget showAlert() {
    //   print(_error);
    //   return Container(
    //     color: Colors.amberAccent,
    //     width: double.infinity,
    //     padding: EdgeInsets.all(8.0),
    //     child: Row(children: <Widget>[
    //       Icon(Icons.error_outline),
    //       Expanded(
    //         child: Text(_error),
    //       )
    //     ]),
    //   );
    // }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        autovalidateMode: AutovalidateMode.disabled,
        key: formKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 40.0, right: 40.0),
            children: <Widget>[
              const Text(
                "Login",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
              //showAlert(),
              email,
              password,
              loginButton,
              signUpButton,
            ],
          ),
        ),
      ),
    );
  }
}
