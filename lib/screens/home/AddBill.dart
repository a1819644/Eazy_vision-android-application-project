import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
//should display user activities - user created a group,
// user added a bill

class AddBill extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

    return AddBillState();
  }


}

class AddBillState extends State<AddBill>{

  TextEditingController totalController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  String selectedValue = "Water Bill";
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:ExpandableTheme(
        data:  const ExpandableThemeData(

        ),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Text('New Bill page under implmentation'
                'waiting for server to set up connection for message dispay'),
            // Image.asset('assets/images/notification.png'),
            Container(
              child: TextField(
                controller: totalController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Input total amout of bill'
                ),
              ),
            ),
            Container(
              child: TextField(
                controller: dueDateController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Input Due Date of bill'
                ),
              ),
            ),
            Container(
                child:DropdownButton<String>(
                  value: selectedValue,

                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                    });
                  },
                  items:dropdownItems,
                )
            ),
          ],
        ),
      ),

    );

  }
  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Water Bill"),value: "Water Bill"),
      DropdownMenuItem(child: Text("Gas Bill"),value: "Gas Bill"),
      DropdownMenuItem(child: Text("Eletricity"),value: "Elec Bill"),
      DropdownMenuItem(child: Text("Internet"),value: "Internet Bill"),
    ];
    return menuItems;
  }

}