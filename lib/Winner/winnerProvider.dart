import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:oneday/Model/lottery.dart';
import 'package:oneday/Model/number.dart';
import 'package:oneday/Model/wallet.dart';
import 'package:oneday/Winner/Winners.dart';
import 'package:oneday/screen/payment/load_payment.dart';
import 'package:provider/provider.dart';

import '../test/Leaderboard.dart';
import '../ticket/NumericKeyboard.dart';

class WinnerProvider extends ChangeNotifier{
  var ticket_deadline;
  var ticket_deadline1;
  String updated_deadline ;
  DatabaseReference transRef = FirebaseDatabase.instance.reference();
  var daily_ticket = new List<Lottery>();
  var weekly_ticket = new List<Lottery>();
  var monthly_ticket = new List<Lottery>();
  var special_ticket = new List<Lottery>();
  var name;
  var total_amount1,added_amount1,winning_amount1;
  var user1;
  var num_of_game;
  String email;
  String username;
  String userprofile;
  String user_ac;
  String phone,state,pincode;
  getdailylottery( ) {
    transRef.child('Lottery').child("daily").limitToFirst(10).once().then((DataSnapshot snapshot) {
      daily_ticket.clear();
      var values= snapshot.value;
      print("-----------------------"+values.toString());
      values.forEach((key, values) {
        Lottery lottery = new Lottery(
            key: key,
            ticket_type: values["ticket_type"],
            ticket_id: values["ticket_id"],
            amount:  values["amount"].toString(),
            announced:   values["announced"],
            deadline:   values["deadline"],
            name:   values["name"],
            numberofshell :   values["numberofsell"],
            people :   values["people"],
            price :   values["price"],
            result_date :   values["result_date"],
            start_date :   values["start_date"],
            status :   values["status"],
            ticket_key :   values["ticket_key"].toString(),
            type: values["type"]

        );
        daily_ticket.add(lottery);
      });
    });

  }
  getweeklylottery() {
    transRef.child('Lottery').child("weekly").orderByPriority().once().then((DataSnapshot snapshot) {
      weekly_ticket.clear();
      var values= snapshot.value;
      values.forEach((key, values) {
        Lottery lottery = new Lottery(
            key: key,
            ticket_type: values["ticket_type"],
            ticket_id: values["ticket_id"],
            amount:  values["amount"].toString(),
            announced:   values["announced"],
            deadline:   values["deadline"],
            name:   values["name"],
            numberofshell :   values["numberofsell"],
            people :   values["people"],
            price :   values["price"],
            result_date :   values["result_date"],
            start_date :   values["start_date"],
            status :   values["status"],
            ticket_key :   values["ticket_key"].toString(),
            type: values["type"]

        );
        weekly_ticket.add(lottery);
      });

    });


  }
  getmonthlylottery() {
    transRef.child('Lottery').child("monthly").once().then((DataSnapshot snapshot) {
      monthly_ticket.clear();
      var values= snapshot.value;
      values.forEach((key, values) {
        Lottery lottery = new Lottery(
            key: key,
            ticket_type: values["ticket_type"],
            ticket_id: values["ticket_id"],
            amount:  values["amount"].toString(),
            announced:   values["announced"],
            deadline:   values["deadline"],
            name:   values["name"],
            numberofshell :   values["numberofsell"],
            people :   values["people"],
            price :   values["price"],
            result_date :   values["result_date"],
            start_date :   values["start_date"],
            status :   values["status"],
            ticket_key :   values["ticket_key"].toString(),
            type: values["type"]

        );
        monthly_ticket.add(lottery);
      });
    });


  }
  getspaciallottery( ) {
    transRef.child('Lottery').child("special").once().then((DataSnapshot snapshot) {
      special_ticket.clear();
      var values= snapshot.value;
      values.forEach((key, values) {
        Lottery lottery = new Lottery(
            key: key,
            ticket_type: values["ticket_type"],
            ticket_id: values["ticket_id"],
            amount:  values["amount"].toString(),
            announced:   values["announced"],
            deadline:   values["deadline"],
            name:   values["name"],
            numberofshell :   values["numberofsell"],
            people :   values["people"],
            price :   values["price"],
            result_date :   values["result_date"],
            start_date :   values["start_date"],
            status :   values["status"],
            ticket_key :   values["ticket_key"].toString(),
            type: values["type"]

        );
        special_ticket.add(lottery);
      });

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
                                new AddMoney()));
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
          } else {
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
        added_amount1 = wallet.added_amount.toString();
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
}