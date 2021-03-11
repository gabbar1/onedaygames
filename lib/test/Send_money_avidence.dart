import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oneday/Language/Language.dart';
import 'package:oneday/Model/user.dart';
import 'package:oneday/Model/wallet.dart';
import 'package:oneday/Model/transaction.dart';
import 'package:intl/intl.dart';
import 'package:oneday/wallet/walletPageProvider.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'TransactionProvider.dart';

class Money_Avidence extends StatefulWidget {
  Money_Avidence({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _Money_AvidencePageState createState() => _Money_AvidencePageState();
}

class _Money_AvidencePageState extends State<Money_Avidence> {
  DatabaseReference transRef = FirebaseDatabase.instance.reference();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int totalAmount = 0;
  bool addtransaction = false;
  Razorpay razorpay;
  String uid = '';
  String email;
  String name;
  int added_amount;
  int total_amount;
  int winning_amount;
  int total_amnt;
  int added_amnt;
  bool switch2 = true;
  String add_cash = "Add Cash";
  String current_balance = "Current Balance";
  String input_hint = "Please enter some amount";
  String add = "ADD ";
  String amount, upi, trans_id;
  var transactionsList = List<Transaction>();
  TextEditingController amountController = TextEditingController();

  WebViewController _controller;

  String upiID;
  @override
  void initState() {
    // TODO: implement initState

    this.uid = '';
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    this.uid = user.phoneNumber;
    transRef = FirebaseDatabase.instance.reference();
    Provider.of<TransactionProvider>(context, listen: false).getTransaction();
    Provider.of<WalletPageProvider>(context, listen: false).transactionDetails();
    var dbRef = FirebaseDatabase.instance.reference();
    dbRef.child("Users").child(uid).once().then((DataSnapshot snapshot) {
      if (snapshot != null) {
        Map<dynamic, dynamic> values = snapshot.value;
        var user = User1.fromJson(values);
        if (this.mounted) {
          setState(() {
            email = user.email;
            name = user.name;
          });
        }
      }
    });
    dbRef.child("Wallet").child(uid).once().then((DataSnapshot snapshot) {
      if (snapshot != null) {
        Map<dynamic, dynamic> values = snapshot.value;
        var wallet = Wallet.fromJson(values);

        if (this.mounted) {
          setState(() {
            total_amount = wallet.total_amount;
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Random random = new Random();
    int randomNumber = random.nextInt(8);
    Provider.of<TransactionProvider>(context, listen: false).getTransaction();
    Provider.of<WalletPageProvider>(context, listen: false).transactionDetails();
    var trans = Provider.of<TransactionProvider>(context, listen: false);
    var upi = Provider.of<WalletPageProvider>(context, listen: false);
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
        appBar: AppBar(
          key: scaffoldKey,
          title: Text(add_cash,
              style: GoogleFonts.barlowCondensed(
                  textStyle: Theme.of(context).textTheme.headline5,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ),
        body: Column(
          children: [
            Container(
                height: 60,
                color: Colors.white,
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    CircleAvatar(
                        radius: 20,
                        child: Image.asset("assets/icons/wallet.png")),
                    SizedBox(
                      width: 10,
                    ),
                    Text(current_balance,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    Spacer(),
                    Text("₹ " + total_amount.toString(),
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 40,
                    )
                  ],
                )),
            Container(
                height: MediaQuery.of(context).size.height / 8,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                child: InkWell(
                  child: Image.asset("assets/images/googlepay.png"),
                  onTap: () {
                    return showDialog<void>(
                      context: context,
                      barrierDismissible: true, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Add Money'),
                          content: SingleChildScrollView(
                              child: Column(
                            children: [
                              TextFormField(
                                decoration: const InputDecoration(
                                    hintText: "Enter Amount"),
                                onChanged: (val) {
                                  this.amount = val;
                                },
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                    hintText: "Enter UPI ID"),
                                onChanged: (val) {
                                  this.upiID = val;
                                },
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                    hintText: "Transaction ID"),
                                onChanged: (val) {
                                  this.trans_id = val;
                                },
                              ),
                              RaisedButton(
                                color: Colors.green,
                                child: Text("SEND"),
                                onPressed: () {
                                  if(trans_id == null || upiID == null || amount== null){
                                    final snackBar = SnackBar(
                                        content: Text(
                                            "Fill all details.."));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else{

                                    trans.setTransaction(
                                        context: context,
                                        uid: uid,
                                        upi: upiID,
                                        amount: amount,
                                        input: trans_id,
                                        transID: trans.tranID,
                                        name: name,
                                        email: email);
                                    Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        // return object of type Dialog
                                        return AlertDialog(
                                          title: new Text(
                                            "G Gate",
                                            style: TextStyle(fontWeight: FontWeight.w700),
                                          ),
                                          content:
                                          new Text("Thank you for request your money will be added within 3 hours", style: TextStyle(fontWeight: FontWeight.w500)),
                                          actions: <Widget>[
                                            // usually buttons at the bottom of the dialog
                                            new FlatButton(
                                              child: new Text(
                                                "Ok",
                                                style: TextStyle(fontWeight: FontWeight.w700),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }

                                  /*if(amount == null && upi == null && trans_id == null){
                                        final snackBar = SnackBar(
                                            content: Text(
                                                "Fill all details.."));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                      else{
                                        transRef
                                            .child("User_Transaction")
                                            .once()
                                            .then((DataSnapshot snapshot) {
                                          Map<dynamic, dynamic> map =
                                              snapshot.value;
                                          map.forEach((key, value) {
                                            //  print(key.toString());
                                            transRef
                                                .child("User_Transaction")
                                                .child(key.toString())
                                                .once()
                                                .then((DataSnapshot child) {
                                              Map<dynamic, dynamic> childMap =
                                                  child.value;
                                              childMap.forEach((keys, values) {
                                                //  print(values["transaction_id"]);
                                                if (values["transaction_id"] ==
                                                    trans_id) {
                                                  // print(values["transaction_id"]);
                                                  print(trans_id);
                                                  final snackBar = SnackBar(
                                                      content: Text(
                                                          "This transaction ID already Used.."));
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);

                                                }else if (values["transaction_id"] !=
                                                    trans_id)
                                              });
                                            });
                                          });
                                        });
                                      }*/
                                },
                              )
                            ],
                          )),
                        );
                      },
                    );
                  },
                )),
            Column(
                children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                Center(child: Container(
                  width: MediaQuery.of(context).size.width/2 -10,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      border: Border.all(color: Colors.black)
                  ),
                  child: Center(
                    child: Text("Name"),
                  ),
                ),),
                Container(
                  decoration: BoxDecoration(
                     color: Colors.amberAccent,
                      border: Border.all(color: Colors.black)
                  ),
                  width: MediaQuery.of(context).size.width/2 -10,
                  height: 30,

                  child: Center(
                    child: Text("UPI ID"),
                  ),
                )
              ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                Container(
                  width: MediaQuery.of(context).size.width/2-10,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      border: Border.all(color: Colors.black)
                  ),
                  child: Center(
                    child: Text(upi.name == null ? "Please wait" : upi.name),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      border: Border.all(color: Colors.black)
                  ),
                  width: MediaQuery.of(context).size.width/2-10,
                  height: 30,

                  child: Center(
                    child: Text(upi.upiID == null ? "Please wait" : upi.upiID),
                  ),
                )
              ]),
            ]),
            Expanded(
              child: WebView(
                initialUrl: 'about:blank',
                onWebViewCreated: (WebViewController webViewController) {
                  _controller = webViewController;
                  _loadHtmlFromAssets();
                },
              ),
            )
          ],
        ));
  }

  _loadHtmlFromAssets() async {
    var language = Provider.of<Language>(context, listen: false);
    String fileText;
    if (language.status2) {
      fileText =
          await rootBundle.loadString('assets/files/addMoneyEnglish.html');
    } else {
      fileText = await rootBundle.loadString('assets/files/addMoneyHindi.html');
    }

    _controller.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
