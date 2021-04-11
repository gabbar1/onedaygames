
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:oneday/KYC/kyc.dart';
import 'package:oneday/Model/redeem_status.dart';
import 'package:oneday/Model/upiModel.dart';
import 'package:oneday/Model/user.dart';
import 'package:oneday/Language/Language.dart';
import 'package:oneday/dashBoard/API.dart';
import 'package:provider/provider.dart';

class  WalletPageProvider extends ChangeNotifier{
  DatabaseReference transRef = FirebaseDatabase.instance.reference();
 String status = "No Request";
 List<UPIModel> upi = <UPIModel>[];
 String upiID,name,upiNo,todayLimit;
  checkStatus({String phoneNo,BuildContext context}){
    var language = Provider.of<Language>(context, listen: false);
    transRef.child("Redeem").child(phoneNo).once()
        .then((DataSnapshot snapshot) {
      //status= snapshot.value("status");
      var val =  Status.fromJson(snapshot.value);

      if (val.status==0){
            status = language.pending;
      }
      else if (val.status==2){
        status = language.process;
      }
      else if (val.status==3){
            status = language.success;
      }else if (val.status==4){
        status = language.cancel;
      }else if (val.status==null){
        status = language.noRequest;
      }
      notifyListeners();
    });
  }

  sendRedeemRequest({BuildContext context,String uid,var redeemAmount,message}){
    var vm = Provider.of<API>(context, listen: false);
    var language = Provider.of<Language>(context, listen: false);
    transRef.child("Redeem").child(uid).once()
        .then((DataSnapshot snapshot) {
      //status= snapshot.value("status");
      var val =  Status.fromJson(snapshot.value);
      print("0000000000000000000000000000000000000000000000"+val.status.toString());
      if (val.status==0){

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
              new Text(language.pending, style: TextStyle(fontWeight: FontWeight.w500)),
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
      else if (val.status==2){
        status = language.process;
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
              new Text(language.pending, style: TextStyle(fontWeight: FontWeight.w500)),
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
      else{
        return showDialog<void>(
          context: context,
          barrierDismissible: true, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
                backgroundColor: Colors.white,
                title: Center(child:Text(language.redeem,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize: 10,fontWeight: FontWeight.bold))),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text( redeemAmount == null ?language.wiining_msg+" : ₹ 0" : "₹ "+redeemAmount,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize: 10,fontWeight: FontWeight.bold)),
                    Divider(),
                    Center(child:  Row(children: [
                      FlatButton(onPressed: (){
                        transRef.child("Users").child(uid).once()
                            .then((DataSnapshot snapshot) {
                          //  Map<dynamic, dynamic> values= snapshot.value;
                          var user = User1.fromJson(snapshot.value);
                          if (user.user_ac == null) {
                            Fluttertoast.showToast(msg: language.kyc);
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) =>  KYC(cls: "WalletPage()",)
                                ));

                          }else{
                            var now = new DateTime.now();
                            transRef.child("Redeem").child(uid).update({
                              'time':DateFormat('EEEE, d MMM, yyyy,h:mm:ss a').format(now),
                              'redeem_amount':redeemAmount,
                              'phone':uid,
                              'ac_no':user.user_ac.toString(),
                              'user_name':user.user_ac_name.toString(),
                              'user_ifsc':user.ifsc.toString(),
                              'status':0

                            });
                            transRef.child("Wallet").child(uid).update({
                              'winning_amount':int.parse(vm.winning_amount1) - int.parse(redeemAmount) == null ? 0 : int.parse(vm.winning_amount1) - int.parse(redeemAmount),
                              'total_amount':int.parse(vm.total_amount1) - int.parse(redeemAmount) == null ? 0 : int.parse(vm.total_amount1) - int.parse(redeemAmount),
                            });
                            transRef.child("User_Transaction").child(uid).push().set({
                              'time':DateFormat('EEEE, d MMM, yyyy,h:mm:ss a').format(now),
                              'amount':redeemAmount,
                              'phone':uid,
                              'status':"W",
                              'email':vm.email,
                              'name':vm.name
                            });
                            Navigator.pop(context);
                            Navigator.pop(context);
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
                                  new Text(message, style: TextStyle(fontWeight: FontWeight.w500)),
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



                        });



                      }, child: Text(language.confirm,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize: 10,fontWeight: FontWeight.bold)),color: Colors.green,),
                      SizedBox(width: 50,),
                      FlatButton(onPressed: (){
                        Navigator.pop(context);
                      }, child: Text(language.cancel,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize: 10,fontWeight: FontWeight.bold)),color: Colors.red,)
                    ],),)

                  ],)

            );
          },
        );
      }
      notifyListeners();
    });


  }

 Future<void> transactionDetails() async{
    transRef.child("UPI").once().then((
        DataSnapshot snapshot) {
      var values= snapshot.value;

     print("---------------"+values.toString());
      values.forEach((key,value){
        if(value["status"]=="active"){
         // print("-------valuesssss--------"+value.toString());
          upiID =  value['upiId'].toString();
          name = value['name'].toString();
          upiNo = key.toString();
          todayLimit = value['today_transaction'].toString();


          notifyListeners();
        }
      });


    });

  }
}