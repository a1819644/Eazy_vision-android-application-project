import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/screens/home/homepage.dart';
import 'package:untitled/screens/home/homepage_blank.dart';
import 'package:untitled/screens/wrapper.dart';
import 'package:untitled/services/CurrentUser.dart';

import '../../bot_menu_page/HomepageWidget.dart';
import 'RegisterWidget.dart';


class Wellogin extends StatefulWidget {
  const Wellogin({Key? key}) : super(key: key);

  @override
  State<Wellogin> createState() => _WelloginState();
}

class _WelloginState extends State<Wellogin> {
  CurrentUser authService = new CurrentUser();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> _signInuser(
      String email, String password, BuildContext context) async {
     CurrentUser _auth = Provider.of<CurrentUser>(context, listen: false);
    try {
      if (await _auth.loginUsingEmailPassword( email, password,) == "success") {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Wrapper(),),
              (route) => false,
        );
      }else
        {
          print("type the correct user id and password");
        }
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Material(

      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
            ),
            Container(
              child: Image.asset(
                'assets/images/logo.jpg',
                height: 200,
                width: 200,
              ),
            ),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Sign in',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                //forgot password screen
              },
              child: const Text(
                'Forgot Password',
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                    child: const Text('Login'),
                    onPressed: () async {
                      await _signInuser(
                          emailController.text, passwordController.text, context);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      onPrimary: Colors.white,
                    ))),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Do not have an account?'),
                TextButton(
                  child: const Text(
                    'Sign up',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    //signup screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterWidget()));
                  },
                )
              ],
            ),
          ],
        )),);
  }
}
