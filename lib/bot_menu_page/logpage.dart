import 'dart:convert';
import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/bot_menu_page/utilities/my_pieChart.dart';
//should display user activities - user created a group,
// user added a bill

class getList {
  List<MemberList>? memberList;

  getList({this.memberList});

  getList.fromJson(Map<String, dynamic> json) {
    if (json['memberList'] != null) {
      memberList = <MemberList>[];
      json['memberList'].forEach((v) {
        memberList!.add(new MemberList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.memberList != null) {
      data['memberList'] = this.memberList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MemberList {
  String? fullName;
  int? gas;
  int? electricity;
  int? water;
  int? internet;

  MemberList(
      {this.fullName, this.gas, this.electricity, this.water, this.internet});

  MemberList.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    gas = json['gas'];
    electricity = json['electricity'];
    water = json['water'];
    internet = json['internet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['gas'] = this.gas;
    data['electricity'] = this.electricity;
    data['water'] = this.water;
    data['internet'] = this.internet;
    return data;
  }
}



class Logpage extends StatelessWidget{
  var parsed;
  var res;
 bool? leaderT;

 Logpage({
   required this.leaderT,
});

 FirebaseAuth _auth = FirebaseAuth.instance;


 Future<getList> getPost() async {

   User? _userCredential = await _auth.currentUser;
   var userId = _userCredential?.uid;


   print(_userCredential?.uid);
   final response = await http.post(
     Uri.parse('https://us-central1-ezbill-vision-c.cloudfunctions.net/accessTheSharesBillsPercentages'),
     headers: <String, String>{
       'Content-Type': 'application/json; charset=UTF-8',
     },
     body: jsonEncode(<String, dynamic>{
       "userId":userId
     }),
   );

   if(response.statusCode == 200){
     print("received ====================================pie chart data");
     print(response.body);
     parsed = json.decode(response.body);
     res = getList.fromJson(parsed);
     return res;

   }else{

   throw Exception('empty');
   }



 }



  // Map<String, double> dataMapUser = ;

  Map<String, double> dataMapMember = {
    "M1":186,
    "M2":168,
    "M3":132,
    "M4":123,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:ExpandableTheme(
        data:  const ExpandableThemeData(),
        child: FutureBuilder<getList>(
          future: getPost(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              return ListView.builder(
                  itemCount: snapshot.data?.memberList?.length,
                  itemBuilder: (context, int index){
                    var name = snapshot.data!.memberList![0]!.fullName;
                    print( snapshot.data!.memberList![0]!.fullName);
                    //return Text('gogo');

                    return pieChart(title: '${snapshot.data!.memberList![index]!.fullName} Usage',
                      e: snapshot.data!.memberList![0]!.electricity,
                      i: snapshot.data!.memberList![0]!.internet,
                      g: snapshot.data!.memberList![0]!.gas,
                      w: snapshot.data!.memberList![0]!.water,
                      totalNo: 0, userName: snapshot.data!.memberList![index]!.fullName,);
                  });

            }else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );

          },

        )
        // ListView(
        //   physics: BouncingScrollPhysics(),
        //   children:<Widget>[
        //
        //     Column(children: [
        //       //pieChart(title:'Personal Usage',map: dataMapUser ,totalNo: 186, userName: "John Doe",),
        //
        //       Container(
        //           child: leaderT!?
        //
        //           Column(
        //             children: [
        //
        //               pieChart(title:'Group Usage',map: dataMapMember ,totalNo: 186, userName: "Group",)
        //             ],
        //           )
        //
        //
        //
        //               :pieChart(title:'Personal Usage',map: dataMapMember ,totalNo: 186, userName: "John Doe",),)
        //
        //     ],)
        //
        //
        //   ],
        // ),
      ),


    );
  }

}

// class LogState extends State<Logpage>{
//   bool leaderT;
//
//   LogPage({
//     required this.leaderT,
//
// });
//
//
//   Map<String, double> dataMapUser = {
//     "Electricity":30,
//     "Water":0,
//     "Gas":0 ,
//     "Internet":0,
//   };
//
//   Map<String, double> dataMapMember = {
//     "M1":186,
//     "M2":168,
//     "M3":132,
//     "M4":123,
//   };
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       body:ExpandableTheme(
//         data:  const ExpandableThemeData(),
//         child: ListView(
//           physics: BouncingScrollPhysics(),
//           children:<Widget>[
//
//             Column(children: [
//
//               pieChart(title:'Personal Usage',map: dataMapUser ,totalNo: 186, userName: "John Doe",),
//
//               Container(
//                   child: leaderT!?
//
//                  pieChart(title:'Group Usage',map: dataMapMember ,totalNo: 186, userName: "Group",)),
//             ],)
//
//
//           ],
//         ),
//       ),
//
//
//      );
//   }
// }
//
