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
import 'package:oneday/helper/constant.dart';
import 'package:oneday/screen/payment/load_payment.dart';
import '../test/Leaderboard.dart';
import '../ticket/NumericKeyboard.dart';

class WinnerProvider extends ChangeNotifier{
  var ticket_deadline;
  var ticket_deadline1;
  DatabaseReference transRef = FirebaseDatabase.instance.reference();
  var daily_ticket =  <Lottery>[];
  var weekly_ticket = <Lottery>[];
  var monthly_ticket =  <Lottery>[];
  var special_ticket =  <Lottery>[];




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
            daily_ticket.add(sold);
            daily_ticket.sort((a,b) => DateFormat('yyyy-MM-dd').parse(b.start_date).compareTo(DateFormat('yyyy-MM-dd').parse(a.start_date)));
            notifyListeners();

        });
      }
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


}