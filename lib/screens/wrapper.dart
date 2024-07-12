import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/SplashScreen/SplashScreen.dart';
import 'package:untitled/bot_menu_page/profilepage.dart';
import 'package:untitled/models/OurUser.dart';
import 'package:untitled/screens/authenticate/wel-login.dart';
import 'package:untitled/screens/home/homepage.dart';
import 'package:untitled/services/CurrentUser.dart';

import '../bot_menu_page/HomepageWidget.dart';
import 'home/homepage_blank.dart';

enum AuthStatus {
  unKnown,
  notLoggedIn,
  notInGroupState,
  InGroupState,
}

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  AuthStatus _authStatus = AuthStatus.unKnown;
  late ValueNotifier<AuthStatus?> _notifier;
  void _changeStatus(){
    AuthStatus? authStatus = _notifier.value;
    if(authStatus == null) return;
    setState(() {
      _authStatus = authStatus;
    });
  }

  @override
  void initState() {
    super.initState();
    _notifier = Provider.of<CurrentUser>(context, listen: false).curAuthStatus;
    _notifier.addListener(_changeStatus);
  }

  @override
  void dispose() {
    _notifier.removeListener(_changeStatus);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Wrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    //get state// check current user and change auth status
    CurrentUser _currentuser = Provider.of<CurrentUser>(context, listen: false);
    String _returnString = await _currentuser.onStartUp();
    if (_returnString == "success") {
      print("from start group");
      print(_currentuser.getCurrentuser.groupId);
      if (_currentuser.getCurrentuser.groupId != null) {
        setState(() {
          _authStatus = AuthStatus.InGroupState;
        });
      } else {
        setState(() {
          _authStatus = AuthStatus.notInGroupState;
        });
      }
    }else{
      setState(() {
        _authStatus = AuthStatus.notLoggedIn;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    Widget retVal = SplashScreen(); //loading screen
    switch (_authStatus) {
      case AuthStatus.notLoggedIn:
        retVal = Wellogin();
        break;
      case AuthStatus.notInGroupState:
        retVal = Homepage(); // for the main page HomepageWidget
        break;
      case AuthStatus.unKnown:
        retVal = SplashScreen(); // loading
        break;
      case AuthStatus.InGroupState:
        retVal = MyHomePage(); // for the main page HomepageWidget
        break;
      default:
    }
    return retVal;
/*
    if(_authStatus == AuthStatus.notLoggedIn){
      retVal = Wellogin(); // wel-log
*/
  }
}
