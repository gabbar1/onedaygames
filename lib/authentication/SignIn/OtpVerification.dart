

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oneday/Language/Language.dart';
import 'package:oneday/authentication/SignIn/logInProvider.dart';
import 'package:provider/provider.dart';


class OtpVerification extends StatefulWidget {
  String phone,verficationId,name,email;
  OtpVerification({Key key, @required this.phone,@required this.verficationId}) : super(key: key);

  @override
  MapScreenState createState() => MapScreenState();

}

class MapScreenState extends State<OtpVerification>
    with SingleTickerProviderStateMixin {

  final formKey  = new  GlobalKey<FormState>();
  String phoneNo,verficationId,smsCode,mob,email,password;
  bool codeSent = false;
  final DBRef = FirebaseDatabase.instance.reference();
  String uid = '';

  Future<User> getuserDetail(String phone) async {
    User user;
    var snapshot = await DBRef.child("Users").once();
    if (snapshot.value.toString().contains(phoneNo)) {
      Fluttertoast.showToast(msg: "user found");
    }
    else if(!snapshot.value.toString().contains(phoneNo)){
      Fluttertoast.showToast(msg: "user not found");
      //codeSent ?  AuthService().singInWithOPT(smsCode, verficationId) : verifyPhone(phoneNo);
    }
  }
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

  @override
  void initState() {
    super.initState();


  }



  @override
  Widget build(BuildContext context) {
    var language = Provider.of<Language>(context, listen: false);
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(language.Loginmsg,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,)),

      ),
      body: SingleChildScrollView(
        child:
        Padding(
          padding:
          EdgeInsets.only(left: 16.0, right: 16.0,top:10),
          child:
          Column(
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.all(8.0),


              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.white,
                          blurRadius: 4,
                          spreadRadius: 1,
                          offset: Offset(0, 1))
                    ]),

                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      _phonedetails()
                    ],
                  ),
                ),
              ),
              //loginButton

            ],
          ),

        ),
      ),

    );

  }



  Widget _phonedetails(){
    var login = Provider.of<LoginProvider>(context,listen: false);
    var language = Provider.of<Language>(context, listen: false);
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(bottom: 10.0,top: 10),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Padding(
                padding: EdgeInsets.only(bottom: 25.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 25.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(language.otpsentto + login.phoneNo.replaceAll("+91", " ",),
                                    style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,)
                                ),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 8.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Flexible(

                              child: new TextField(
                                maxLength: 6,
                                decoration: const InputDecoration(

                                    hintText: "Enter OTP"),
                                keyboardType: TextInputType.phone,
                                onChanged: (val){
                                  login.smsCode = val;
                                },

                              ),
                            ),
                          ],
                        )),
                    SizedBox(height: 10,),
                    Center(child: InkWell(

                      onTap:  () {
                        login.signIn(context: context,otp: login.smsCode);
                        firebaseMessaging.subscribeToTopic("new_ticket");
                        firebaseMessaging.subscribeToTopic(login.phoneNo.replaceAll("+", ""));
                      },
                      child: Container(
                        width: 230,
                        padding: EdgeInsets.symmetric(vertical: 13),
                        alignment: Alignment.center,
                        color: Colors.green,
                        child: Text(
                          'LOGIN',style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,)

                        ),
                      ),
                    ),),

                  ],
                ),
              ),
            )



          ],
        ),
      ),
    );


  }


  Future<bool> loginAction() async {
    //replace the below line of code with your login request
    await new Future.delayed(const Duration(seconds: 2));
    return true;
  }




}