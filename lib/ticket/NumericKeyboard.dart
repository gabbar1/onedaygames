import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/smtp_server/hostinger.dart';
import 'package:oneday/Model/number.dart';
import 'package:oneday/Model/user.dart';
import 'package:oneday/dashBoard/homeNavigator.dart';
import 'package:oneday/helper/appUtils.dart';
import 'package:oneday/main.dart';
import 'package:oneday/dashBoard/dashboard.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TicketScreen extends StatefulWidget {
  TicketScreen(
      {this.phone,
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
      this.index1});
  final int index1, total_amount, added_amount, winning_amount;
  String amt;
  String typ,
      phone,
      price,
      ticket_type,
      numberofsell,
      ticket_id,
      deadline,
      email;

  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  //DatabaseReference transRef = FirebaseDatabase.instance.reference();
  DatabaseReference transRef = FirebaseDatabase.instance.reference();
  String dropdownValue = 'salary';
  String uid = "";
  String name;
  String phone;
  String add;
  String lead;
  String peakup_date;
  String peakup_time;
  String bank;
  String source;
  String ticket;
  int number;
  int num_of_game;
  int amnt;
  String text = '';
  bool status2 = true;
  String strPin;
  String value = "Enter value";
  String ticket_num = "Enter valid Ticket Number";
  String confirm = ' Please Confirm ';
  String ticket_amount = 'You Ticket amount is ';
  String buy_ticket = 'Buy Ticket';
  String ticket_number = "Enter valid Ticket Number";
  String cancel = "Cancel";
  String ticket_amount1 = "Your Ticket Amount is ";
  String luck_number = "Enter Your Lucky Number";
  String buy = "Buy & Win";
  List<String> currentpin = ["", "", "", ""];
  TextEditingController pinOneController = TextEditingController();
  TextEditingController pinTwoController = TextEditingController();
  TextEditingController pinThreeController = TextEditingController();
  TextEditingController pinFourController = TextEditingController();
  int i = 0;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<Message> messages = [];
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

  sendMail() async {
    i = 1;
    String username = "tickets@onedaygames.in";
    String password = "Onedaygames@2020";
    var to;
    transRef
        .child("Users")
        .child(widget.phone)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot != null) {
        Map<dynamic, dynamic> values = snapshot.value;
        var user = User1.fromJson(values);
        setState(() {
          to = user.email.toString();
        });
      }
    });
    final smtpServer = hostinger(username, password);
    print("------Email------------" + widget.email.toString());
    final message = Message()
      ..from = Address(username)
      ..recipients.add(widget.email)
      ..subject =
          "You Bought ${widget.ticket_type} ticket on : ${DateTime.now()}"
      ..html =
          "<h3>THANK YOU FOR CHOOSING ONEDAY \n\n Your Ticket number is ${selectedchar + strPin} \n\n Result will be announce at ${widget.deadline}</h3>";

    try {
      final sendReport = await send(message, smtpServer);
    } on MailerException catch (e) {
      Fluttertoast.showToast(msg: e.message);
    }
  }

  @override
  void initState() {
    this.uid = '';
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    this.uid = user.phoneNumber;

    // TODO: implement initState
    transRef
        .child("Bought_tickets")
        .child(widget.phone)
        .child(widget.ticket_type)
        .child(widget.ticket_id)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      var numbers = Number.fromJson(values);
      if (numbers.number == null) {
        setState(() {
          this.number = 0;
        });
        //num_of_time = 0.toString();
      } else {
        this.number = numbers.number;
        //  num_of_time = numbers.number.toString();
      }
    });

    transRef
        .child("Users")
        .child(widget.phone)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      var numbers = User1.fromJson(values);
      if (numbers.num_of_game == null) {
        setState(() {
          this.num_of_game = 0;
        });
        //num_of_time = 0.toString();
      } else {
        this.num_of_game = int.parse(numbers.num_of_game);
        //  num_of_time = numbers.number.toString();
      }
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];
        setState(() {
          /*  messages.add(Message(
              title: notification['title'], body: notification['body']));*/
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        final notification = message['data'];
        setState(() {
          /* messages.add(Message(
            title: '${notification['title']}',
            body: '${notification['body']}',
          ));*/
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    super.initState();
  }

  var outlineInpurBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(color: Colors.transparent),
  );
  int pinIndex = 0;
  cutAmount() async {
    int amount = (await FirebaseDatabase.instance
            .reference()
            .child("Wallet")
            .child(widget.phone)
            .child("amount")
            .once())
        .value;
    if (amount != null) {
      amnt = amount - int.parse(widget.amt);
    } else {
      amnt = 0;
    }
  }

  getAmount(int a) async {
    int amount = (await FirebaseDatabase.instance
            .reference()
            .child("Wallet")
            .child(widget.phone)
            .child("amount")
            .once())
        .value;
    if (amount != null) {
      amnt = amount + a;
    } else {
      amnt = a;
    }
    print('HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH' + name);
  }

  final DBRef = FirebaseDatabase.instance.reference();
  List<String> luckyChar = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']; // Option 2
  String selectedchar;
  @override
  Widget build(BuildContext context) {
    print("---------------phone-------------" + widget.phone);
    return Scaffold(
        backgroundColor: Colors.amber,
        appBar: AppBar(
          title: Text(buy,
              style: GoogleFonts.barlowCondensed(
                textStyle: Theme.of(context).textTheme.headline5,
              )),
          backgroundColor: Colors.amber,
        ),
        body: Column(
          children: [
            Expanded(
                child: Container(
              alignment: Alignment(0, 0.5),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildSecurityText(),
                  SizedBox(
                    height: 10.0,
                  ),
                  buildPinRow(),
                ],
              ),
            )),
            buildNumberPad(),
          ],
        ));
  }

  buildNumberPad() {
    return Expanded(
        child: Container(
      color: Colors.grey,
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                KeyboardNumber(
                    n: 1,
                    onPressed: () {
                      pinIndexSetup("1");
                    }),
                KeyboardNumber(
                    n: 2,
                    onPressed: () {
                      pinIndexSetup("2");
                    }),
                KeyboardNumber(
                    n: 3,
                    onPressed: () {
                      pinIndexSetup("3");
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                KeyboardNumber(
                    n: 4,
                    onPressed: () {
                      pinIndexSetup("4");
                    }),
                KeyboardNumber(
                    n: 5,
                    onPressed: () {
                      pinIndexSetup("5");
                    }),
                KeyboardNumber(
                    n: 6,
                    onPressed: () {
                      pinIndexSetup("6");
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                KeyboardNumber(
                    n: 7,
                    onPressed: () {
                      pinIndexSetup("7");
                    }),
                KeyboardNumber(
                    n: 8,
                    onPressed: () {
                      pinIndexSetup("8");
                    }),
                KeyboardNumber(
                    n: 9,
                    onPressed: () {
                      pinIndexSetup("9");
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 60.0,
                  child: MaterialButton(
                      onPressed: () {
                        if (selectedchar == null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
                                title: new Text(
                                  "OneDay",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                content: new Text(
                                    "Please select your lucky character",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500)),
                                actions: <Widget>[
                                  // usually buttons at the bottom of the dialog
                                  new FlatButton(
                                    child: new Text(
                                      "Ok",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (strPin == null || strPin.length < 4) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
                                title: new Text(
                                  "OneDay",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                content: new Text(ticket_num,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500)),
                                actions: <Widget>[
                                  // usually buttons at the bottom of the dialog
                                  new FlatButton(
                                    child: new Text(
                                      "Ok",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (strPin.length == 4) {
                          return showDialog<void>(
                              context: context,
                              barrierDismissible: true, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(confirm,
                                      style: GoogleFonts.barlowCondensed(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .headline5,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(ticket_amount + widget.amt + " ₹",
                                            style: GoogleFonts.barlowCondensed(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .headline5,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),

                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    RaisedButton(
                                        color: Colors.green,
                                        child: Text(buy_ticket,
                                            style: GoogleFonts.barlowCondensed(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .headline5,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        onPressed: () async {
                                          cutAmount();
                                          var now = new DateTime.now();
                                          DBRef.child("Sold_tickets")
                                              .child(widget.phone)
                                              .push()
                                              .set({
                                            'name': widget.ticket_type,
                                            'phone': widget.phone,
                                            'price': widget.price,
                                            'amount': widget.amt,
                                            'ticket_id': widget.ticket_id,
                                            'ticket_no': selectedchar + strPin,
                                            'resultdate': widget.deadline,
                                            'time': DateFormat(
                                                    'EEEE, d MMM, yyyy,h:mm:ss a')
                                                .format(now),
                                            'deadline': widget.deadline
                                          });
                                          DBRef.child("Ready_for_Result")
                                              .child(widget.ticket_type)
                                              .child(widget.ticket_id)
                                              .child(widget.phone)
                                              .child((number + 1).toString())
                                              .set({
                                            'name': widget.typ,
                                            'phone': widget.phone,
                                            'price': widget.price,
                                            'amount': widget.amt,
                                            'ticket_id': widget.ticket_id,
                                            'ticket_no': selectedchar + strPin,
                                            'time': DateFormat(
                                                    'EEEE, d MMM, yyyy,h:mm:ss a')
                                                .format(now),
                                            'deadline': widget.deadline
                                          });
                                          DBRef.child("Lottery")
                                              .child(widget.ticket_type)
                                              .child(widget.ticket_id)
                                              .update({
                                            'numberofsell':
                                                int.parse(widget.numberofsell) +
                                                    1
                                          });
                                          if(widget.added_amount< int.parse(widget.amt) ){
                                             int remain_amount = int.parse(widget.amt)- widget.added_amount;
                                             DBRef.child("Wallet")
                                                 .child(widget.phone)
                                                 .update({
                                               'added_amount': 0,
                                               'total_amount': widget.total_amount - int.parse(widget.amt),
                                               'winning_amount': widget.winning_amount - remain_amount,
                                               'time': DateFormat(
                                                   'EEEE, d MMM, yyyy,h:mm:ss a')
                                                   .format(now),
                                             });

                                          } else
                                          if (widget.added_amount == 0 ||
                                              widget.added_amount == null) {
                                            DBRef.child("Wallet")
                                                .child(widget.phone)
                                                .update({
                                              'winning_amount':
                                                  widget.winning_amount -
                                                      int.parse(widget.amt),
                                              'total_amount':
                                                  widget.total_amount -
                                                      int.parse(widget.amt),
                                              'time': DateFormat(
                                                      'EEEE, d MMM, yyyy,h:mm:ss a')
                                                  .format(now),
                                            });
                                          } else {
                                            DBRef.child("Wallet")
                                                .child(widget.phone)
                                                .update({
                                              'added_amount':
                                                  widget.added_amount -
                                                      int.parse(widget.amt),
                                              'total_amount':
                                                  widget.total_amount -
                                                      int.parse(widget.amt),
                                              'time': DateFormat(
                                                      'EEEE, d MMM, yyyy,h:mm:ss a')
                                                  .format(now),
                                            });
                                          }
                                          transRef
                                              .child('User_Transaction')
                                              .child(widget.phone)
                                              .push()
                                              .set({
                                            'amount': widget.amt,
                                            'status': "T",
                                            'time': DateFormat(
                                                    'EEEE, d MMM, yyyy,h:mm:ss a')
                                                .format(now),
                                          });
                                          Fluttertoast.showToast(
                                              msg: number.toString());
                                          transRef
                                              .child("Bought_tickets")
                                              .child(widget.phone)
                                              .child(widget.ticket_type)
                                              .child(widget.ticket_id)
                                              .update({'number': number + 1});
                                          transRef
                                              .child("Users")
                                              .child(widget.phone)
                                              .update({
                                            'num_of_game': num_of_game + 1
                                          });
                                          sendMail();
                                          Navigator.pop(context);
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              // return object of type Dialog
                                              return AlertDialog(
                                                title: new Text(
                                                  "OneDay",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                content: new Text(
                                                    "Thank you for buying ticket",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                actions: <Widget>[
                                                  // usually buttons at the bottom of the dialog
                                                  new FlatButton(
                                                    child: new Text(
                                                      "Ok",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                    onPressed: () {
                                                      firebaseMessaging
                                                          .subscribeToTopic(
                                                              widget.ticket_id);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      /*Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
                                                          HomeNavigator()), (Route<dynamic> route) => true);*/
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }),
                                    RaisedButton(
                                      color: Colors.red,
                                      child: Text(cancel,
                                          style: GoogleFonts.barlowCondensed(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .headline5,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        }
                      },
                      child: Text(
                        "Go",
                          style: GoogleFonts.barlowCondensed(
                              textStyle:
                              Theme.of(context).textTheme.headline5,
                              fontSize:21,
                              fontWeight: FontWeight.bold,color: Colors.white)
                        ,
                      )),
                ),
                KeyboardNumber(
                    n: 0,
                    onPressed: () {
                      pinIndexSetup("0");
                    }),
                Container(
                  width: 60.0,
                  child: MaterialButton(
                    onPressed: () {
                      clearPin();
                    },
                    child: Icon(
                      Icons.backspace_outlined,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }

  clearPin() {
    if (pinIndex == 0) {
      pinIndex = 0;
    } else if (pinIndex == 4) {
      setPin(pinIndex, "");
      currentpin[pinIndex - 1] = "";
      pinIndex--;
    } else if (pinIndex > 4) {
      pinIndex--;
      setPin(pinIndex, "");
      currentpin[pinIndex - 1] = "";
      pinIndex = 0;
      currentpin.forEach((element) {
        strPin.replaceAll(element, "");
      });
      print("remove-------" + strPin);
    } else {
      setPin(pinIndex, "");
      currentpin[pinIndex - 1] = "";
      pinIndex--;
    }
  }

  pinIndexSetup(String text) {
    if (pinIndex == 0)
      pinIndex = 1;
    else if (pinIndex < 4) pinIndex++;
    setPin(pinIndex, text);
    currentpin[pinIndex - 1] = text;
    strPin = "";
    currentpin.forEach((e) {
      strPin += e;
    });
    //if(pinIndex == 4)
    print(strPin);
  }

  setPin(int n, String text) {
    switch (n) {
      case 1:
        pinOneController.text = text;
        break;
      case 2:
        pinTwoController.text = text;
        break;
      case 3:
        pinThreeController.text = text;
        break;
      case 4:
        pinFourController.text = text;
        break;
    }
  }

  buildPinRow() {
    return Column(
      children: [

        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          width: 150,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5)),
          child: DropdownButton(
            underline: SizedBox(),
            isExpanded: true,
            hint: Text('Select'),
            // Not necessary for Option 1
            value: selectedchar,
            onChanged: (newValue) {
              setState(() {
                selectedchar = newValue;
              });
            },
            items: luckyChar.map((location) {
              return DropdownMenuItem(
                child: new Text(location),
                value: location,
              );
            }).toList(),
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Center(
            child: Text(
              luck_number,
              style: GoogleFonts.barlowCondensed(
                  textStyle: Theme.of(context).textTheme.headline5,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            )),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            PINNumber(
              outlineInputBorder: outlineInpurBorder,
              textEditingController: pinOneController,
            ),
            PINNumber(
              outlineInputBorder: outlineInpurBorder,
              textEditingController: pinTwoController,
            ),
            PINNumber(
              outlineInputBorder: outlineInpurBorder,
              textEditingController: pinThreeController,
            ),
            PINNumber(
              outlineInputBorder: outlineInpurBorder,
              textEditingController: pinFourController,
            ),
          ],
        )
      ],
    );
  }

  buildSecurityText() {
    return Column(
      children: [
        Center(
          child: Text(ticket_amount1 + widget.amt + " ₹",
              style: GoogleFonts.barlowCondensed(
                  textStyle: Theme.of(context).textTheme.headline4,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
        Center(
            child: Text(
              "Select Luck character",
              style: GoogleFonts.barlowCondensed(
                  textStyle: Theme.of(context).textTheme.headline5,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ))
      ],
    );
  }
}

class PINNumber extends StatelessWidget {
  final TextEditingController textEditingController;
  final OutlineInputBorder outlineInputBorder;
  PINNumber({this.textEditingController, this.outlineInputBorder});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        width: 50.0,
        child: TextField(
          controller: textEditingController,
          enabled: false,
          obscureText: false,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(16.0),
            border: outlineInputBorder,
            filled: true,
            fillColor: Colors.white30,
          ),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 21.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class KeyboardNumber extends StatelessWidget {
  final int n;
  final Function() onPressed;
  KeyboardNumber({this.n, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(
          //shape: BoxShape.circle,
          // color: Colors.purpleAccent.withOpacity(0.1),
          ),
      alignment: Alignment.center,
      child: MaterialButton(
        padding: EdgeInsets.all(8.0),
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60.0),
        ),
        height: 90.0,
        child: Text(
          "$n",
          textAlign: TextAlign.center,
            style: GoogleFonts.barlowCondensed(
                textStyle:
                Theme.of(context).textTheme.headline5,
                fontSize: 24 * MediaQuery.of(context).textScaleFactor,
                fontWeight: FontWeight.bold,color: Colors.white)

        ),
      ),
    );
  }
}
