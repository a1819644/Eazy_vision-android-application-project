import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/screens/authenticate/wel-login.dart';
import 'package:untitled/screens/home/homepage.dart';
import 'package:untitled/screens/home/homepage_blank.dart';
import 'package:untitled/screens/wrapper.dart';
import 'package:untitled/services/CurrentUser.dart';

import 'CreateGroup/CreateGroup.dart';
import 'bot_menu_page/HomepageWidget.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(myApp());
}

class myApp extends StatelessWidget {
  //init the firebase for the login page
  // Future<FirebaseApp> _initializeFirebase() async {
  //   FirebaseApp firebaseApp = await Firebase.initializeApp();
  //   return firebaseApp;
  // }
  //document id for reading the usersdata
  List<String> docID = [];

  //get docID from the firebase
 /* Future getDocID() async {
    await FirebaseFirestore.instance.collection('userdata').get().then((snapshot) => snapshot.docs.forEach((document) {
      print(document.reference);
      docID.add(document.reference.id);
    }));
  }*/


  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CurrentUser(),//current user
        child:  MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Wrapper(),
          //MyHomePage(),
          //Wrapper()
        ),
      );
  }
}


