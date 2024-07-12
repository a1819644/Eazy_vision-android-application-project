import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/bot_menu_page/HomepageWidget.dart';
import 'package:untitled/models/OurUser.dart';
import 'package:untitled/screens/wrapper.dart';
import 'package:untitled/services/Database.dart';
import 'package:untitled/services/CurrentUser.dart';

import 'homepage_blank.dart';

class Homepage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeGroupState();
  }
}

class HomeGroupState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Container(
        color: Colors.black,

        child: SafeArea(child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            backgroudpic(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
              CreateHomeGroup(),
              JoinHomeGroup(),
            ],),
          ],
        ),),
      ),
    );
  }
}

class backgroudpic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Column(children: [
          //Text('Log - pic under implmentation'),
          Image.asset(
            'assets/images/welcome.gif', width: 400, height: 400,
              fit: BoxFit.fill
          ),
        ]),
      ),
    );
  }
}

class HintText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(" "),
    );
  }
}

class CreateHomeGroup extends StatefulWidget {
  const CreateHomeGroup({Key? key}) : super(key: key);

  @override
  State<CreateHomeGroup> createState() => _CreateHomeGroupState();
}

class _CreateHomeGroupState extends State<CreateHomeGroup> {
  void _createGroup(BuildContext context, String groupName) async {
    CurrentUser _currentuserAuth =
        Provider.of<CurrentUser>(context, listen: false);
    String _returnString = await OurDatabase()
        .createGroup(groupName, _currentuserAuth.getCurrentuser.uid);
    print(_returnString);
    if (_returnString == "success") {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => Wrapper(),), (route) => false);
    }
  }

  TextEditingController _createHomeGroupController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ElevatedButton(
      child: Text('Create a New Group'),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Create a New Group'),
            content: TextField(
              decoration:
                  //update the home group name here
                  InputDecoration(hintText: 'Enter your home group name(id)'),
              controller: _createHomeGroupController,
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    _createGroup(context, _createHomeGroupController.text),
                child: Text('Submit'),
              )
            ],
          ),
        );
        //async{
        print('direct to another page');
        //List<UserEntry> user = await Navigator.push(
        // context,
        //MaterialPageRoute(builder: (context) => SOF(),
        //  ),
        //  );
        // if(user != null) user.forEach(print);
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        onPrimary: Colors.black,
      ),
    ));
  }
}

class JoinHomeGroup extends StatefulWidget {
  const JoinHomeGroup({Key? key}) : super(key: key);

  @override
  State<JoinHomeGroup> createState() => _JoinHomeGroupState();
}

class _JoinHomeGroupState extends State<JoinHomeGroup> {
  TextEditingController _JoinIdController = TextEditingController();
  void _joinGroup(BuildContext context, String groupId) async {
    CurrentUser _currentuserAuth =
        Provider.of<CurrentUser>(context, listen: false);
    String _returnString = await OurDatabase().joinGroup(
        groupId, _currentuserAuth.getCurrentuser.uid as String);
    if (_returnString== "success") {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => Wrapper(),), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ElevatedButton(
            child: Text('Join a Home Group'),
            onPressed: () {
              print('pop up window');
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Join the home group'),
                  content: TextField(
                    decoration:
                        //inivitation code for join the group
                        InputDecoration(hintText: 'Enter your code'),
                    controller: _JoinIdController,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () =>
                          _joinGroup(context, _JoinIdController.text),
                      child: Text('Submit'),
                    )
                  ],
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: Colors.black,
            )));
  }
}
