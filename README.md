**Progress Report can be read below**

A. Student Information

Name: Joshua V. Esguerra
Student Number: 2020 03372
Section: C4L

B. App Description
#  Shared Todo App

The project is a Flutter mobile application composed of a sign in, sign-up and a shared todo list features with a user’s friends. The database that will be used is Firebase.

## Folder Structure
```
lib
├───api
│   ├───firebase_auth_api.dart
│   ├───firebase_friend_api.dart
│   ├───firebase_todo_api.dart
│   └───friends_api.dart
├───models
│   ├───friend_model.dart
│   └───todo_model.dart
├───providers
│   ├───auth_provider.dart*
│   ├───friend_provider.dart
│   └───todo_provider.dart*
├───screens
│    ├───friend_page.dart*
│    ├───friend_requests.dart*
│    ├───friends_list.dart*
│    ├───login.dart
│    ├───modal_friend.dart
│    ├───modal_todo.dart
│    ├───profile_page.dart
│    ├───signup.dart
│    └───todo_page.dart
│   
|   
└───main.dart
```

* Models - contains the data model used
* Providers - contains the Todo provider that contains the data and method logic
* Screens - contains the screen/widgets used

# Progress:

When you log in, you get directed to the Todo page. The TodoPage() contains a drawer and a search button at the top...

When you click the search button, you get directed to an empty FriendPage(). If you type something in the search bar, then it will search for the users. ( as of now it still streams friends list collection)

When you click the drawer, you find 4 buttons... and when you click the button

Profile --> you get directed to ProfilePage()

Friends List --> you get directed to FriendsList()

Friend Requests --> you get directed to FriendRequests()

Logout --> you get logged out and redirected to LoginPage()

Data is not yet fixed, it still gets its data to friends_list or todos. For now, It is just the navigation of pages and improving its design.

