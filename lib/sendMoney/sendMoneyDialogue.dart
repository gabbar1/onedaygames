import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:oneday/sendMoney/sendMoneyProvider.dart';
import 'package:provider/provider.dart';


class SendMoneyDialogue extends StatefulWidget {
  String amount,send_msg,sendLang;
  String name,image,senderAddedAmount;
  String senderAmount,receiverPhone,senderPhone,username;
  SendMoneyDialogue({this.sendLang,this.name,this.amount,this.image,this.send_msg,this.username,this.receiverPhone,this.senderPhone,this.senderAddedAmount});
  @override
  SendMoneyDialogue_State createState() =>  SendMoneyDialogue_State();
}

class SendMoneyDialogue_State extends State<SendMoneyDialogue> {
  TextEditingController moneyController = TextEditingController();

  GlobalKey<FormState> addMoneyFormKey = new GlobalKey<FormState>();
  DatabaseReference transRef = FirebaseDatabase.instance.reference();
  void afterBuildFunction(BuildContext context) {
    var trans = Provider.of<SendMoneyProvider>(context, listen: false);
    trans.getWalletDetails(senderPhone: widget.senderPhone,recPhone: widget.receiverPhone);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => afterBuildFunction(context));
  }

  @override
  Widget build(BuildContext context) {
    var trans = Provider.of<SendMoneyProvider>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.sendLang),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Container(
                    margin: EdgeInsets.all(10),
                    child: Form(
                        key: addMoneyFormKey,
                        child: Card(margin: EdgeInsets.all(20),elevation: 10,child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                heightFactor: 2,
                                child: CircleAvatar(
                                    radius: 40,
                                    backgroundImage: NetworkImage(widget.image ??
                                         "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFDjXj1F8Ix-rRFgY_r3GerDoQwfiOMXVt-tZdv_Mcou_yIlUC&s"
                                        )),
                              ),
                              SizedBox(height: 5,),
                              Center(child: Text(widget.send_msg + " " + widget.name),),
                              SizedBox(height: 10,),
                              Container(
                                margin: EdgeInsets.only(left: 15,right: 15),
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
                              SizedBox(height: 25,),
                              Center(child: InkWell(child: Container(decoration: BoxDecoration(
                                color: Colors.amber[700],
                                borderRadius: BorderRadius.circular(10),
                              ),width: MediaQuery.of(context).size.width/2.5,height: 50,child: Center(child: Text(widget.sendLang),),),onTap: (){
                                if(addMoneyFormKey.currentState.validate()){

                                  trans.sendTransaction(username: widget.username,senderAmount: trans.sender_amount,senderAddedAmount: widget.senderAddedAmount,receiverAmount: trans.receiverAmount,receiverPhone: widget.receiverPhone,senderPhone: widget.senderPhone,context: context,receiverAddedAmount: trans.receiverAddedAmount,sendingAmount: moneyController.text);
                                }else{
                                  addMoneyFormKey.currentState.validate();
                                }


                              },),),
                              SizedBox(height: 30,)
                            ]),))))));
  }
}
