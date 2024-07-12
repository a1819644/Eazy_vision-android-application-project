import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/bot_menu_page/HomepageWidget.dart';
import 'package:untitled/bot_menu_page/contactpage.dart';
import 'package:untitled/screens/home/homepage.dart';
import 'package:untitled/bot_menu_page/logpage.dart';
import 'package:untitled/bot_menu_page/notificationpage.dart';
import 'package:untitled/bot_menu_page/profilepage.dart';
import '../../custom_animated_bottom_bar.dart';
import 'package:expandable/expandable.dart';

///bot-menu bar setting - for bill-display homepage, dashboard page, notification page and profile page.
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final _inactiveColor = Colors.grey;

  Color backgroundColor = Color(0xff000000);

  List<String> titles = ['Home', 'Group', 'Notify', 'Profile'];
  List<String> bodyImages = ['assets/images/homepage.png', 'assets/images/bill.png',
    'assets/images/profile.png', 'assets/images/notification.png'];

  List<Widget>? _pages;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          automaticallyImplyLeading: false,
          title: Text(titles[_currentIndex], style: TextStyle(
            fontSize: 16,
          ),),
          backgroundColor: backgroundColor,
        ),
        backgroundColor: backgroundColor,
        body: getBody(),
        bottomNavigationBar: _buildBottomBar());
  }

  Widget _buildBottomBar() {
    return CustomAnimatedBottomBar(
      containerHeight: 56,
      backgroundColor: backgroundColor,
      selectedIndex: _currentIndex,
      showElevation: true,
      itemCornerRadius: 24,
      curve: Curves.easeInOut,
      onItemSelected: (index) => setState(() => _currentIndex = index),
      items: <MyBottomNavigationBarItem>[
        MyBottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text(titles[0]),
          activeColor: Color(0xffF4D144),
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,

        ),
        MyBottomNavigationBarItem(
          icon: Icon(Icons.contact_mail),
          title: Text(titles[1]),
          activeColor: Colors.greenAccent,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        MyBottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          title: Text(
            titles[2],
          ),
          activeColor: Colors.pink,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        MyBottomNavigationBarItem(
          icon: Icon(Icons.people),
          title: Text(titles[3]),
          activeColor: Colors.blue,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget getBody() {
    double width = 414;
    double height = MediaQuery.of(context).size.width * (812 / 375);

    //return HomepageWidget();
   // _pages ??= List.generate(bodyImages.length, (index) {
     //   return SingleChildScrollView(
       //   child: Container(color: backgroundColor, width: width, height: height, alignment: Alignment.center,
            //child: Image(image: AssetImage(bodyImages[index]), fit: BoxFit.cover,),
            //child: HomepageWidget(),
            //child: Text("Home",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
         //    ),);}).toList();
    //Notifipage(),
    _pages =[ HomepageWidget(),contactPage(),Notifipage(),Profilepage()];
       return IndexedStack(
      index: _currentIndex,
    children: _pages!,
    );

  }
}