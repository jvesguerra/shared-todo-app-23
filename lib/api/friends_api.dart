/*
Author: Joshua V. Esguerra
Section: C4L
Date created: November 19, 2022
Exercise number: 6
Program Description: Simple Friends App
*/

import 'dart:async';
import 'package:week7_networking_discussion/models/friend_model.dart';
import 'package:http/http.dart' as http;

class FriendAPI {
  Future<List<Friend>> fetchTodos() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/friends'));

    if (response.statusCode == 200) {
      return Friend.fromJsonArray(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load todos');
    }
  }
}
