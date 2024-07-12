import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/bot_menu_page/utilities/my_button.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';


class NewBill extends StatefulWidget {

  @override
  State<NewBill> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<NewBill> {
  TextEditingController billAmount = new TextEditingController();
  TextEditingController sDate = new TextEditingController();
  TextEditingController dDate = new TextEditingController();
  var parsed;

  Future<void> sendPayReq(String type,String startDate, String dueDate,int amount) async {
    print("at this point #################################################");
    //print(amount);
    String link = "https://us-central1-ezbill-vision-c.cloudfunctions.net/createBillsLeader";
    print('send new bill request' + type);
    final response = await http.post(
      Uri.parse(link),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "toDate":startDate,
        "fromDate":dueDate,
        "billType":type, //for “gas” “water” “internet”
        "amount":amount,
      }),
    );

    if(response.statusCode == 200){
      print("received!!");
      showSnackBar("Bill sent!" + type, Duration(seconds: 5));
      parsed = json.decode(response.body);
      showSnackBar("Bill sent!", Duration(seconds: 2));
      print(response.body);
    }else{
      showSnackBar("Not able to sent!", Duration(seconds: 2));
    }
  }

  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        resizeToAvoidBottomInset : false,
        body: SafeArea(
          //padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select updated bill type:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),),
                        IconButton(onPressed: (){Navigator.of(context).pop();}, icon: Icon(Icons.close)),
                      ],),
                    //SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Button(iconPath: 'assets/images/icon-electri.png', buttonText: 'Electricity'),
                        IconButton(onPressed: (){
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                                AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  //title: const Text('Update Electricity Bill',style: TextStyle(fontSize: 10),),
                                  content:
                                      SingleChildScrollView(
                                        physics: const AlwaysScrollableScrollPhysics(),
                                        child:  Column(
                                          children: [
                                            Text('Update Electricity Bill',style: TextStyle(fontSize: 20),),
                                            SizedBox(height: 10,),
                                            TextField(
                                              controller: billAmount,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Input the amount of bill',
                                              ),
                                            ),
                                            SizedBox(height: 5,),
                                            TextField(
                                              controller: sDate,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Input the start date DD/MM/YY',
                                              ),
                                            ),
                                            SizedBox(height: 5,),
                                            TextField(
                                              controller: dDate,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Input the due date DD/MM/YY',
                                              ),
                                            ),
                                          ],
                                        ),

                                      ),

                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => sendPayReq(
                                        //String type,String startDate, String dueDate,int amount
                                          'electricity',sDate.text.toString(),dDate.text.toString(),int.parse(billAmount.text)),
                                      child: const Text('Add'),
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
                            builder: (BuildContext context) =>
                                AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  //title: const Text('Update Electricity Bill',style: TextStyle(fontSize: 10),),
                                  content:
                                  SingleChildScrollView(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    child:Container(
                                      child:
                                      Column(
                                        children: [
                                          Text('Update Gas Bill',style: TextStyle(fontSize: 20),),
                                          SizedBox(height: 10,),
                                          TextField(
                                            controller: billAmount,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Input the amount of bill',
                                            ),
                                          ),
                                          SizedBox(height: 5,),
                                          TextField(
                                            controller: sDate,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Input the start date DD/MM/YY',
                                            ),
                                          ),
                                          SizedBox(height: 5,),
                                          TextField(
                                            controller: dDate,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Input the due date DD/MM/YY',
                                            ),
                                          ),
                                        ],
                                      ),),
                                  ),

                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => sendPayReq('gas',sDate.text.toString(),dDate.text.toString(),int.parse(billAmount.text)),
                                      child: const Text('Add'),
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
                        Button(iconPath: 'assets/images/icon-internet.png', buttonText: 'Internet'),
                        IconButton(onPressed: (){
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                                AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  //title: const Text('Update Electricity Bill',style: TextStyle(fontSize: 10),),
                                  content:
                                      SingleChildScrollView(
                                        physics: const AlwaysScrollableScrollPhysics(),
                                        child: Container(
                                          child:
                                          Column(
                                            children: [
                                              Text('Update Internet Bill',style: TextStyle(fontSize: 20),),
                                              SizedBox(height: 10,),
                                              TextField(
                                                controller: billAmount,
                                                decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Input the amount of bill',
                                                ),
                                              ),
                                              SizedBox(height: 5,),
                                              TextField(
                                                controller: sDate,
                                                decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Input the start date DD/MM/YY',
                                                ),
                                              ),
                                              SizedBox(height: 5,),
                                              TextField(
                                                controller: dDate,
                                                decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Input the due date DD/MM/YY',
                                                ),
                                              ),
                                            ],
                                          ),),
                                      ),

                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => sendPayReq('internet',sDate.text.toString(),dDate.text.toString(),int.parse(billAmount.text)),
                                      child: const Text('Add'),
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
                            builder: (BuildContext context) =>
                                AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  //title: const Text('Update Electricity Bill',style: TextStyle(fontSize: 10),),
                                  content:
                                  SingleChildScrollView(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                      child: Container(
                                        child:
                                        Column(
                                          children: [
                                            Text('Update Water Bill',style: TextStyle(fontSize: 20),),
                                            SizedBox(height: 10,),
                                            TextField(
                                              controller: billAmount,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Input the amount of bill',
                                              ),
                                            ),
                                            SizedBox(height: 5,),
                                            TextField(
                                              controller: sDate,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Input the start date DD/MM/YY',
                                              ),
                                            ),
                                            SizedBox(height: 5,),
                                            TextField(
                                              controller: dDate,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Input the due date DD/MM/YY',
                                              ),
                                            ),
                                          ],
                                        ),),
                                  ),

                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => sendPayReq('water',sDate.text.toString(),dDate.text.toString(),int.parse(billAmount.text)),
                                      child: const Text('Add'),
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
              ],

            ),
          ),
        ),
      )
      );
  }
}