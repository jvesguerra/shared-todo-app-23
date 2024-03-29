/*
  Author: Joshua V. Esguerra
  Section: C4L
  Date created: November 22, 2022
  Exercise number: 7
  Program Description: User Authentication and Automated Tests
  */
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:week7_networking_discussion/api/firebase_auth_api.dart';

class AuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  User? userObj;

  AuthProvider() {
    authService = FirebaseAuthAPI();
    authService.getUser().listen((User? newUser) {
      userObj = newUser;
      print('AuthProvider - FirebaseAuth - onAuthStateChanged - $newUser');
      notifyListeners();
    }, onError: (e) {
      // provide a more useful error
      print('AuthProvider - FirebaseAuth - onAuthStateChanged - $e');
    });
  }

  User? get user => userObj;

  bool get isAuthenticated {
    return user != null;
  }

  void signIn(String email, String password) {
    authService.signIn(email, password);
  }

  // Future<String> signIn(String email, String password) async {
  //   String message = await authService.signIn(email, password);
  //   return message;
  // }

  void signOut() {
    authService.signOut();
  }

  void signUp(
    String email,
    String password,
    String firstName,
    String lastName,
    String userName,
    String birthDate,
    String location,
  ) {
    authService.signUp(
        email, password, firstName, lastName, userName, birthDate, location);
  }
}
