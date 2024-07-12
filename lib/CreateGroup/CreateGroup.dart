import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/screens/wrapper.dart';

import '../bot_menu_page/HomepageWidget.dart';
import '../services/Database.dart';
import '../services/CurrentUser.dart';

class OurCreateGroup extends StatefulWidget {
  const OurCreateGroup({Key? key}) : super(key: key);
  @override
  State<OurCreateGroup> createState() => _OurCreateGroupState();
}

class _OurCreateGroupState extends State<OurCreateGroup> {
  TextEditingController _createHomeGroupController = TextEditingController();
  void _createGroup(BuildContext context, String groupName) async {
    CurrentUser currentuserAuth = Provider.of<CurrentUser>(context,listen: false);
    OurDatabase database = OurDatabase();
    String _returnString = await database.createGroup(groupName, currentuserAuth.getCurrentuser.uid as String);
    if(_returnString == "success"){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Wrapper(),),
            (route) => false,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding:  const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[BackButton()],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
             child: Container(
               child: Column(
                 children: <Widget>[
                   TextFormField(
                     controller: _createHomeGroupController,
                     decoration: InputDecoration(
                       prefixIcon: Icon(Icons.group),
                       hintText: "Group Name",
                     ),
                   ),
                   SizedBox(
                     height: 20.0,
                   ),
                   ElevatedButton(

                     child: Padding(
                       padding:EdgeInsets.symmetric(horizontal: 100),
                       child: Text(
                         "Create",
                         style: TextStyle(
                           color: Colors.white,
                           fontWeight: FontWeight.bold,
                           fontSize: 20.0,
                         ),
                       ),
                     ),
                        onPressed: () => _createGroup(context, _createHomeGroupController.text),

                   )
                 ],
               )

             ),
          ),
        ],
      )

    );
  }
}


