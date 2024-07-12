import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/bot_menu_page/utilities/my_member.dart';
import 'package:http/http.dart' as http;

class contactPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ContactState();
  }
}


// class myList extends StatelessWidget{
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     // return ListView(
//     //   children:this._getData()
//     // );
//     return ListView.builder(
//       itemCount: 10,
//       // Provide a builder function. This is where the magic happens.
//       // Convert each item into a widget based on the type of item it is.
//       itemBuilder: (context, index) {
//         return ListTile(
//           title: Text('000000'),
//           subtitle: Text('11111'),
//         );
//       },
//     );
//   }}


class getMember {
  List<MemberList>? memberList;

  getMember({this.memberList});

  getMember.fromJson(Map<String, dynamic> json) {
    if (json['memberList'] != null) {
      memberList = <MemberList>[];
      json['memberList'].forEach((v) {
        memberList!.add(new MemberList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.memberList != null) {
      data['memberList'] = this.memberList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MemberList {
  String? fullName;
  String? email;
  List<String>? photoLinks;
  bool? leader;

  MemberList({this.fullName, this.email, this.photoLinks, this.leader});

  MemberList.fromJson(Map<String, dynamic> json) {
    fullName = json['full Name'];
    email = json['email'];
    photoLinks = json['photoLinks'].cast<String>();
    leader = json['leader'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['full Name'] = this.fullName;
    data['email'] = this.email;
    data['photoLinks'] = this.photoLinks;
    data['leader'] = this.leader;
    return data;
  }
}

class ContactState extends State<contactPage> {
  late bool leaderTag = false;
  var parsed;
  var mem;
  String a = '{"memberList": [{"full Name": "sas aa","email": "skijkk@gmail.com","photoLinks": ["https://firebasestorage.googleapis.com/v0/b/ezbill-vision-c.appspot.com/o/3vo65oTY8CYTckGXlif6ULQxxm52%2Fimages%2Fpost_null?alt=media&token=2bc53775-fdd6-404f-acbf-7a416eecb552","https://firebasestorage.googleapis.com/v0/b/ezbill-vision-c.appspot.com/o/3vo65oTY8CYTckGXlif6ULQxxm52%2Fimages%2Fpost_null?alt=media&token=2bc53775-fdd6-404f-acbf-7a416eecb552"],"leader": true},{"full Name": "anoop kum","email": "testsun@gmail.com","photoLinks": ["https://firebasestorage.googleapis.com/v0/b/ezbill-vision-c.appspot.com/o/3vo65oTY8CYTckGXlif6ULQxxm52%2Fimages%2Fpost_null?alt=media&token=2bc53775-fdd6-404f-acbf-7a416eecb552","https://firebasestorage.googleapis.com/v0/b/ezbill-vision-c.appspot.com/o/3vo65oTY8CYTckGXlif6ULQxxm52%2Fimages%2Fpost_null?alt=media&token=2bc53775-fdd6-404f-acbf-7a416eecb552"],"leader": false}]}';
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<getMember> getPost() async {


    User? _userCredential = await _auth.currentUser;
    var userId = _userCredential?.uid;

    final response = await http.post(
      Uri.parse(
          'https://us-central1-ezbill-vision-c.cloudfunctions.net/retriveGroupMembers'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        //"groupId": "C0Zx90b1eQwSKgbRnxen",
        'userId': userId,
      }),
    );

    if (response.statusCode == 200) {
      print("received================================== contact data");
      print(response.body);
      parsed = json.decode(response.body);

      mem = getMember.fromJson(parsed);

      print(parsed);


      return mem;
    }else{
      throw Exception('empty');

    }

  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        child: FutureBuilder<getMember>(
          future: getPost(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.memberList?.length,
                itemBuilder: (context, int index) {
                  var name = snapshot.data!.memberList![0]!.fullName;
                  print( snapshot.data!.memberList![0]!.email);
                  return
                    MyMember(
                        picAdd:snapshot.data!.memberList![index]!.photoLinks![snapshot.data!.memberList![index]!.photoLinks!.length-1],
                        userName: snapshot.data!.memberList![index]!.fullName,
                        emailAdd: snapshot.data!.memberList![index]!.email,
                        leaderTag:snapshot.data!.memberList![index]!.leader );
                },
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


      ),

      // ListView(
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 25.0),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           SizedBox(
      //             height: 20,
      //           ),
      //
      //           Row(
      //             children: [
      //               Text(
      //                 "My",
      //                 style: TextStyle(
      //                   fontSize: 28,
      //                   fontWeight: FontWeight.bold,
      //                 ),
      //               ),
      //               Text(
      //                 'GroupMembers',
      //                 style: TextStyle(
      //                   fontSize: 28,
      //                 ),
      //               ),
      //             ],
      //           ),
      //           Row(
      //             children: [
      //               IconButton(
      //                   onPressed: () => getPost(), icon: Icon(Icons.refresh)),
      //               IconButton(
      //                   onPressed: () => showDialog(
      //                       context: context,
      //                       builder: (BuildContext context) => AlertDialog(
      //                             title: Text("Invitation Code"),
      //                             content: Row(
      //                               children: [
      //                                 Text("Code: "),
      //                                 Text("12345code"),
      //                               ],
      //                             ),
      //                           )),
      //                   icon: Icon(Icons.add)),
      //             ],
      //           ),
      //
      //           //IconButton(onPressed: ()=>getPost(), icon: Icon(Icons.refresh)),
      //         ],
      //       ),
      //     ),
      //     Divider(),
      //
      //     SizedBox(
      //       height: 10,
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 25.0),
      //       child: Column(
      //         children: [
      //           Text(
      //             'Leading Tenant',
      //             style: TextStyle(
      //               fontSize: 20,
      //               fontWeight: FontWeight.w300,
      //             ),
      //           ),
      //           MyMember(
      //             picAdd: 'assets/images/id1.jpg',
      //             userName: 'John Doe',
      //             emailAdd: 'johndoe@gmail.com',
      //             leaderTag: true,
      //           ),
      //         ],
      //       ),
      //     ),
      //
      //     SizedBox(
      //       height: 10,
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 25.0),
      //       child:
      //         HomeContent(),
      //         // Column(
      //         //   children: [
      //         //
      //         //     HomeContent(),
      //         //   ],
      //         // )
      //       // Column(
      //       //   children: [
      //       //
      //       //
      //       //     Text(
      //       //       'Group Members',
      //       //       style: TextStyle(
      //       //         fontSize: 20,
      //       //         fontWeight: FontWeight.w300,
      //       //       ),
      //       //     ),
      //       //     MyMember(
      //       //       picAdd: 'assets/images/id2.jpg',
      //       //       userName: 'John Doe',
      //       //       emailAdd: 'johndoe@gmail.com',
      //       //       leaderTag: false,
      //       //     ),
      //       //     SizedBox(height: 10,),
      //       //     MyMember(
      //       //       picAdd: 'assets/images/id5.jpg',
      //       //       userName: 'John Doe',
      //       //       emailAdd: 'johndoe@gmail.com',
      //       //       leaderTag: false,
      //       //     ),
      //       //     SizedBox(
      //       //       height: 10,
      //       //     ),
      //       //     MyMember(
      //       //       picAdd: 'assets/images/id2.jpg',
      //       //       userName: 'John Doe',
      //       //       emailAdd: 'johndoe@gmail.com',
      //       //       leaderTag: false,
      //       //     ),
      //       //     SizedBox(height: 10,),
      //       //   ],
      //       // ),
      //     ),
      //     Divider(),
      //     SizedBox(
      //       height: 10,
      //     ),
      //     //Container(child: leaderTag? ElevatedButton(style:ElevatedButton.styleFrom(primary: Colors.black), onPressed: (){}, child: const Text('Dismiss The Group', style: TextStyle(color: Colors.white),)) : ElevatedButton(style: ElevatedButton.styleFrom(primary: Colors.black), onPressed: (){}, child: const Text('Leave The Group', style: TextStyle(color: Colors.white),)),),
      //
      //     //ElevatedButton(onPressed: onPressed, child: child);
      //   ],
      // ),
    );
  }
}
