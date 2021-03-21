import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oneday/Language/Language.dart';
import 'package:oneday/Model/user.dart';
import 'package:oneday/Model/wallet.dart';
import 'package:oneday/helper/appUtils.dart';
import 'package:oneday/wallet/walletPageProvider.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:oneday/test/senMoneyAvidenceDialogue.dart';


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

  String uid = '';
  String email;
  String name;
  int added_amount;
  int total_amount;
  int winning_amount;
  int total_amnt;
  int added_amnt;

  String amount, upi, trans_id;
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
    Provider.of<WalletPageProvider>(context, listen: false).transactionDetails();
    Provider.of<Language>(context, listen: false).getLanguage(uid);
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

    Provider.of<WalletPageProvider>(context, listen: false).transactionDetails();
    var upi = Provider.of<WalletPageProvider>(context, listen: false);
    var language = Provider.of<Language>(context, listen: false);
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
        appBar: AppBar(
          key: scaffoldKey,
          title: Text(language.add_cash,
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
                    Text(language.current_balance,
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
                    showAnimatedDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return SendMoneyEvidenceDialogue(amount: 500,uid: uid,email: email,name: name,destUPID:upi.upiID,upiNo :upi.upiNo,todayLimit:upi.todayLimit,addMoneyLang:language.addmoney,amountLlang:language.amount,upiLang:language.upiLang,transLang:language.trasLang,minAdd:language.minAdd,inValidTransaction: language.inValidTransaction,addRequest:language.addRequest);
                      },
                      animationType: DialogTransitionType.slideFromBottomFade,
                      curve: Curves.fastOutSlowIn,
                      duration: Duration(seconds: 1),
                    );
                  },
                )),
            Consumer<WalletPageProvider>(builder: (context,upi,child){
              return Column(
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
                  ]);
            }),
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
