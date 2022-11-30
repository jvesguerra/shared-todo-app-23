import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/friend_model.dart';
import '../providers/friend_provider.dart';
import 'modal_friend.dart';

class FriendRequests extends StatefulWidget {
  const FriendRequests({super.key});

  @override
  State<FriendRequests> createState() => _FriendRequestsState();
}

class _FriendRequestsState extends State<FriendRequests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Friends List")),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('friends_list').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          return Container(
            height: 300,
            width: 300,
            child: ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: ((context, index) {
                  Friend friend = Friend.fromJson(snapshot.data?.docs[index]
                      .data() as Map<String, dynamic>);
                  return ListTile(
                      leading: Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(
                          onPressed: () {
                            context
                                .read<FriendListProvider>()
                                .changeSelectedFriend(friend);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => FriendModal(
                                type: 'AcceptFriend',
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
                              builder: (BuildContext context) => FriendModal(
                                type: 'RejectFriend',
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
                      //title: Text(friend.friends![index]));
                      title: Text(friend.displayName));
                })),
          );
        },
      ),
    );
  }
}