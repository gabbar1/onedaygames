import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:oneday/Model/lottery.dart';
import 'package:oneday/Model/notification.dart';
import 'package:oneday/Model/number.dart';
import 'package:oneday/Model/wallet.dart';
import 'package:oneday/Model/winner_price.dart';
import 'package:oneday/Winner/Winners.dart';
import 'package:oneday/helper/appUtils.dart';
import 'package:oneday/helper/constant.dart';
import 'package:oneday/screen/payment/load_payment.dart';
import 'package:oneday/test/Send_money_avidence.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../test/Leaderboard.dart';
import '../ticket/NumericKeyboard.dart';

class API extends ChangeNotifier{
  var ticket_deadline;
  var ticket_deadline1;
  String updated_deadline ;
  DatabaseReference transRef = FirebaseDatabase.instance.reference();
  var daily_ticket =  <Lottery>[];
  var weekly_ticket =  <Lottery>[];
  var monthly_ticket = <Lottery>[];
  var special_ticket = <Lottery>[];
  var leaderBoardList = <Winner_price>[];
  var notificationList = <NotificationModel>[];
  var name;
  var total_amount1,added_amount1,winning_amount1;
  var user1;
  var num_of_game;
  String email;
  String username;
  String userprofile;
  String user_ac;
  String phone,state,pincode;
  String type;

  Future<void >getDailyLottery({BuildContext context}) async{
    onLoading(context: context,strMessage: "Loading");
    transRef.child('Lottery').child("daily").once().then((DataSnapshot snapshot) {

      print("------------Waiting-----------");
      daily_ticket.clear();
      if(snapshot!= null){
        print("------fgghfhf-------"+snapshot.hashCode.toString());
        Navigator.pop(context);
        Map<dynamic, dynamic> lotteryList = snapshot.value;
        lotteryList.forEach((key,value) {
          Lottery sold = Lottery.fromJson(value);
          print(sold.status.toString());
          if(sold.status == 1){
            daily_ticket.add(sold);
            daily_ticket.sort((a,b) => DateFormat('yyyy-MM-dd').parse(b.start_date).compareTo(DateFormat('yyyy-MM-dd').parse(a.start_date)));
            notifyListeners();
          }
        });
      }
    });

  }

  Future<void >getWeeklyLottery({String type}) async{

    transRef.child('Lottery').child("weekly").once().then((DataSnapshot snapshot) {
      // onLoading(context: AppUtils().routeObserver.navigator.context,strMessage: "Loading");
      print("------------Waiting-----------");
      weekly_ticket.clear();
      if(snapshot!= null){
        Map<dynamic, dynamic> lotteryList = snapshot.value;
        lotteryList.forEach((key,value) {
          Lottery sold = Lottery.fromJson(value);
          print(sold.status.toString());
          if(sold.status == 1){
            weekly_ticket.add(sold);
            weekly_ticket.sort((a,b) => DateFormat('yyyy-MM-dd').parse(b.start_date).compareTo(DateFormat('yyyy-MM-dd').parse(a.start_date)));
            notifyListeners();
          }
        });
      }
    });

  }

  Future<void >getMonthlyLottery({String type}) async{

    transRef.child('Lottery').child("monthly").once().then((DataSnapshot snapshot) {
      monthly_ticket.clear();
      if(snapshot!= null){
        Map<dynamic, dynamic> lotteryList = snapshot.value;
        lotteryList.forEach((key,value) {
          Lottery sold = Lottery.fromJson(value);
          print(sold.status.toString());
          if(sold.status == 1){
            monthly_ticket.add(sold);
            monthly_ticket.sort((a,b) => DateFormat('yyyy-MM-dd').parse(b.start_date).compareTo(DateFormat('yyyy-MM-dd').parse(a.start_date)));
            notifyListeners();
          }
        });
      }
    });

  }
  Future<void >getSpecialLottery({String type}) async{
    transRef.child('Lottery').child("special").once().then((DataSnapshot snapshot) {
      special_ticket.clear();
      if(snapshot!= null){
        Map<dynamic, dynamic> lotteryList = snapshot.value;
        lotteryList.forEach((key,value) {
          Lottery sold = Lottery.fromJson(value);
          print(sold.status.toString());
          if(sold.status == 1){
            special_ticket.add(sold);
            special_ticket.sort((a,b) => DateFormat('yyyy-MM-dd').parse(b.start_date).compareTo(DateFormat('yyyy-MM-dd').parse(a.start_date)));
            notifyListeners();
          }
        });
      }
    });

  }

  getremainingtime(String deadline) async{
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    var formated = DateTime.parse(formatter.format(DateTime.parse(deadline)));

    ticket_deadline1 = ((formated.difference(DateTime.now()).inSeconds));
    //print("------------formated----------"+formated.toString());
    ticket_deadline = await((ticket_deadline1 / 3600).truncate().toString().padLeft(2,"0") + ":"+(((ticket_deadline1 / 60).truncate() % 60).toString()).padLeft(2,"0")+":"+((ticket_deadline1 % 60).toString())).padLeft(2,"0");
    notifyListeners();
  //  print("---------------ticket_deadline_count"+ticket_deadline1.toString());
    if(ticket_deadline1>=0){
      return ticket_deadline;
      notifyListeners();
    }
    else {
      return "Closed";
      notifyListeners();
    }





  }
  comparetimeleft(String deadline){

    var new_date = DateTime.parse(deadline);
    ticket_deadline1 = ((new_date.difference(DateTime.now()).inSeconds));
    return ticket_deadline1;
  }
  Future<void> AfterTimeLeft(int remainingtime,BuildContext context,String deadlinetext,String resultdate,String winnerlist,String cancel,String uid,String type,String ticket_id,String limit_ticket,String total_amount1,String amount,String insufficient,String money_msg,String remain_1st,String remain_2nd,String admoney,String email,int price,int numberofshell,String winning_amount1,String added_amount1,String deadline,int index){

    if(remainingtime<=0){
      return showDialog<void>(
        context: context,
        barrierDismissible: true,
        // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(' Ticket Closed ',
                style: GoogleFonts.barlowCondensed(
                    textStyle: Theme.of(context)
                        .textTheme
                        .headline5,
                    fontSize: 10,
                    fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      deadlinetext +
                          resultdate,
                      style:
                      GoogleFonts.barlowCondensed(
                          textStyle:
                          Theme.of(context)
                              .textTheme
                              .headline5,
                          fontSize: 10,
                          fontWeight:
                          FontWeight.bold)),
                  //Text('You Needed '+(transaction["amount"] - int.parse(amount1)).toString()+" ₹ to play"),
                ],
              ),
            ),
            actions: <Widget>[
              RaisedButton(
                color: Colors.green,
                child: Text(winnerlist,
                    style:
                    GoogleFonts.barlowCondensed(
                        textStyle:
                        Theme.of(context)
                            .textTheme
                            .headline5,
                        fontSize: 10,
                        fontWeight:
                        FontWeight.bold)),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                          new Winner()));
                },
              ),
              RaisedButton(
                color: Colors.red,
                child: Text(cancel,
                    style:
                    GoogleFonts.barlowCondensed(
                        textStyle:
                        Theme.of(context)
                            .textTheme
                            .headline5,
                        fontSize: 10,
                        fontWeight:
                        FontWeight.bold)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    else {
      transRef
          .child("Bought_tickets")
          .child(uid)
          .child(type)
          .child(ticket_id)
          .once()
          .then((DataSnapshot snapshot1) {
        //  Map<dynamic, dynamic> values= snapshot.value;
        var numbers =
        Number.fromJson(snapshot1.value);
        if (numbers.number == null) {
          numbers.number = 0;
        }
        Fluttertoast.showToast(
            msg: numbers.number.toString());
        if (numbers.number >= 5) {
          Fluttertoast.showToast(msg: limit_ticket);
        }
        if (numbers.number < 5 ||
            numbers.number.toString() == null) {
          if (int.parse(total_amount1) <
              int.parse(amount) ||
              total_amount1 == null) {
            // Fluttertoast.showToast(msg: amount1.toString());
            return showDialog<void>(
              context: context,
              barrierDismissible: true,
              // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(insufficient,
                      style:
                      GoogleFonts.barlowCondensed(
                          textStyle:
                          Theme.of(context)
                              .textTheme
                              .headline5,
                          fontSize: 10,
                          fontWeight:
                          FontWeight.bold)),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(money_msg,
                            style: GoogleFonts
                                .barlowCondensed(
                                textStyle: Theme.of(
                                    context)
                                    .textTheme
                                    .headline5,
                                fontSize: 10,
                                fontWeight:
                                FontWeight
                                    .bold)),
                        Text(
                            remain_1st +
                                (int.parse(amount) -
                                    int.parse(
                                        total_amount1))
                                    .toString() +
                                " ₹ " +
                                remain_2nd,
                            style: GoogleFonts
                                .barlowCondensed(
                                textStyle: Theme.of(
                                    context)
                                    .textTheme
                                    .headline5,
                                fontSize: 10,
                                fontWeight:
                                FontWeight
                                    .bold)),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    RaisedButton(
                      color: Colors.green,
                      child: Text(admoney,
                          style: GoogleFonts
                              .barlowCondensed(
                              textStyle: Theme.of(
                                  context)
                                  .textTheme
                                  .headline5,
                              fontSize: 10,
                              fontWeight:
                              FontWeight
                                  .bold)),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                new Money_Avidence()));
                      },
                    ),
                    RaisedButton(
                      color: Colors.red,
                      child: Text(cancel,
                          style: GoogleFonts
                              .barlowCondensed(
                              textStyle: Theme.of(
                                  context)
                                  .textTheme
                                  .headline5,
                              fontSize: 10,
                              fontWeight:
                              FontWeight
                                  .bold)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
          else {
            Navigator.of(context).push(MaterialPageRoute(
              //  builder: (context) => new Lottery_fill(phone: uid,amt: transaction['Amount'].toString(),price: transaction['price'].toString(),typ:transaction['Name'] ,ticket_type:transaction['ticket_type'].toString() ,numberofsell:transaction['numberofsell'].toString(),wallet_amount: int.parse(amount1),index1: index,)
                builder: (context) => new TicketScreen(
                  phone: uid,
                  amt: amount
                      .toString(),
                  email: email,
                  price: price
                      .toString(),
                  typ: name,
                  ticket_type:type
                      .toString(),
                  numberofsell:
                  numberofshell
                      .toString(),
                  total_amount:
                  int.parse(total_amount1),
                  winning_amount:
                  int.parse(winning_amount1),
                  added_amount:
                  int.parse(added_amount1),
                  ticket_id: ticket_id,
                  deadline: deadline,
                  index1: index,
                )));
          }
        }
      });
    }

  }
  LeaderboardNavigator({int index1,total_amount,added_amount,winning_amount,people, String amt,String typ,phone,price,ticket_type,numberofsell,ticket_id,deadline,email,BuildContext context} ){
    Navigator.of(context).push(MaterialPageRoute(
      //  builder: (context) => new Lottery_fill(phone: uid,amt: transaction['Amount'].toString(),price: transaction['price'].toString(),typ:transaction['Name'] ,ticket_type:transaction['ticket_type'].toString() ,numberofsell:transaction['numberofsell'].toString(),wallet_amount: int.parse(amount1),index1: index,)
        builder: (context) => new Leaderboard(
          phone: phone,
          amt: amt
              .toString(),
          email: email,
          price: price
              .toString(),
          typ: typ,
          ticket_type:ticket_type
              .toString(),
          numberofsell:numberofsell,
          total_amount: total_amount,
          winning_amount:winning_amount,
          added_amount:added_amount,
          ticket_id: ticket_id,
          deadline: deadline,
          index1: index1,
        )));
  }
  userWallet(String uid){
    transRef.child("Wallet").child(uid).once().then((DataSnapshot snapshot) {

      if (snapshot != null) {
        Map<dynamic, dynamic> values = snapshot.value;
        var wallet = Wallet.fromJson(values);
        total_amount1 = wallet.total_amount.toString();
        print("-----------wallet-----------"+total_amount1.toString());
        added_amount1 = wallet.added_amount.toString();
        print("-----------wallet-----------"+added_amount1.toString());
        winning_amount1 = wallet.winning_amount.toString();
        notifyListeners();
      }
    });
  }
  userDetail(String uid){
    transRef.child("Users").child(uid).once().then((DataSnapshot snapshot) {
      if (snapshot != null) {
        Map<dynamic, dynamic> values = snapshot.value;
        num_of_game = values["num_of_game"].toString();
        email = values["email"].toString();
        username = values["name"].toString();
        userprofile = values["profile"].toString();
        user_ac = values["ac no"].toString();
        phone = values["phone"].toString();
        state = values["state"].toString();
        pincode = values["pincode"].toString();

        notifyListeners();
      }
    });
  }

  Future<void> sendNotification(subject,title) async{

    final postUrl = 'https://fcm.googleapis.com/fcm/send';

    String toParams = "/topics/"+'918200127649';

    final data = {
      "notification": {"body":subject, "title":title},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done",
        "sound": 'default',
        "screen": "yourTopicName",
      },
      "to": "${toParams}"};

    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=AAAAbOjOht4:APA91bHc0v_1SaXaEW1efkvqO1J3q40a7ZvyQTPddzlnYAo_3_TU9sln2WCTW_DVw_cMK6rcp2xIadhhhPMeEsmJr5PjpSt10dgOekjpWB2wYQijqWE0vwLrpiQe4etVQVVL7h9fgrtH'

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