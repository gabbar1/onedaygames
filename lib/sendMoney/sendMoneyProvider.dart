import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:oneday/Model/user.dart';
import 'package:oneday/Model/wallet.dart';
import 'package:oneday/Language/Language.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SendMoneyProvider extends ChangeNotifier {
  String userProfile;
  String  uName;
  String userName;
  String receiverAmount;
  String receiverAddedAmount;
  String senderAddedAmount;
  String sender_amount;
  String sending_amount;
  String receiverPhone;
  String senderPhone;
  String userprofile, userprofile1;
  String username, username1;
  DatabaseReference transRef = FirebaseDatabase.instance.reference();
  var recieverList = new List<User1>();
  String lastSent;

  void receiversPhone({String rPhone,String sPhone}) {
    this.receiverPhone = rPhone;
    this.senderPhone = sPhone;

    notifyListeners();
  }

  void getUserInput() {
    transRef
        .child("Users")
        .child("+91" + receiverPhone)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot != null) {
        Map<dynamic, dynamic> values = snapshot.value;
        var user = User1.fromJson(values);
        userprofile = user.profile;
        userprofile1 = userprofile;
        username = user.name;
        username1 = username;
        //recieverList.add(user);
      }
    });

    transRef
        .child("Users")
        .child(senderPhone)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot != null) {
        Map<dynamic, dynamic> values = snapshot.value;
        var user = User1.fromJson(values);
        userProfile = user.profile;
        userName = user.name;
      }
    });
  }

  void getSentDetails() {
    recieverList.clear();
    transRef.child("Sent_money").once().then((DataSnapshot snapshot) {
      var values = snapshot.value;
      values.forEach((key, values) {
        User1 phone1 = User1(phone: values["phone"]);
        recieverList.add(phone1);
      });
    });
  }

  void getDetails({String senderPhone}) {
    print("----===" + senderPhone);

  }

  getWalletDetails({String senderPhone, recPhone}) {
    print("+++++++++++++++++++++++++++++" + recPhone);
    transRef
        .child("Wallet")
        .child("+91" + recPhone)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot != null) {
        Map<dynamic, dynamic> values = snapshot.value;
        var wallet = Wallet.fromJson(values);

        receiverAmount = wallet.total_amount.toString();
        receiverAddedAmount = wallet.added_amount.toString();
      }
    });

    transRef
        .child("Wallet")
        .child(senderPhone)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot != null) {
        Map<dynamic, dynamic> values = snapshot.value;
        var wallet = Wallet.fromJson(values);
        sender_amount = wallet.total_amount.toString();
        senderAddedAmount = wallet.added_amount.toString();
      }
    });
  }

  getSearchedUser({String senderPhone}) {

    transRef
        .child("Users")
        .child(senderPhone)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot != null) {
        Map<dynamic, dynamic> values = snapshot.value;
        var user = User1.fromJson(values);
        userProfile = user.profile;
        userName = user.name;
      }
    });
  }

  sendMoney(
      {String recieverPhone,
      String senderPhone,
      BuildContext context,
      GlobalKey<ScaffoldState> scaffoldKey,
      String userNames}) {
    transRef
        .child("Users")
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot != null) {
        print("000000000000000"+snapshot.key.toString());
        Map<dynamic, dynamic> values = snapshot.value;
        var user = User1.fromJson(values);
        userProfile = user.profile;
        userName = user.name;
      }
    });
    var language = Provider.of<Language>(context, listen: false);
    if (username != null) {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
              title: Center(
                child: Text(language.send_msg + " " + username),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Center(
                      child: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(userprofile == null
                              ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFDjXj1F8Ix-rRFgY_r3GerDoQwfiOMXVt-tZdv_Mcou_yIlUC&s"
                              : userprofile)),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 8.0),
                      child: new TextField(
                        decoration:
                            InputDecoration(hintText: language.amnt_msg),
                        keyboardType: TextInputType.phone,
                        onChanged: (val) {
                          this.sending_amount = val;
                        },
                      ),
                    ),
                    RaisedButton(
                        child: Text(language.send),
                        onPressed: () {

                          print(
                              "-------------------source---------------------" +
                                  userName.toString());
                          print(
                              "-------------------destination---------------------" +
                                  receiverAmount.toString());

                          Navigator.pop(context);

                          var now = new DateTime.now();
                          if (int.parse(sending_amount) >
                              int.parse(sender_amount)) {
                            Fluttertoast.showToast(msg: language.not_money_msg);
                          } else {

                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                });
                            transRef
                                .child("Wallet")
                                .child("+91" + recieverPhone)
                                .update({
                              'total_amount': int.parse(receiverAmount) +
                                  int.parse(sending_amount),
                              'added_amount': int.parse(receiverAddedAmount) +
                                  int.parse(sending_amount),
                              'time': DateFormat('EEEE, d MMM, yyyy,h:mm:ss a')
                                  .format(now),
                            });
                            transRef.child("Wallet").child(senderPhone).update({
                              'total_amount': int.parse(sender_amount) -
                                  int.parse(sending_amount),
                              'added_amount': int.parse(senderAddedAmount) -
                                  int.parse(sending_amount),
                              'time': DateFormat('EEEE, d MMM, yyyy,h:mm:ss a')
                                  .format(now),
                            });

                            transRef
                                .child("Sent_money")
                                .child(receiverPhone)
                                .update({
                              'phone': receiverPhone,
                            });
                            transRef
                                .child('User_Transaction')
                                .child(senderPhone)
                                .push()
                                .set({
                              'name': username,
                              'amount': sending_amount,
                              'status': "S",
                              'time': DateFormat('EEEE, d MMM, yyyy,h:mm:ss a')
                                  .format(now),
                            });

                            transRef
                                .child('User_Transaction')
                                .child("+91" + recieverPhone)
                                .push()
                                .set({
                              'name': username,
                              'amount': sending_amount,
                              'status': "R",
                              'time': DateFormat('EEEE, d MMM, yyyy,h:mm:ss a')
                                  .format(now),
                            });

                            Future.delayed(Duration(seconds: 5));
                            Navigator.pop(context);
                            scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text(language.money_sent,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ));
                            print("------------------"+userName);
                            sendNotification(
                                subject: "Hey " +
                                    userName +
                                    " has sent you " +
                                    sending_amount +
                                    " rupees in your wallet",
                                title:
                                userName.toUpperCase() + " sent you money",
                                topic: receiverPhone);
                          }
                        })
                    //Text('You Needed '+(transaction["Amount"] - int.parse(amount1)).toString()+" ₹ to play"),
                  ],
                ),
              ));
        },
      );
    }
    notifyListeners();
  }

  Future<void> getSentUserDetails({String receiverPhone,senderPhone,BuildContext context,GlobalKey<ScaffoldState> scaffoldKey}) async{
    var language = Provider.of<Language>(context, listen: false);
    getWalletDetails(senderPhone: senderPhone,recPhone: receiverPhone);
    transRef.child("Users").child("+91"+receiverPhone).once().then((DataSnapshot snapshot) {
      print("-------------reeeeeeeeeeeeeeee-----"+receiverPhone);
      if (snapshot != null) {
        Map<dynamic, dynamic> values = snapshot.value;
        var sentUser = User1.fromJson(values);

          return showDialog<void>(
            context: context,
            barrierDismissible: true, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Center(
                    child: Text(language.send_msg + " " + sentUser.name),
                  ),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Center(
                          child: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(sentUser.profile == null
                                  ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFDjXj1F8Ix-rRFgY_r3GerDoQwfiOMXVt-tZdv_Mcou_yIlUC&s"
                                  : sentUser.profile)),
                        ),
                        Padding(
                          padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 8.0),
                          child: new TextField(
                            decoration:
                            InputDecoration(hintText: language.amnt_msg),
                            keyboardType: TextInputType.phone,
                            onChanged: (val) {
                              this.sending_amount = val;
                            },
                          ),
                        ),
                        RaisedButton(
                            child: Text(language.send),
                            onPressed: () {

                              var now = new DateTime.now();
                              if (int.parse(sending_amount) >
                                  int.parse(sender_amount)) {
                                Fluttertoast.showToast(msg: language.not_money_msg);
                              } else {
                                transRef
                                    .child("Wallet")
                                    .child("+91" + receiverPhone)
                                    .update({
                                  'total_amount': int.parse(receiverAmount) +
                                      int.parse(sending_amount),
                                  'added_amount': int.parse(receiverAddedAmount) +
                                      int.parse(sending_amount),
                                  'time': DateFormat('EEEE, d MMM, yyyy,h:mm:ss a')
                                      .format(now),
                                });
                                transRef.child("Wallet").child(senderPhone).update({
                                  'total_amount': int.parse(sender_amount) -
                                      int.parse(sending_amount),
                                  'added_amount': int.parse(senderAddedAmount) -
                                      int.parse(sending_amount),
                                  'time': DateFormat('EEEE, d MMM, yyyy,h:mm:ss a')
                                      .format(now),
                                });

                                transRef
                                    .child("Sent_money")
                                    .child(receiverPhone)
                                    .update({
                                  'phone': receiverPhone,
                                });
                                transRef
                                    .child('User_Transaction')
                                    .child(senderPhone)
                                    .push()
                                    .set({
                                  'name': sentUser.name,
                                  'amount': sending_amount,
                                  'status': "S",
                                  'time': DateFormat('EEEE, d MMM, yyyy,h:mm:ss a')
                                      .format(now),
                                });

                                transRef
                                    .child('User_Transaction')
                                    .child("+91" + receiverPhone)
                                    .push()
                                    .set({
                                  'name': sentUser.name,
                                  'amount': sending_amount,
                                  'status': "R",
                                  'time': DateFormat('EEEE, d MMM, yyyy,h:mm:ss a')
                                      .format(now),
                                });

                                Future.delayed(Duration(seconds: 5));
                                Navigator.pop(context);
                                scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(language.money_sent,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ));
                                sendNotification(
                                    subject: "Hey " +
                                        sentUser.name +
                                        " has sent you " +
                                        sending_amount +
                                        " rupees in your wallet",
                                    title:
                                    sentUser.name.toUpperCase() + " sent you money",
                                    topic: receiverPhone);
                              }
                            })
                        //Text('You Needed '+(transaction["Amount"] - int.parse(amount1)).toString()+" ₹ to play"),
                      ],
                    ),
                  ));
            },
          );


      }
    });
  }


  Future<void> sendNotification({subject, title, topic}) async {

    final postUrl = 'https://fcm.googleapis.com/fcm/send';

    String toParams = "/topics/" + '91' + topic;

    final data = {
      "notification": {"body": subject, "title": title},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done",
        "sound": 'default',
        "screen": "yourTopicName",
      },
      "to": "${toParams}"
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAAbOjOht4:APA91bHc0v_1SaXaEW1efkvqO1J3q40a7ZvyQTPddzlnYAo_3_TU9sln2WCTW_DVw_cMK6rcp2xIadhhhPMeEsmJr5PjpSt10dgOekjpWB2wYQijqWE0vwLrpiQe4etVQVVL7h9fgrtH'
    };

    final response = await http.post(postUrl,
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
// on success do
      print("true");
    } else {
// on failure do
      print("false");
    }
  }
}
