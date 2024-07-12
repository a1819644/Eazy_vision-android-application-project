import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/screens/authenticate/RegisterWidget.dart';

import '../models/OurUser.dart';
import '../screens/wrapper.dart';
import 'Database.dart';

class CurrentUser extends ChangeNotifier {
   OurUser _currentuser = new OurUser();

  OurUser get getCurrentuser => _currentuser;
  //creating instance of the Firebase
  FirebaseAuth _auth = FirebaseAuth.instance;

  ValueNotifier<AuthStatus?> curAuthStatus = ValueNotifier(null);

   // auth changed user stream
  Future<String> onStartUp() async {
    String retval = "error";
    try {
      User? _userCredential = await _auth.currentUser; // getting current use
      _currentuser.uid = _userCredential?.uid;
      _currentuser.email = _userCredential?.email;
      print("from the startup");
      print(_userCredential?.uid);
      print(_userCredential?.email);

      if (_userCredential != null) {
        _currentuser =
            await OurDatabase().getUserInfo(_userCredential.uid as String);
        if (_currentuser != null) {
          print("printing users id");
          print(_currentuser
              .uid); // this is working now.. fully confirm @anoop  for myself
          retval = "success";
        }
      }
    } catch (e) {
      retval = e.toString();
    }
    return retval;
  }

  // sign in with email and password
  Future<String> loginUsingEmailPassword(String email, String password) async {
    String retval = "error";
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _currentuser =
          await OurDatabase().getUserInfo(userCredential.user?.uid as String);
      if (_currentuser != null) {
        curAuthStatus.value = null;
        retval = "success";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("no users found for that email");
      }
    }
    return retval;
  }

  //register with email and password
  Future<String> registerUsingEmailPassword(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    String retval = "error";
    OurUser _user = OurUser();

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user.uid = userCredential.user?.uid;
      _user.email = userCredential.user?.email;
      _user.firstName = firstName;
      _user.lastName = lastName;
      String rest = await OurDatabase().createUser(_user);
      if (rest == "success") {
        retval = "success";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    return retval;
  }

  //sign out
  Future<String> signOut() async {
    String retval = "error";
    try {
      await _auth.signOut();
      _currentuser =
          OurUser(); // can't assign this to null so doing this. @anoop
      retval = "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("no users found for that email");
      }
    }
    return retval;
  }
}
