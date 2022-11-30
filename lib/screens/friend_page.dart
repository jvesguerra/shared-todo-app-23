// ignore_for_file: prefer_const_constructors

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
import 'modal_friend.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  String displayName = "";
  @override
  Widget build(BuildContext context) {
    // access the list of todos in the provider
    Stream<QuerySnapshot> friendsStream =
        context.watch<FriendListProvider>().friends;

    return Scaffold(
      appBar: AppBar(
        title: Card(
            child: TextField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search), hintText: 'Search...'),
                onChanged: (val) {
                  setState(() {
                    displayName = val;
                  });
                })),
      ),
      body: StreamBuilder(
        //stream: friendsStream,
        stream:
            FirebaseFirestore.instance.collection('friends_list').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text("No Friends Found"),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: ((context, index) {
              Friend friend = Friend.fromJson(
                  snapshot.data?.docs[index].data() as Map<String, dynamic>);
              // if search bar is empty just show the collection
              if (displayName.isEmpty) {
                return Container();
              }

              // can search with display name or username
              if (friend.displayName
                      .toString()
                      .toLowerCase()
                      .startsWith(displayName.toLowerCase()) ||
                  friend.userName
                      .toString()
                      .toLowerCase()
                      .startsWith(displayName.toLowerCase())) {
                return Dismissible(
                  key: Key(friend.id.toString()),
                  onDismissed: (direction) {
                    context
                        .read<FriendListProvider>()
                        .changeSelectedFriend(friend);
                    context.read<FriendListProvider>().deleteFriend();

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('${friend.displayName} dismissed')));
                  },
                  background: Container(
                    color: Colors.red,
                    child: const Icon(Icons.delete),
                  ),
                  child: ListTile(
                    title: Text(friend.displayName),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            context
                                .read<FriendListProvider>()
                                .changeSelectedFriend(friend);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => FriendModal(
                                type: 'Addfriend',
                              ),
                            );
                          },
                          icon: const Icon(Icons.person_add),
                        ),

                        // Delete Button
                        IconButton(
                          onPressed: () {
                            context
                                .read<FriendListProvider>()
                                .changeSelectedFriend(friend);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => FriendModal(
                                type: 'Delete',
                              ),
                            );
                          },
                          icon: const Icon(Icons.person_remove),
                        ),

                        // show all friends
                        IconButton(
                          onPressed: () {
                            context
                                .read<FriendListProvider>()
                                .changeSelectedFriend(friend);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => FriendModal(
                                type: 'Showallfriends',
                              ),
                            );
                          },
                          icon: const Icon(Icons.group),
                        ),

                        // Show Friends List
                        IconButton(
                          onPressed: () {
                            context
                                .read<FriendListProvider>()
                                .changeSelectedFriend(friend);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => FriendModal(
                                //type: 'Showfriendrequests',
                                type: 'Showfriendrequests',
                              ),
                            );
                          },
                          icon: const Icon(Icons.list),
                        )
                      ],
                    ),
                  ),
                );
              }
              //changed
              return Container();
            }),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => FriendModal(
              type: 'Add',
            ),
          );
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
