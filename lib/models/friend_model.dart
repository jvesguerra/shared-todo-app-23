/*
Author: Joshua V. Esguerra
Section: C4L
Date created: November 19, 2022
Exercise number: 6
Program Description: Simple Friends App
*/

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Friend {
  final int userId;
  String? id;
  String userName;
  String displayName;
  List<String>? friends;
  List<String>? sentFriendRequests;
  List<String>? receivedFriendRequests;
  bool completed;

  Friend({
    required this.userId,
    required this.userName,
    required this.displayName,
    required this.completed,
    this.id,
    this.friends,
    this.sentFriendRequests,
    this.receivedFriendRequests,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      userId: json['userId'],
      id: json['id'],
      userName: json['userName'],
      displayName: json['displayName'],
      friends: json[null],
      receivedFriendRequests: json[null],
      sentFriendRequests: json[null],
      completed: json['completed'],
    );
  }

  Map<String, dynamic> toJson(Friend friend) {
    return {
      'userId': friend.userId,
      'userName': friend.userName,
      'displayName': friend.displayName,
      'friends': friend.friends,
      'receivedFriendRequests': friend.receivedFriendRequests,
      'sentFriendRequests': friend.sentFriendRequests,
      'completed': friend.completed,
    };
  }

  static List<Friend> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Friend>((dynamic d) => Friend.fromJson(d)).toList();
  }

  @override
  toString() {
    return displayName;
  }
}
