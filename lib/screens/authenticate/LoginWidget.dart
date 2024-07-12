import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:untitled/screens/home/homepage.dart';
import 'package:untitled/services/CurrentUser.dart';

import '../../bot_menu_page/HomepageWidget.dart';
import '../home/homepage_blank.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginpageWidgetState createState() => _LoginpageWidgetState();
}

class _LoginpageWidgetState extends State<LoginWidget> {

  final CurrentUser _auth = CurrentUser();

  //create the textfiled controller
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
    child: Container(
        width: 375,
        height: 812,
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
        child: Stack(children: <Widget>[
          Positioned(
              top: 0,
              left: 0,
              child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(),
                  child: Stack(children: <Widget>[
                    Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                            width: 41,
                            height: 41,
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Container(
                                      width: 41,
                                      height: 41,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                          bottomLeft: Radius.circular(12),
                                          bottomRight: Radius.circular(12),
                                        ),
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        border: Border.all(
                                          color:
                                              Color.fromRGBO(232, 236, 244, 1),
                                          width: 1,
                                        ),
                                      ))),
                              Positioned(
                                  top: 11,
                                  left: 10,
                                  child: Container(
                                      width: 19,
                                      height: 19,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                      ),
                                      child: Stack(children: <Widget>[
                                        Positioned(
                                          top: 2.0763585567474365,
                                          left: 4.9459991455078125,
                                          child: SvgPicture.asset(
                                              'assets/images/vector.svg',
                                              semanticsLabel: 'vector'),
                                        ),
                                      ]))),
                            ]))),
                  ]))),
          Positioned(
              top: 144,
              left: 20,
              child: Text(
                'Login Page',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(30, 35, 44, 1),
                    fontFamily: 'Urbanist',
                    fontSize: 30,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1.5 /*PERCENT not supported*/
                    ),
              )),
          Positioned(
              top: 298,
              left: 23,
              child: Container(
                  width: 330,
                  height: 56,
                  child: Stack(children: <Widget>[
                    Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                            width: 330,
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                              color: Color.fromRGBO(247, 248, 249, 1),
                              border: Border.all(
                                color: Color.fromRGBO(218, 218, 218, 1),
                                width: 1,
                              ),
                            ))),
                    TextField( //text field for the user id
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "user id",
                      ),
                    ),
                  ]))),
          Positioned(
              top: 369,
              left: 23,
              child: Container(
                  width: 330,
                  height: 56,
                  child: Stack(children: <Widget>[
                    Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                            width: 330,
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                              color: Color.fromRGBO(247, 248, 249, 1),
                              border: Border.all(
                                color: Color.fromRGBO(218, 218, 218, 1),
                                width: 1,
                              ),
                            ))),
                    TextField(//password textField
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        hintText: "password",
                      ),
                    ), //
                  ]))),
          Positioned(
              top: 455,
              left: 23,
              child: Container(
                  width: 330,
                  height: 56,
                  child: Stack(children: <Widget>[
                    Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                            width: 330,
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                              color: Color.fromRGBO(30, 35, 44, 1),
                            ))),
                    // todo: needs to "create don't remember ur password" thing @Sun
                    //converted into the login button
                    Container(
                      child: RawMaterialButton(
                        elevation: 0.0,
                        onPressed: () async {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> Homepage()));

/*
                          dynamic user = await _auth.loginUsingEmailPassword(_emailController.text, _passwordController.text);
*/
                          /*User? user = await loginUsingEmailPassword(email: _emailController.text, password: _passwordController.text, context: context);*/
                          // below code is connecting to the next page
                          /*if (user != null){
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> HomepageWidget()));
                          }
*/
                        },
                        child: Text("Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        )),
                      ),
                    ),
                  ]))),
        ])),
    );
  }
}
