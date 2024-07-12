import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Notifipage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NotifiState();
  }
}

class getNoti {
  List<String>? messages;

  getNoti({this.messages});

  getNoti.fromJson(Map<String, dynamic> json) {
    messages = json['messages'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['messages'] = this.messages;
    return data;
  }
}

class NotifiState extends State<Notifipage> {
  var parsed;
  var noti;



  Future<getNoti> getPost() async {
    int length;
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? _userCredential = await _auth.currentUser;
    var userId = _userCredential?.uid;


    final response = await http.post(
      Uri.parse(
          'https://us-central1-ezbill-vision-c.cloudfunctions.net/accessTheNotifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'userId': userId,
      }),
    );

    if (response.statusCode == 200) {
      print("received =====================notification");
      print(response.body);
      parsed = json.decode(response.body);
      // length = parsed['messages'].length;
      // print("the length is: " + length.toString());
      // print('the messages is ' + parsed['messages'][1]);

      noti = getNoti.fromJson(parsed);
      return noti;
    }else{
      throw Exception('empty');

    }
    print("parsed");
    print(parsed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: FutureBuilder<getNoti>(
              future: getPost(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data?.messages?.length,
                  itemBuilder: (context, int index) {
                    return
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 30,),
                            const Text(
                              'System Update: ',
                              style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),),
                            SizedBox(width: 10,),
                            Text(
                              snapshot.data!.messages![index],
                              style: const TextStyle(
                                fontSize: 20,
                              color: Colors.black,
                              ),),
                            SizedBox(height: 20,),
                            Divider(),
                          ],
                    ),
                      );
                  }

                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
              ),
    ));
  }
}
