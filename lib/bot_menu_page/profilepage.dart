import 'dart:convert';

import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:untitled/bot_menu_page/utilities/add_new_camera.dart';
import 'package:untitled/bot_menu_page/utilities/camera.dart';
import 'package:untitled/bot_menu_page/utilities/my_button.dart';
import 'package:untitled/screens/wrapper.dart';
import 'package:untitled/services/CurrentUser.dart';
import 'package:http/http.dart' as http;

class Profilepage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileState();
  }
}

class ProfileState extends State<Profilepage> {
  TextEditingController inpu1 = new TextEditingController();
  TextEditingController inpu2 = new TextEditingController();
  TextEditingController inpu3 = new TextEditingController();
  var parsed;
  var userName;

  FirebaseAuth _auth = FirebaseAuth.instance;



  Future<void> getPost() async {
    print('send data===================================');

    User? _userCredential = await _auth.currentUser;
    var userId = _userCredential?.uid;


    print("--------------------------------------");
    print(_userCredential);
    final response = await http.post(
      Uri.parse('https://us-central1-ezbill-vision-c.cloudfunctions.net/accessTheFieldInformationOfTheUsers'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
       // 1a36eJJCbCcLxW4SFXd2ZwqNXbm2
        // 'userId': userId,
        'userId':_userCredential?.uid,
      }),
    );


    if(response.statusCode == 200){
      print('received data===================================');
      print("received profilepage data");
      print(response.body);
      print("userName==========================");
      parsed = json.decode(response.body);}

      userName = parsed["information"]["firstName"] + parsed["information"]["LasttName"];

    print('++++++++++++++++++++++++++');
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ExpandableTheme(
          data: ExpandableThemeData( iconColor:  Colors.blue, useInkWell: true),
          child: FutureBuilder(
            future: getPost(),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(
                  child: LoadingAnimationWidget.newtonCradle(color: Colors.black, size: 200),
                );

              }else{
                return ListView(
                  children: <Widget>[
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.red, Colors.deepOrange.shade300],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          stops: [0.5, 0.9],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[

                              CircleAvatar(
                                backgroundColor: Colors.red.shade300,
                                minRadius: 35.0,
                                child: camera(),
                                //Icon(Icons.camera_alt, size: 30.0,),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.white70,
                                minRadius: 60.0,
                                child: CircleAvatar(
                                  radius: 50.0,
                                  backgroundImage:
                                  NetworkImage(

                                      parsed['information']['photoLink'][parsed['information']['photoLink'].length -1]),
                                ),
                              ),
                              CircleAvatar(backgroundColor: Colors.red.shade300, minRadius: 35.0, child: signout(),),

                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    parsed["information"]["firstName"] + ' '+ parsed["information"]["LastName"],
                                    style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  //Text(' '),
                                  // Text(
                                  //   parsed["information"]["LastName"],
                                  //   style: TextStyle(
                                  //     fontSize: 35,
                                  //     fontWeight: FontWeight.bold,
                                  //     color: Colors.white,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          //GetUserData(),
                          Container(
                              child:parsed["leader"]!?
                              Text('Principle Tenant', style: TextStyle(color: Colors.white, fontSize: 25,),):
                              Text('Group Member', style: TextStyle(color: Colors.white, fontSize: 25,),)
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          SizedBox(height: 20,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Button(iconPath: 'assets/images/icon-email.png', buttonText: 'Email Address'),

                              IconButton(
                                  onPressed: (){
                                    showDialog(context: context, builder: (BuildContext context) =>
                                    AlertDialog(
                                      title: Text(parsed['groupName']),
                                      content:Text(parsed['information']['email']),
                                          //TextButton(onPressed: () => Navigator.pop(context, 'back') , child: Text('Back')),
                                    ));
                                  },
                                  icon: Icon(Icons.arrow_forward_ios),
                              ),

                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Button(iconPath: 'assets/images/lock.png', buttonText: 'Invite New Users'),

                              IconButton(
                                onPressed: (){
                                  showDialog(context: context, builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: Text(parsed['groupName']),
                                        content:

                                        SelectableText("Code: "+ parsed['information']['groupId']),
                                        //TextButton(onPressed: () => Navigator.pop(context, 'back') , child: Text('Back')),
                                      ));
                                },
                                icon: Icon(Icons.arrow_forward_ios),

                              ),

                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Button(iconPath: 'assets/images/webcam.png', buttonText: 'Camera'),

                              IconButton(
                                  onPressed: (){
                                      showDialog(context: context, builder: (BuildContext context) =>
                                          AlertDialog(
                                            title: Text(parsed['groupName'] + ' Camera Location'),
                                            content:
                                                SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(parsed['camera'][0]['camId']+': '),
                                                          Text(parsed['camera'][0]['location'])
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(parsed['camera'][1]['camId']+': '),
                                                          Text(parsed['camera'][1]['location'])
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(parsed['camera'][2]['camId']+': '),
                                                          Text(parsed['camera'][2]['location'])
                                                        ],
                                                      )
                                                    ],

                                                  ),
                                                ),

                                            actions: <Widget>[
                                              //parsed['leader']
                                          parsed['leader']!?

                                                 Row(
                                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                   children: [
                                                     TextButton(onPressed: () =>
                                                     Navigator.push(
                                                         context,
                                                         MaterialPageRoute(
                                                             builder: (context) => newCamera(gid: parsed['information']['groupId'],)))

                                                     ,child: Text('Add new Pi Camera')),TextButton(onPressed: () => Navigator.pop(context, 'back') , child: Text('Back'))],)
                                                : TextButton(onPressed: () => Navigator.pop(context, 'back') , child: Text('Back')),


                                          ],
                                          ),


                                            //TextButton(onPressed: () => Navigator.pop(context, 'back') , child: Text('Back')),
                                          );
                                    },

                                  icon: Icon(Icons.arrow_forward_ios)),

                            ],
                          ),

                        ],
                      ),
                    )
                  ],
                );
              }

          },
          ),
        )
      );

  }}

class camera extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Container(
        child: IconButton(
          //todo switch page to camera use page
          onPressed: ()=> Navigator.push(context,MaterialPageRoute(builder:(context)=> Camera())),
          icon: Icon(Icons.camera_alt_outlined),
        )
    );
  }
}

class signout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
        onPressed: () async {
          CurrentUser _auth =
          Provider.of<CurrentUser>(context, listen: false);
          String result = await _auth.signOut();
         if (result == "success") {
           _auth.curAuthStatus.value = AuthStatus.notLoggedIn;
           }
        }, icon: Icon(Icons.logout),

      ),
    );
  }
}


