import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// https://www.youtube.com/watch?v=PBxbWZZTG2Q

class GetUserData extends StatelessWidget {
  final String documentId;

  GetUserData({required this.documentId});

  @override
  Widget build(BuildContext context) {
    // getting the collections
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
            return Text('first name: ${data['first name']}');
          }
          return Text('loading..');
        }),
    );
  }
}
