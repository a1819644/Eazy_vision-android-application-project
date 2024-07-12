import 'package:flutter/material.dart';

class MyMember extends StatelessWidget{
  String? picAdd;
  String? userName;
  String? emailAdd;
  bool? leaderTag;

  MyMember({
    required this.picAdd,
    required this.userName,
    required this.emailAdd,
    required this.leaderTag,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(children: [
          Container(
            height: 80,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              //borderRadius: BorderRadius.circular(12),
            ),
            //'assets/images/id2.jpg'
            child:  CircleAvatar(
              radius: 50.0,
              backgroundImage:
              NetworkImage(
                  picAdd!),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(userName!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,),
                ),
                SizedBox(height: 10,),
                Text(emailAdd!,
                  style: TextStyle(
                    //fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.grey[600]),
                ),
                SizedBox(height: 20,),
              ],),
          ),

        ],),
        Container(
          child: leaderTag!?
              Icon(Icons.star):Icon(Icons.people_outline),
        ),
        SizedBox(width: 5,),

      ],
    );
  }



}