/*
Author: Joshua V. Esguerra
Section: C4L
Date created: November 19, 2022
Exercise number: 6
Program Description: Simple Friends App
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:week7_networking_discussion/api/firebase_friend_api.dart';
import 'package:week7_networking_discussion/models/friend_model.dart';

class FriendListProvider with ChangeNotifier {
  late FirebaseFriendAPI firebaseService;
  late Stream<QuerySnapshot> _friendsStream;
  Friend? _selectedFriend;

  FriendListProvider() {
    firebaseService = FirebaseFriendAPI();
    fetchFriends();
  }

  Stream<QuerySnapshot> get friends => _friendsStream;
  Friend get selected => _selectedFriend!;

  changeSelectedFriend(Friend item) {
    _selectedFriend = item;
  }

  fetchFriends() {
    _friendsStream = firebaseService.getAllFriends();
    notifyListeners();
  }

  showFriendRequest() {
    _friendsStream = firebaseService.getAllFriends();
    notifyListeners();
  }

  showAllFriends() {
    _friendsStream = firebaseService.getAllFriends();
    notifyListeners();
  }

  //List<Todo> get todo => _todoList;

  void addFriend(Friend item) async {
    String message = await firebaseService.addFriend(item.toJson(item));
    print(message);
    notifyListeners();
  }

  void sendFriendRequest(String newString) async {
    String message =
        await firebaseService.sendFriendRequest(_selectedFriend!.id, newString);
    print(message);
    notifyListeners();
  }

  void editFriend(String displayName, String userName) async {
    String message = await firebaseService.editFriend(
        _selectedFriend!.id, displayName, userName);
    print(message);
    notifyListeners();
  }

  void acceptFriend(String? userName) async {
    String message =
        await firebaseService.acceptFriend(_selectedFriend!.id, userName);
    print(message);
    notifyListeners();
  }

  void rejectFriend(String? userName) async {
    String message =
        await firebaseService.rejectFriend(_selectedFriend!.id, userName);
    print(message);
    notifyListeners();
  }

  void unfriend(String? userName) async {
    String message =
        await firebaseService.unfriend(_selectedFriend!.id, userName);
    print(message);
    notifyListeners();
  }

  void deleteFriend() async {
    String message = await firebaseService.deleteFriend(_selectedFriend!.id);
    print(message);
    notifyListeners();
  }

  void toggleStatus(bool status) async {
    String message =
        await firebaseService.toggleStatus(_selectedFriend!.id, status);
    print(message);
    notifyListeners();
  }
}
