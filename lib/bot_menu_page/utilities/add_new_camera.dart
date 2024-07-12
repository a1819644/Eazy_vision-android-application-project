import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class newCamera extends StatelessWidget {
  String gid;
  newCamera({required this.gid});

  var parsed;
  TextEditingController inpu1 = new TextEditingController();
  TextEditingController inpu2 = new TextEditingController();
  //TextEditingController inpu3 = new TextEditingController();



  Future<void> sendCam(String camId,String location) async {
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    print(location);
    final response = await http.post(
      Uri.parse(
          'https://us-central1-ezbill-vision-c.cloudfunctions.net/inputCameraIdFromClientSide'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        //   "groupId":"C0Zx90b1eQwSKgbRnxen",
        //    "camId":"cam001",
        //    "location":"livingRoom" //
        //todo change groupid to userid and camid and location to userinput
        "groupId":gid,
        "camId":camId,
        "location":location,

      }),
    );

    if(response.statusCode == 200){
      print("received-------------------camera update result");
      print('received group id +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++' + gid);
      parsed = json.decode(response.body);
      print(parsed);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child:
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Add a new camera to the group: ",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            Column(children: [

              TextField(controller: inpu1 , decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'CameraId',
              )),
              TextField(controller: inpu2 , decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Locaiton - Kitchen / LivingRoom / Unknown',
              )),
            ],),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // IconButton(onPressed: (){Navigator.of(context).pop();}, icon: Icon(Icons.close)),
                TextButton(onPressed: () =>sendCam(inpu1.text.toString(), inpu2.text.toString()), child: Text('send')),
                TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text('back')),

              ],
            )
          ],


        ),
      ),



    );
  }


}





