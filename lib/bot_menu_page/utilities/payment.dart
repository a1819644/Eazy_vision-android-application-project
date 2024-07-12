import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/bot_menu_page/utilities/my_button.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';


class NewPayment extends StatefulWidget {

  @override
  State<NewPayment> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<NewPayment> {
  var parsed;
  var payLink;


  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendPayReq(String type) async {

    User? _userCredential = await _auth.currentUser;
    var userId = _userCredential?.uid;
    print('send pay request' + type);
    final response = await http.post(Uri.parse('https://us-central1-ezbill-vision-c.cloudfunctions.net/payments'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        //"groupId":"C0Zx90b1eQwSKgbRnxen",
        "userId":userId,
        "billType":type,
      }),
    );
    await Future.delayed(Duration(seconds: 10));
    var res2 = await http.post(Uri.parse('https://us-central1-ezbill-vision-c.cloudfunctions.net/paymentSecond'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        //"groupId":"C0Zx90b1eQwSKgbRnxen",
        "userId":userId,
        "billType":type,
      }),
    );


    if(response.statusCode == 200){
      print("received!!");
      parsed = json.decode(response.body);
      print('url is grabbed!!!!!');
      print(parsed['paymentLink']['url']);
    
      payLink = parsed['paymentLink']['url'];
      if (!await launchUrl(Uri.parse(payLink))) {
        throw 'Could not launch $payLink';
      }
    }
    if(res2.statusCode == 200){
      print("second payment request sent");
      print(res2.body);
      showSnackBar("Payment updated! Please back to Homepage", Duration(seconds: 2));
    }
  }

  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(

        child:
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select payment bill type:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),),
                  IconButton(onPressed: (){Navigator.of(context).pop();}, icon: Icon(Icons.close)),
                ],),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Button(iconPath: 'assets/images/icon-electri.png', buttonText: 'Electricity'),
                  IconButton(onPressed: (){
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Pay Electricity Bill'),
                        content: const Text('Do you want to pay Electricity bill?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => sendPayReq("electricity"),
                            child: const Text('Yes'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Later'),
                            child: const Text('Later'),
                          ),
                        ],
                      ),
                    );
                    // Navigator.push(context, MaterialPageRoute(fullscreenDialog: false, builder: (context)=> Logpage()));
                  },
                      icon: Icon(Icons.arrow_forward_ios)),],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Button(iconPath: 'assets/images/icon-gas.png', buttonText: 'Gas'),
                  IconButton(onPressed: (){
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Pay Gas Bill'),
                        content:

                        Text('Do you want to pay Gas bill?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => sendPayReq("gas"),
                            child: const Text('Yes'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Later'),
                            child: const Text('Later'),
                          ),
                        ],
                      ),
                    );
                  },
                      icon: Icon(Icons.arrow_forward_ios)),],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Button(iconPath: 'assets/images/icon-internet.png', buttonText: 'Internet'),
                  IconButton(onPressed: (){
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Pay Internet Bill'),
                        content: const Text('Do you want to pay Internet bill?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => sendPayReq("internet"),
                            child: const Text('Yes'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Later'),
                            child: const Text('Later'),
                          ),
                        ],
                      ),
                    );
                    // Navigator.push(context, MaterialPageRoute(fullscreenDialog: false, builder: (context)=> Logpage()));
                  },
                      icon: Icon(Icons.arrow_forward_ios)),],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Button(iconPath: 'assets/images/icon-water.png', buttonText: 'Water'),
                  IconButton(onPressed: (){
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Pay Water Bill'),
                        content: const Text('Do you want to pay Water bill?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => sendPayReq("water"),
                            child: const Text('Yes'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Later'),
                            child: const Text('Later'),
                          ),
                        ],
                      ),
                    );
                    // Navigator.push(context, MaterialPageRoute(fullscreenDialog: false, builder: (context)=> Logpage()));
                  },
                      icon: Icon(Icons.arrow_forward_ios)),],),

            ],
          ),
        ),

      ),

    );
  }
}