import 'package:flutter/material.dart';

class Button extends StatelessWidget{
  String iconPath;
  String buttonText;

  Button({
    required this.iconPath,
    required this.buttonText,
  });



  @override
  Widget build(BuildContext context) {


    return  Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 50,
                width: 50,
                //padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    //borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.shade400,
                        blurRadius: 20,
                        spreadRadius: 10,)
                    ]
                ),
                child: Center(
                  child: Image.asset(iconPath),
                ),
              ),
              SizedBox(width: 20,),

              Text(buttonText,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),

            ],

          ),
          SizedBox(height: 10,),
        ],
      ),
    );
  }



}