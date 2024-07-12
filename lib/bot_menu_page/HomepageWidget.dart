import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:untitled/bot_menu_page/logpage.dart';
import 'package:untitled/bot_menu_page/utilities/my_billCard.dart';
import 'package:untitled/bot_menu_page/utilities/payment.dart';
import 'utilities/my_button.dart';
import 'utilities/my_new_bill.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

const double _kSize = 100;

class HomepageWidget extends StatefulWidget {
  @override
  _HomepageWidgetState createState() => _HomepageWidgetState();
}

class _HomepageWidgetState extends State<HomepageWidget> {
  var total;
  final _controller = PageController();
  var leaderTag;

  var parsed;

  FirebaseAuth _auth = FirebaseAuth.instance;


  Future<void> getPost() async {

    User? _userCredential = await _auth.currentUser;
    var userId = _userCredential?.uid;

    print(_userCredential?.email);
    final response = await http.post(
      Uri.parse('https://us-central1-ezbill-vision-c.cloudfunctions.net/accessTheBills'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'userId': userId,
      }),
    );

    if(response.statusCode == 200){
      print("received ====================================home page data");
      parsed = json.decode(response.body);}
      total= parsed['waterBill']['amount'] + parsed['gasBill']['amount'] + parsed['electricityBill']['amount']+ parsed['internetBill']['amount'];
      print("calculated : " + total.toString());
      print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExpandableTheme(
        data: const ExpandableThemeData(iconColor: Colors.blue, useInkWell: true,
        ),
        child: FutureBuilder(
            future: getPost(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child:
              LoadingAnimationWidget.newtonCradle(
                color: Colors.black,
                size: 2 * _kSize,
              ),);
        }else{
            return ListView(
               physics: const BouncingScrollPhysics(),
                 children: <Widget>[
                   Column(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                       Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 25.0),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Row(
                               children: const [
                                 Text("My",
                                   style: TextStyle(
                                     fontSize: 28,
                                     fontWeight: FontWeight.bold,
                                   ),
                                 ),
                                 Text('Bills',
                                   style: TextStyle(
                                     fontSize: 28,),
                                 ),
                               ],
                             ),

                             Container(
                               child: parsed['isLeader']!?
                               IconButton(onPressed: ()
                               {Navigator.push(context,
                                   MaterialPageRoute(
                                       builder: (context)=> NewBill()));
                               }, icon: Icon(Icons.add)) : Text('Member'),
                             ),
                           ],
                         ),

                       ),
                       Column(
                         children: [
                           SizedBox(
                             height: 200,
                             child: PageView(
                               scrollDirection: Axis.horizontal,
                               controller: _controller,
                               children: [
                                 billCard(picAddress:'assets/images/water.jpg', billType: 'Water Bill', amount:parsed['waterBill']['amount'].toString(), toDate:parsed['waterBill']['toDate'].toString(), fromDate: parsed['waterBill']['fromDate'].toString()),
                                 billCard(picAddress:'assets/images/gas2.jpg', billType: 'Gas Bill', amount:parsed['gasBill']['amount'].toString(), toDate:parsed['gasBill']['toDate'].toString(), fromDate: parsed['gasBill']['fromDate'].toString()),
                                 billCard(picAddress:'assets/images/socket1.jpg', billType: 'Electricity Bill', amount:parsed['electricityBill']['amount'].toString(), toDate:parsed['electricityBill']['toDate'].toString(), fromDate: parsed['electricityBill']['fromDate'].toString()),
                                 billCard(picAddress:'assets/images/ie2.jpg', billType: 'Internet Bill', amount:parsed['internetBill']['amount'].toString(), toDate:parsed['internetBill']['toDate'].toString(), fromDate: parsed['internetBill']['fromDate'].toString()),
                               ],
                             ),
                           ),
                           SizedBox(height: 10),
                           SmoothPageIndicator(
                             controller: _controller,
                             count: 4,
                             effect: ExpandingDotsEffect(
                                 activeDotColor: Colors.black
                             ),),
                         ],
                       ),
                       Divider(),
                       Column(
                         children: [
                           SizedBox(height: 5),
                           //2 buttons -> pay bills - view statics
                           Column(
                             //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             children: [
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                                 children: [
                                   Button(iconPath: 'assets/images/icon-payment.png', buttonText: 'Make a Payment'),
                                   IconButton(onPressed: (){
                                     Navigator.push(context, MaterialPageRoute(fullscreenDialog: false, builder: (context)=> NewPayment()));
                                   },
                                       icon: Icon(Icons.arrow_forward_ios)),
                                 ],),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                                 children: [
                                   Button(iconPath: 'assets/images/icon-stat.png', buttonText: 'View Your Usage'),
                                   IconButton(
                                       onPressed: (){
                                         Navigator.push(context, MaterialPageRoute(fullscreenDialog: false, builder: (context)=> Logpage( leaderT: parsed['isLeader'],)));
                                       },
                                       icon: Icon(Icons.arrow_forward_ios)),
                                 ],
                               ),
                               Padding(
                                 padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Row(
                                       children: const [
                                         Text("Total",
                                           style: TextStyle(
                                             fontSize: 28,
                                             fontWeight: FontWeight.bold,
                                           ),
                                         ),
                                         Text("Balance",
                                           style: TextStyle(
                                             fontSize: 28,
                                           ),
                                         ),
                                       ],
                                     ),
                                     Text('\$ ' + total.toString(),
                                       style: TextStyle(
                                         fontSize: 28,),
                                     ),
                                   ],
                                 ),
                               ),
                             ],
                           ),

                         ],
                       ),

                     ],
                   )

              //GroupMemberList(),
    ],
    );
    }
      }

      ),
    ));
  }
}


