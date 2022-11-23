A. Student Information

Name: Joshua V. Esguerra
Student Number: 2020 03372
Section: C4L

B. App Description
# Simple Todo App using Firebase

The todo app connects to firebase cloud firestore and authentication. It uses a provider for state management

## Folder Structure
```
lib
├───api
│   └───firebase_auth_api.dart*
│   └───firebase_todo_api.dart
├───models
│   └───todo_model.dart
├───providers
│   └───todo_provider.dart
│   └───auth_provider.dart*
├───screens
│   ├───modal_todo.dart
│   └───todo_page.dart
│   └───login.dart*
│   └───signup.dart*
└───main.dart
```

* Models - contains the data model used
* Providers - contains the Todo provider that contains the data and method logic
* Screens - contains the screen/widgets used

C. Screenshots

D. Things you did in the code

Instead of using text field in my forms, I used text form fields to validate the user input. I used the validator in the text form field to check the value and prompt errors. I made sure that the validators always check that the fields have text on it. Before sending the data to firebase, I made a variable isValidForm which checks all the validation in the form. If it is true, it continues the sign up, else not.

E.

I faced a problem regarding how to return the error message from the firebase_auth_api back to the log in page so that the user can see it in the ui. I tried returning a Future<String> from auth_api to auth_provider to the log in page. I got to the point where I can print the error message from my log in page but it was not reflecting in my ui.

F. TEST CASES

Happy paths
1. Users can sign up to the firebase using the sign up page.By clicking sign up from the log-in page, users will be redirected to the sign up page where their inputs will be validated before they could sign up.
2. After signing up to the firebase, users can now log in and will be redirected to the to do app. They are able to add to do tasks and also log out by clicking the drawer on the left-side and pressing log out.

Unhappy paths
1.
2.