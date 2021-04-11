import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:oneday/Language/Language.dart';
import 'package:oneday/Model/user.dart';
import 'package:oneday/Model/wallet.dart';
import 'package:oneday/helper/constant.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'RegisterProvider.dart';
class OtpVerification extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<OtpVerification>
    with SingleTickerProviderStateMixin {
    final formKey = GlobalKey<FormState>();
  final DBRef = FirebaseDatabase.instance.reference();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  @override
  void initState() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        final notification = message['data'];
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var language = Provider.of<Language>(context, listen: false);
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(language.regmsg,style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0,top:10),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
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
                      _phoneDetails()
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

  Widget _phoneDetails(){
    var register = Provider.of<RegisterProvider>(context,listen: false);
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
                    Padding(padding: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 25.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(language.otpsentto + register.phoneNo.replaceAll("+91", " "),
                                  style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold)
                              ),
                            ],
                          ),
                        ],
                      )),
                    Padding(padding: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Flexible(
                            child: TextField(
                              decoration: const InputDecoration(
                                  hintText: "Enter OTP"),
                              keyboardType: TextInputType.phone,
                              onChanged: (val){
                                register.smsCode = val;
                              },
                            ),
                          ),
                        ],
                      )),
                    SizedBox(height: 10,),
                    Center(child: InkWell(
                      onTap: () {
                        register.signUp(context: context,otp: register.smsCode);
                        firebaseMessaging.subscribeToTopic("new_ticket");
                        firebaseMessaging.subscribeToTopic(register.phoneNo.replaceAll("+", ""));
                      },
                      child: Container(
                        width: 230,
                        padding: EdgeInsets.symmetric(vertical: 13),
                        alignment: Alignment.center,
                        color: Colors.green,
                        child: Text(
                          'REGISTER',style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold)
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
}