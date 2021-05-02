import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:oneday/test/TransactionProvider.dart';
import 'package:oneday/wallet/walletPageProvider.dart';
import 'package:provider/provider.dart';

class RedeemDialogue extends StatefulWidget {
  String amount;
  String addMoneyLang, amountLlang;
  String title;
  var message;
  String maxAdd,maxxAddPost_text;

  var uid;

  String minRedeem;
  RedeemDialogue({this.title, this.amount, this.amountLlang,this.addMoneyLang,this.maxAdd,this.maxxAddPost_text,this.uid,this.message,this.minRedeem});

  /// RedeemDialogue({this.addRequest,this.minAdd,this.amount,this.uid,this.name,this.email,this.destUPID,this.upiNo,this.todayLimit,this.addMoneyLang,this.amountLlang,this.transLang,this.upiLang,this.inValidTransaction});
  @override
  RedeemDialogue_State createState() => RedeemDialogue_State();
}

class RedeemDialogue_State extends State<RedeemDialogue> {
  TextEditingController moneyController = TextEditingController();
  GlobalKey<FormState> addMoneyFormKey = new GlobalKey<FormState>();
  DatabaseReference transRef = FirebaseDatabase.instance.reference();


  void afterBuildFunction(BuildContext context) {
    moneyController.text = widget.amount.toString();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => afterBuildFunction(context));
  }

  @override
  Widget build(BuildContext context) {

    var wm = Provider.of<WalletPageProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Container(
                    margin: EdgeInsets.all(10),
                    child: Form(
                        key: addMoneyFormKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.amountLlang),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9]")),
                                  ],
                                  controller: moneyController,
                                  keyboardType: TextInputType.phone,
                                  decoration: new InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.only(
                                          left: 15,
                                          bottom: 11,
                                          top: 11,
                                          right: 15),
                                      hintText: "enter amount",
                                      //"Enter name",
                                      hintStyle: TextStyle(fontSize: 12)),
                                  validator: (value) {
                                    if (value.toString().isEmpty) {
                                      return 'enter amount';
                                      //"Please enter valid name";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Center(
                                child: InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.amberAccent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    height: 50,
                                    child: Center(
                                      child: Text(widget.addMoneyLang),
                                    ),
                                  ),
                                  onTap: () {
                                    if(addMoneyFormKey.currentState.validate()){

                                      if(int.parse(widget.amount)<int.parse(moneyController.text)){
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            // return object of type Dialog
                                            return AlertDialog(
                                              title: new Text(
                                                "OneDay",
                                                style: TextStyle(fontWeight: FontWeight.w700),
                                              ),
                                              content:
                                              Text(widget.maxAdd +widget.amount +widget.maxxAddPost_text, style: TextStyle(fontWeight: FontWeight.w500)),
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
                                      } else if (moneyController.text.isEmpty ||int.parse(moneyController.text)<500){
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            // return object of type Dialog
                                            return AlertDialog(
                                              title: new Text(
                                                "OneDay",
                                                style: TextStyle(fontWeight: FontWeight.w700),
                                              ),
                                              content:
                                              new Text(widget.minRedeem, style: TextStyle(fontWeight: FontWeight.w500)),
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
                                      } else{
                                        wm.sendRedeemRequest(
                                            context: context, uid: widget.uid,redeemAmount: moneyController.text,message: widget.message);
                                      }
                                    }{
                                      addMoneyFormKey.currentState.validate();
                                    }

                                  },
                                ),
                              )
                            ]))))));
  }
}
