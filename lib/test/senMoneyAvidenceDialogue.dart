import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'TransactionProvider.dart';

class SendMoneyEvidenceDialogue extends StatefulWidget {
  int amount;
  String uid,email,name,destUPID,upiNo,todayLimit;
  String addMoneyLang,amountLlang,upiLang,transLang,minAdd,inValidTransaction,addRequest;
  SendMoneyEvidenceDialogue({this.addRequest,this.minAdd,this.amount,this.uid,this.name,this.email,this.destUPID,this.upiNo,this.todayLimit,this.addMoneyLang,this.amountLlang,this.transLang,this.upiLang,this.inValidTransaction});
  @override
  SendMoneyEvidenceDialogue_State createState() =>  SendMoneyEvidenceDialogue_State();
}

class SendMoneyEvidenceDialogue_State extends State<SendMoneyEvidenceDialogue> {
  TextEditingController moneyController = TextEditingController();
  TextEditingController upiController = TextEditingController();
  TextEditingController transactionController = TextEditingController();
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
    var trans = Provider.of<TransactionProvider>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.addMoneyLang),
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
                              SizedBox(height: 10,),
                              Container(

                                child:  TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .allow(RegExp(
                                        "[0-9]")),
                                  ],
                                  controller: moneyController,
                                  keyboardType:
                                  TextInputType.phone,
                                  decoration:
                                  new InputDecoration(
                                      border:
                                      OutlineInputBorder(),
                                      contentPadding:
                                      EdgeInsets.only(
                                          left: 15,
                                          bottom: 11,
                                          top: 11,
                                          right: 15),
                                      hintText:
                                      "enter amount",
                                      //"Enter name",
                                      hintStyle: TextStyle(
                                          fontSize: 12)),
                                  validator: (value) {
                                    if (value
                                        .toString()
                                        .isEmpty) {
                                      return 'enter amount';
                                      //"Please enter valid name";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),

                              ),
                              SizedBox(height: 10,),
                              Text(widget.upiLang),
                              SizedBox(height: 10,),
                              Container(
//7043472840
                                child:  TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .allow(RegExp(
                                        "[A-Z0-9a-z@ ]")),
                                  ],
                                  controller: upiController,
                                  keyboardType:
                                  TextInputType.name,
                                  decoration:
                                  new InputDecoration(
                                      border:
                                      OutlineInputBorder(),
                                      contentPadding:
                                      EdgeInsets.only(
                                          left: 15,
                                          bottom: 11,
                                          top: 11,
                                          right: 15),
                                      hintText:
                                      "enter UPI ID",
                                      //"Enter name",
                                      hintStyle: TextStyle(
                                          fontSize: 12)),
                                  validator: (value) {
                                    if (value
                                        .toString()
                                        .isEmpty) {
                                      return 'enter UPI ID';
                                      //"Please enter valid name";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),

                              ),
                              SizedBox(height: 10,),
                              Text(widget.transLang),
                              SizedBox(height: 10,),
                              Container(

                                child:  TextFormField(

                                  controller: transactionController,
                                  keyboardType:
                                  TextInputType.name,
                                  decoration:
                                  new InputDecoration(
                                      border:
                                      OutlineInputBorder(),
                                      contentPadding:
                                      EdgeInsets.only(
                                          left: 15,
                                          bottom: 11,
                                          top: 11,
                                          right: 15),
                                      hintText:
                                      "enter transactionID",
                                      //"Enter name",
                                      hintStyle: TextStyle(
                                          fontSize: 12)),
                                  validator: (value) {
                                    if (value
                                        .toString()
                                        .isEmpty) {
                                      return 'enter transactionID';
                                      //"Please enter valid name";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),

                              ),
                              SizedBox(height: 25,),
                              Center(child: InkWell(child: Container(decoration: BoxDecoration(
                                color: Colors.amber[700],
                                borderRadius: BorderRadius.circular(10),
                              ),width: MediaQuery.of(context).size.width/2.5,height: 50,child: Center(child: Text(widget.addMoneyLang),),),onTap: (){

                                if(int.parse(moneyController.text)<500){
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
                                        new Text(widget.minAdd, style: TextStyle(fontWeight: FontWeight.w500)),
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
                                } else if (addMoneyFormKey.currentState.validate()){
                                  trans.getTransaction(addRequest:widget.addRequest,inValidTransaction:widget.inValidTransaction,trans: transactionController.text,context: context,name: widget.name,email: widget.email,amount: moneyController.text,uid: widget.uid,upi: upiController.text,destupi: widget.destUPID,upiNo:widget.upiNo,todayLimit:widget.todayLimit);

                                } else{
                                  addMoneyFormKey.currentState.validate();
                                }

                              },),)
                            ]))))));
  }
}
