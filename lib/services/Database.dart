import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:untitled/models/OurUser.dart';
import 'package:untitled/screens/home/homepage.dart';
import 'package:untitled/services/CurrentUser.dart';
import 'package:http/http.dart' as http;

class OurDatabase {
   FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<String> createUser(OurUser user) async {
    String retval = "error";
    try {
      await _firestore.collection("users").doc(user.uid).set({
        'firstName': user.firstName,
        'LastName': user.lastName,
        'email': user.email,
      });
      retval = "success";
    } catch (e) {
      print(e);
    }
    return retval;
  }

  Future<OurUser> getUserInfo(String uid) async {
    OurUser retval = OurUser();
    try {
      DocumentSnapshot _documentSnapshot =
          await _firestore.collection("users").doc(uid).get();
      retval.uid = uid;
      retval.firstName = _documentSnapshot.get("firstName");
      retval.lastName = _documentSnapshot.get("LastName");
      retval.email = _documentSnapshot.get("email");
      retval.groupId = _documentSnapshot.get("groupId");
    } catch (e) {
      print(e);
    }
    return retval;
  }

  //create group function
   Future<String> createGroup(String groupName, String? userUid) async {
    String retval = "error";
    List<String> members = [];
    try {
      members.add(userUid!);
      DocumentReference _docRef = await _firestore.collection("groups").add({
        'name': groupName,
        'leader': userUid,
        'members': members,
      });
      await _firestore.collection("users").doc(userUid).update({
        'groupId': _docRef.id,
      });
      retval = "success";

      await http.post(
        Uri.parse('https://us-central1-ezbill-vision-c.cloudfunctions.net/addingNewCollectionForBillsForNewGroup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          // 1a36eJJCbCcLxW4SFXd2ZwqNXbm2
          // 'userId': userId,
          "groupId":_docRef.id,
        }),
      );

      await http.post(
        Uri.parse('https://us-central1-ezbill-vision-c.cloudfunctions.net/creatingCollectionForAllTheDetails'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "groupId":_docRef.id,
          "userId":userUid,
          "macAddress": "due to privacy issue NOMAC"
        }),

      );
      print('data sending-------------------------------------' + _docRef.id,);




    } catch (e) {
      print(e);
    }
    return retval;
  }

  //join group function
  Future<String> joinGroup(String groupId, String userUid) async {
    String retval = "error";
    List<String> members = [];
    try {
      members.add(userUid);
      await _firestore.collection("groups").doc(groupId).update({
        'members': FieldValue.arrayUnion(members),
      });
      await _firestore.collection("users").doc(userUid).update({
        'groupId': groupId,
      });
      retval = "success";

      await http.post(
        Uri.parse('https://us-central1-ezbill-vision-c.cloudfunctions.net/creatingCollectionForAllTheDetails'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "groupId":groupId,
          "userId":userUid,
          "macAddress": "due to privacy issue NOMAC"
        }),

      );
      print('data sending-------------------------------------' + groupId,);



    } catch (e) {
      print(e);
    }
    return retval;
  }
}
