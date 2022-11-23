// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

/*
Author: Joshua V. Esguerra
Section: C4L
Date created: November 19, 2022
Exercise number: 6
Program Description: Simple Friends App
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/models/friend_model.dart';
import 'package:week7_networking_discussion/providers/friend_provider.dart';

class FriendModal extends StatelessWidget {
  String type;
  String? lastId;
  TextEditingController _displayNameController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();

  FriendModal({super.key, required this.type, this.lastId});

  Friend? _selectedFriend;
  Friend get selected => _selectedFriend!;

  changeSelectedFriend(Friend item) {
    _selectedFriend = item;
  }

  // Method to show the title of the modal depending on the functionality
  Text _buildTitle() {
    switch (type) {
      case 'Add':
        return const Text("Add new friend");
      case 'Addfriend':
        return const Text("Send friend request");
      case 'Showfriendrequests':
        return const Text("Friend requests");
      case 'Showallfriends':
        return const Text("Friends List");
      case 'Edit':
        return const Text("Edit friend");
      case 'Delete':
        return const Text("Delete friend");
      default:
        return const Text("");
    }
  }

  // Method to build the content or body depending on the functionality
  Widget _buildContent(BuildContext context) {
    // Use context.read to get the last updated list of todos
    //List<Todo> todoItems = context.read<TodoListProvider>().todo;

    switch (type) {
      case 'Delete':
        {
          return Text(
            "Are you sure you want to delete '${context.read<FriendListProvider>().selected.displayName}'?",
          );
        }
      case 'Addfriend':
        {
          return Text(
            "Are you sure you want to send a friend request to '${context.read<FriendListProvider>().selected.displayName}'?",
          );
        }
      case 'AcceptFriend':
        {
          return Text(
            "Are you sure you want to accept '${context.read<FriendListProvider>().selected.displayName}'?",
          );
        }
      case 'RejectFriend':
        {
          return Text(
            "Are you sure you want to reject '${context.read<FriendListProvider>().selected.displayName}'?",
          );
        }
      case 'Unfriend':
        {
          return Text(
            "Are you sure you want to unfriend '${context.read<FriendListProvider>().selected.displayName}'?",
          );
        }
      // what if we can just loop to the array to show the received Friend requests
      case 'Showfriendrequests':
        {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('friends_list')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              String? showId = context.read<FriendListProvider>().selected.id;
              return Container(
                height: 300,
                width: 300,
                child: ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: ((context, index) {
                      Friend friend = Friend.fromJson(snapshot.data?.docs[index]
                          .data() as Map<String, dynamic>);
                      print(snapshot.data?.docs.length);
                      return ListTile(
                          //leading: const Icon(Icons.list),
                          leading:
                              Row(mainAxisSize: MainAxisSize.min, children: [
                            IconButton(
                              onPressed: () {
                                context
                                    .read<FriendListProvider>()
                                    .changeSelectedFriend(friend);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      FriendModal(
                                    type: 'AcceptFriend',
                                    lastId: showId,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.check_circle),
                            ),
                            IconButton(
                              onPressed: () {
                                context
                                    .read<FriendListProvider>()
                                    .changeSelectedFriend(friend);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      FriendModal(
                                    type: 'RejectFriend',
                                    lastId: showId,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.cancel),
                            ),
                          ]),
                          trailing: const Text(
                            "Pending",
                            style: TextStyle(color: Colors.red, fontSize: 15),
                          ),
                          //title: Text(friend.receivedFriendRequests![index]));
                          title: Text(friend.displayName));
                    })),
              );
            },
          );
        }
      case 'Showallfriends':
        {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('friends_list')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              String? showId = context.read<FriendListProvider>().selected.id;
              return Container(
                height: 300,
                width: 300,
                child: ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: ((context, index) {
                      Friend friend = Friend.fromJson(snapshot.data?.docs[index]
                          .data() as Map<String, dynamic>);

                      return ListTile(
                          //leading: const Icon(Icons.list),
                          leading:
                              Row(mainAxisSize: MainAxisSize.min, children: [
                            IconButton(
                              onPressed: () {
                                context
                                    .read<FriendListProvider>()
                                    .changeSelectedFriend(friend);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      FriendModal(
                                    type: 'Unfriend',
                                    lastId: showId,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.cancel),
                            ),
                          ]),
                          title: Text(friend.displayName));
                    })),
              );
            },
          );
        }

      // Edit and add will have input field in them
      default:
        return Container(
          height: 200,
          width: 0,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Display Name",
                  textAlign: TextAlign.left,
                ),
                TextField(
                  controller: _displayNameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Display Name',
                    //hintText: todoIndex != -1 ? todoItems[todoIndex].title : '',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Username",
                  textAlign: TextAlign.left,
                ),
                TextField(
                  controller: _userNameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Username',
                    //hintText: todoIndex != -1 ? todoItems[todoIndex].title : '',
                  ),
                ),
              ]),
        );
    }
  }

  TextButton _dialogAction(BuildContext context) {
    String currentUser = "yqOtbBMwzcNEvfKIS4uj";

    //List<Todo> todoItems = context.read<TodoListProvider>().todo;
    return TextButton(
      onPressed: () {
        switch (type) {
          case 'Add':
            {
              // Instantiate a todo objeect to be inserted, default userID will be 1, the id will be the next id in the list
              Friend temp = Friend(
                userId: 1,
                userName: _userNameController.text,
                displayName: _displayNameController.text,
                receivedFriendRequests: [],
                sentFriendRequests: [],
                completed: false,
              );

              context.read<FriendListProvider>().addFriend(temp);

              // Remove dialog after adding
              Navigator.of(context).pop();
              break;
            }
          // Friend request
          case 'Addfriend':
            {
              context.read<FriendListProvider>().sendFriendRequest(currentUser);
              // Remove dialog after editing
              Navigator.of(context).pop();
              break;
            }
          case 'AcceptFriend':
            {
              // last id is the user when you press the show friend request
              context.read<FriendListProvider>().acceptFriend(lastId);
              // Remove dialog after editing
              Navigator.of(context).pop();
              break;
            }
          case 'RejectFriend':
            {
              // last id is the user when you press the show friend request
              context.read<FriendListProvider>().rejectFriend(lastId);
              // Remove dialog after editing
              Navigator.of(context).pop();
              break;
            }
          case 'Unfriend':
            {
              // last id is the user when you press the show friend request
              context.read<FriendListProvider>().unfriend(currentUser);
              // Remove dialog after editing
              Navigator.of(context).pop();
              break;
            }
          case 'Edit':
            {
              context.read<FriendListProvider>().editFriend(
                  _displayNameController.text, _userNameController.text);

              // Remove dialog after editing
              Navigator.of(context).pop();
              break;
            }
          case 'Delete':
            {
              context.read<FriendListProvider>().deleteFriend();

              Navigator.of(context).pop();
              break;
            }
          case 'Showfriendrequests':
            {
              context.read<FriendListProvider>().showFriendRequest();

              Navigator.of(context).pop();
              break;
            }
          case 'Showallfriends':
            {
              context.read<FriendListProvider>().showAllFriends();

              Navigator.of(context).pop();
              break;
            }
        }
      },
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      child: Text(type),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(),
      content: _buildContent(context),

      // Contains two buttons - add/edit/delete, and cancel
      actions: <Widget>[
        _dialogAction(context),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ],
    );
  }
}
