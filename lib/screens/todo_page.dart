// ignore_for_file: prefer_const_constructors

/*
  Author: Joshua V. Esguerra
  Section: C4L
  Date created: November 22, 2022
  Exercise number: 7
  Program Description: User Authentication and Automated Tests
  */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:week7_networking_discussion/providers/todo_provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/screens/drawer_header.dart';
import 'package:week7_networking_discussion/screens/friend_requests.dart';
import 'package:week7_networking_discussion/screens/friends_list.dart';
import 'package:week7_networking_discussion/screens/modal_todo.dart';
import 'package:week7_networking_discussion/screens/friend_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week7_networking_discussion/screens/profile_page.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    // access the list of todos in the provider
    Stream<QuerySnapshot> todosStream = context.watch<TodoListProvider>().todos;
    String displayName = "";

    return Scaffold(
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
        MyHeaderDrawer(),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: ListTile(
            leading: Icon(Icons.portrait),
            title: const Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: ListTile(
            leading: Icon(Icons.group_sharp),
            title: const Text('Friends List'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FriendsList()),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: ListTile(
            leading: Icon(Icons.menu_open),
            title: const Text('Friend Requests'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FriendRequests()),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: ListTile(
            leading: Icon(Icons.logout_sharp),
            title: const Text('Logout'),
            onTap: () {
              context.read<AuthProvider>().signOut();
              Navigator.pop(context);
            },
          ),
        ),
      ])),
      appBar: AppBar(
        title: Center(
          child: ElevatedButton(
            onPressed: () {
              // Navigate back to first route when tapped.
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FriendPage()),
              );
            },
            child: Icon(Icons.search),
          ),
        ),
      ),
      body: StreamBuilder(
        //stream: FirebaseFirestore.instance.collection('users').snapshots(),
        stream: todosStream,
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
              child: Text("No Todos Found"),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: ((context, index) {
              Todo todo = Todo.fromJson(
                  snapshot.data?.docs[index].data() as Map<String, dynamic>);
              if (displayName.isEmpty) {
                return Dismissible(
                  key: Key(todo.id.toString()),
                  onDismissed: (direction) {
                    context.read<TodoListProvider>().changeSelectedTodo(todo);
                    context.read<TodoListProvider>().deleteTodo();

                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${todo.title} dismissed')));
                  },
                  background: Container(
                    color: Colors.red,
                    child: const Icon(Icons.delete),
                  ),
                  child: ListTile(
                    title: Text(todo.title),
                    leading: Checkbox(
                      value: todo.completed,
                      onChanged: (bool? value) {
                        context
                            .read<TodoListProvider>()
                            .changeSelectedTodo(todo);
                        context.read<TodoListProvider>().toggleStatus(value!);
                      },
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            context
                                .read<TodoListProvider>()
                                .changeSelectedTodo(todo);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => TodoModal(
                                type: 'Edit',
                              ),
                            );
                          },
                          icon: const Icon(Icons.create_outlined),
                        ),
                        IconButton(
                          onPressed: () {
                            context
                                .read<TodoListProvider>()
                                .changeSelectedTodo(todo);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => TodoModal(
                                type: 'Delete',
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete_outlined),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return const FriendPage();
              }
            }),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => TodoModal(
              type: 'Add',
            ),
          );
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
