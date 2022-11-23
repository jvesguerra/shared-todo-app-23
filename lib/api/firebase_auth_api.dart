/*
  Author: Joshua V. Esguerra
  Section: C4L
  Date created: November 22, 2022
  Exercise number: 7
  Program Description: User Authentication and Automated Tests
  */
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:week7_networking_discussion/screens/login.dart';

class FirebaseAuthAPI {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  // final db = FakeFirebaseFirestore();

  // final auth = MockFirebaseAuth(
  //     mockUser: MockUser(
  //   isAnonymous: false,
  //   uid: 'someuid',
  //   email: 'charlie@paddyspub.com',
  //   displayName: 'Charlie',
  // ));

  Stream<User?> getUser() {
    return auth.authStateChanges();
  }

  void signIn(String email, String password) async {
    UserCredential credential;
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //possible to return something more useful
        //than just print an error message to improve UI/UX
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  // Future<String> signIn(String email, String password) async {
  //   UserCredential credential;
  //   try {
  //     final credential = await auth.signInWithEmailAndPassword(
  //         email: email, password: password);
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       //possible to return something more useful
  //       //than just print an error message to improve UI/UX
  //       //print('No user found for that email.');
  //       return 'No user found for that email.';
  //     } else if (e.code == 'wrong-password') {
  //       //print('Wrong password provided for that user.');
  //       return "Wrong password";
  //     }
  //   }
  //   return "tet";
  // }

  void signUp(String email, String password, String firstName, String lastName,
      String userName, String birthDate, String location) async {
    UserCredential credential;
    try {
      credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        saveUserToFirestore(credential.user?.uid, email, firstName, lastName,
            userName, birthDate, location);
      }
    } on FirebaseAuthException catch (e) {
      //possible to return something more useful
      //than just print an error message to improve UI/UX
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  void saveUserToFirestore(
      String? uid,
      String email,
      String firstName,
      String lastName,
      String userName,
      String birthDate,
      String location) async {
    try {
      await db.collection("users").doc(uid).set({
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "userName": userName,
        "birthDate": birthDate,
        "location": location
      });

      await db.collection("users").doc(uid).update({'id': uid});
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  void signOut() async {
    auth.signOut();
  }
}
