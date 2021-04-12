import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oneday/Language/Language.dart';
import 'package:oneday/Model/number.dart';
import 'package:oneday/Model/user.dart';
import 'package:oneday/Winner/Winners.dart';
import 'package:oneday/dashBoard/API.dart';
import 'package:oneday/dashBoard/leaderBoardProvider.dart';
import 'package:oneday/screen/payment/load_payment.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:oneday/Model/winner_price.dart';

import '../ticket/NumericKeyboard.dart';
import 'Send_money_avidence.dart';

class Leaderboard extends StatefulWidget {
  Leaderboard(
      {this.ticket_deadline,
      this.phone,
      this.price,
      this.amt,
      this.typ,
      this.ticket_type,
      this.numberofsell,
      this.total_amount,
      this.winning_amount,
      this.added_amount,
      this.ticket_id,
      this.deadline,
      this.email,
      this.people,
      this.index1});
  final int index1, total_amount, added_amount, winning_amount, people;
  String amt;
  String typ,
      phone,
      price,
      ticket_type,
      numberofsell,
      ticket_id,
      deadline,
      email;
  var ticket_deadline;
  @override
  __LeaderboardState createState() => __LeaderboardState();
}

class __LeaderboardState extends State<Leaderboard> {
  DatabaseReference transRef = FirebaseDatabase.instance.reference();
  var winners = new List<Winner_price>();
  String price, num_winner;
  String daily = "Daily";
  String monthly = "Monthly";
  String weekly = "Weekly";
  String special = "Special";
  String language;
  String closed = "Closed";
  String ticket = "Ticket Closed";
  String announcedate = "Announcement date is ";
  String winnerlist = "Go to Winner list";
  String cancel = "Cancel";
  String limit_ticket = "Sorry You can not buy more than 5 tickets";
  String insufficient = ' Insufficient Money ';
  String money_msg = "You have Insufficient Amount to buy this Ticket";
  String remain_1st = "You Needed  ";
  String remain_2nd = " to play";
  String admoney = 'Add Money';
  bool status2 = true;
  String info = "Info";
  String balance = "Your balance";
  String you_won = "You Won";
  String no_ticket = "Number of tickets";

  void afterBuildFunction(BuildContext context) {
    var leader = Provider.of<LeaderBoardProvider>(context, listen: false);
    leader.getLeaderBoard(
        ticket_type: widget.ticket_type, ticket_id: widget.ticket_id);
  }

  @override
  void initState() {
    // TODO: implement initState
    transRef
        .child("Lottery")
        .child(widget.ticket_type)
        .child(widget.ticket_id)
        .child("winner_count")
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot != null) {
        setState(() {
          Iterable list = snapshot.value;
          winners = list.map((model) => Winner_price.fromJson(model)).toList();
        });
      }
    });
    Provider.of<Language>(context, listen: false).getLanguage(widget.phone);
    transRef = FirebaseDatabase.instance.reference();
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => afterBuildFunction(context));
  }

  @override
  Widget build(BuildContext context) {
    var leader = Provider.of<LeaderBoardProvider>(context, listen: true);
    var language = Provider.of<Language>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(language.Contest, style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline4,) ,),
      ),
      body: Column(
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(language.winningPrice,style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize: 23, fontWeight: FontWeight.bold)),
                  Spacer(),
                  Text(
                    language.entry
                      ,style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline6,fontWeight: FontWeight.bold,fontSize: 23),
                  ),
                  SizedBox(
                    width: 20,
                  )
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(language.rupeesymbol+widget.price, style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:30, fontWeight: FontWeight.bold, color: Colors.amber)),
                  Spacer(),
                  FlatButton(
                      color: Colors.green,
                      onPressed: () {
                        // Fluttertoast.showToast(msg: ticket_deadline);
                        if (widget.ticket_deadline <= 0) {
                          return showDialog<void>(
                            context: context,
                            barrierDismissible: true, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(language.ticket),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text(
                                          language.announcedate +
                                              widget.deadline,
                                          style: GoogleFonts.barlowCondensed(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .headline5,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold)),
                                      //Text('You Needed '+(transaction["amount"] - int.parse(amount1)).toString()+" ₹ to play"),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  RaisedButton(
                                    color: Colors.green,
                                    child: Text(language.winnerlist,
                                        style: GoogleFonts.barlowCondensed(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold)),
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
                                    child: Text(language.cancel,
                                        style: GoogleFonts.barlowCondensed(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          transRef
                              .child("Bought_tickets")
                              .child(widget.phone)
                              .child(widget.ticket_type)
                              .child(widget.ticket_id)
                              .once()
                              .then((DataSnapshot snapshot) {
                            //  Map<dynamic, dynamic> values= snapshot.value;
                            var numbers = Number.fromJson(snapshot.value);
                            if (numbers.number == null) {
                              numbers.number = 0;
                            }
                            //   Fluttertoast.showToast(msg: numbers.number.toString());
                            if (numbers.number >= 5) {
                              Fluttertoast.showToast(msg: money_msg);
                            }
                            if (numbers.number < 5 ||
                                numbers.number.toString() == null) {
                              if (widget.total_amount < int.parse(widget.amt) ||
                                  widget.total_amount == null) {
                                //  Fluttertoast.showToast(msg: amount1.toString());
                                return showDialog<void>(
                                  context: context,
                                  barrierDismissible:
                                      true, // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(insufficient,
                                          style: GoogleFonts.barlowCondensed(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .headline5,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold)),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            Text(money_msg,
                                                style:
                                                    GoogleFonts.barlowCondensed(
                                                        textStyle:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .headline5,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                            Text(
                                                remain_1st +
                                                    (int.parse(widget.amt) -
                                                            widget.total_amount)
                                                        .toString() +
                                                    " ₹ " +
                                                    remain_2nd,
                                                style:
                                                    GoogleFonts.barlowCondensed(
                                                        textStyle:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .headline5,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        RaisedButton(
                                          color: Colors.green,
                                          child: Text(admoney,
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
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (c) =>
                                                        Money_Avidence()));
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
                              } else {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    //  builder: (context) => new Lottery_fill(phone: uid,amt: transaction['Amount'].toString(),price: transaction['price'].toString(),typ:transaction['Name'] ,ticket_type:transaction['ticket_type'].toString() ,numberofsell:transaction['numberofsell'].toString(),wallet_amount: int.parse(amount1),index1: index,)
                                    builder: (context) => new TicketScreen(
                                      phone: widget.phone,
                                      amt: widget.amt,
                                      email: widget.email,
                                      price: widget.price,
                                      typ: widget.typ,
                                      ticket_type: widget.ticket_type,
                                      numberofsell: widget.numberofsell,
                                      total_amount: widget.total_amount,
                                      winning_amount: widget.winning_amount,
                                      added_amount: widget.added_amount,
                                      ticket_id: widget.ticket_id,
                                      deadline: widget.deadline,
                                      index1: widget.index1,
                                    ),
                                  ),
                                );
                              }
                            }
                          });
                        }
                      },
                      child: (Text(language.rupeesymbol+
                        widget.amt,
                          style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline4,fontSize:20, fontWeight: FontWeight.bold),
                      ))),
                  SizedBox(
                    width: 10,

                  ),

                  ],

              ),
              SizedBox(height: 10,),
              Container(
                child: StepProgressIndicator(
                  totalSteps: 1,
                  currentStep: 1,
                  size: 5,
                  padding: 0,
                  selectedColor: Colors.red,
                  unselectedColor: Colors.red,
                  roundedEdges: Radius.circular(10),
                  selectedGradientColor: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.yellowAccent, Colors.deepOrange],
                  ),
                  unselectedGradientColor: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, Colors.white],
                  ),

                ),

                width: 395,
              ),
              SizedBox(height: 15),
              Divider(
                thickness: 2,color: Colors.black54
              ),

              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: leader.leaderBoardList.length,
                  itemBuilder: (_, index) {
                    if (index == 0) {
                      return Container();
                    } else {
                      return Card(
                        margin: EdgeInsets.all(10),
                          elevation: 24,
                          shadowColor: Colors.lightBlue,
                          //color: Colors.green,
                          child: Column(
                        children: [
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              SizedBox(width: 10,),
                              Text(" #" + index.toString() + " "+language.price_money,style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline4,fontSize:20, fontWeight: FontWeight.bold, color: Colors.amber),),
                              Spacer(),
                              Text(leader.leaderBoardList[index].winner_price.toString(),style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:17, fontWeight: FontWeight.bold)),
                              SizedBox(width: 10,)
                            ],
                          ),
                          Divider(color: Colors.black54,),
                          Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Text(language.no_of_winners +
                                  leader.leaderBoardList[index].no_of_winners
                                      .toString(),style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline4,fontSize:15, fontWeight: FontWeight.bold, color: Colors.black),),
                            ],
                          ),
                          SizedBox(height: 10,)
                        ],
                      ));
                    }
                  }),
              Divider(
                thickness: 2, color: Colors.black54,
              )
            ],
          ))
        ],
      ),
    );
  }
}
