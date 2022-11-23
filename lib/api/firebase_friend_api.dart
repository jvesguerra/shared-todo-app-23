/*
Author: Joshua V. Esguerra
Section: C4L
Date created: November 19, 2022
Exercise number: 6
Program Description: Simple Friends App
*/

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/friend_model.dart';

class FirebaseFriendAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addFriend(Map<String, dynamic> friend) async {
    try {
      final docRef = await db.collection("friends_list").add(friend);
      await db
          .collection("friends_list")
          .doc(docRef.id)
          .update({'id': docRef.id});

      return "Successfully added friend!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllFriends() {
    return db.collection("friends_list").snapshots();
  }

  Future<String> deleteFriend(String? id) async {
    try {
      await db.collection("friends_list").doc(id).delete();

      return "Successfully deleted friend!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> editFriend(
      String? id, String displayName, String userName) async {
    try {
      print("New String: $displayName");
      await db
          .collection("friends_list")
          .doc(id)
          .update({"displayName": displayName, "userName": userName});

      return "Successfully edited friend!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> sendFriendRequest(String? id, String friendId) async {
    try {
      print("New Request: $friendId");
      await db.collection("friends_list").doc(id).update({
        "receivedFriendRequests": FieldValue.arrayUnion([friendId])
      });

      await db.collection("friends_list").doc(friendId).update({
        "sentFriendRequests": FieldValue.arrayUnion([id])
      });
      // await db.collection("friends_list").doc(friendId).update({
      //   "receivedFriendRequests": FieldValue.arrayUnion([id])
      // });
      return "Successfully sent friend request!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  // id is the selected Person
  // user is where we will accept
  Future<String> acceptFriend(String? id, String? user) async {
    try {
      print("New String: $user");

      // update friends list
      await db.collection("friends_list").doc(user).update({
        "friends": FieldValue.arrayUnion([id]),
      });

      await db.collection("friends_list").doc(id).update({
        "friends": FieldValue.arrayUnion([user]),
      });

      // remove current user in the received requests of the selected user
      await db.collection("friends_list").doc(user).update({
        "receivedFriendRequests": FieldValue.arrayRemove([id])
      });

      //  remove the selected user in the sent friend requests
      await db.collection("friends_list").doc(id).update({
        "sentFriendRequests": FieldValue.arrayRemove([user])
      });

      return "Successfully accepted friend!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> rejectFriend(String? id, String? user) async {
    try {
      print("New String: $user");

      // remove current user in the received requests of the selected user
      await db.collection("friends_list").doc(user).update({
        "receivedFriendRequests": FieldValue.arrayRemove([id])
      });

      //  remove the selected user in the sent friend requests
      await db.collection("friends_list").doc(id).update({
        "sentFriendRequests": FieldValue.arrayRemove([user])
      });

      return "Successfully rejected friend!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> unfriend(String? id, String? user) async {
    try {
      print("New String: $user");
      print("id String: $id");

      // update friends list
      await db.collection("friends_list").doc(user).update({
        "friends": FieldValue.arrayRemove([id]),
      });

      return "Successfully removed friend!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> showFriendRequest(String? id) {
    return db.collection("friends_list").snapshots();
  }

  Stream<QuerySnapshot> showAllFriends(String? id) {
    return db.collection("friends_list").snapshots();
  }

  Future<String> toggleStatus(String? id, bool status) async {
    try {
      await db.collection("friends_list").doc(id).update({"completed": status});

      return "Successfully edited friend!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}
