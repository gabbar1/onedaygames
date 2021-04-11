import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:oneday/dashBoard/homeNavigator.dart';
import 'package:oneday/screen/StartPage.dart';
import 'package:oneday/dashBoard/dashboard.dart';

class AuthService extends ChangeNotifier {
  AuthService();
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context,spanshot){
        if(spanshot.hasData){
          return HomeNavigator();
        } else {
          return StartPage();
        }

      }
      );
  }

  signOut() {
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }





}