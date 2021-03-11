
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
import 'file:///E:/Client/hello_world/hello_world/oneday/lib/dashBoard/API.dart';
import 'package:provider/provider.dart';

class WalletPageProvider extends ChangeNotifier{
  DatabaseReference transRef = FirebaseDatabase.instance.reference();
 String status = "No Request";
 List<UPIModel> upi = <UPIModel>[];
 String upiID,name;
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

  sendRedeemRequest({BuildContext context,GlobalKey<ScaffoldState> scaffoldKey,String uid}){
    var vm = Provider.of<API>(context, listen: false);
    var language = Provider.of<Language>(context, listen: false);
    if( vm.winning_amount1 == "null" ||vm.winning_amount1==0.toString()){
     // scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(language.insufficient,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize: 10,fontWeight: FontWeight.bold,color: Colors.amber)),));
      final snackBar =
      SnackBar(content: Text(language.insufficient,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize: 10,fontWeight: FontWeight.bold,color: Colors.amber)));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    else {

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
                  Text( vm.winning_amount1 == null ?language.wiining_msg+" : ₹ 0" : "₹ "+vm.winning_amount1,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize: 10,fontWeight: FontWeight.bold)),
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
                            'redeem_amount':vm.winning_amount1,
                            'phone':uid,
                            'ac_no':user.user_ac.toString(),
                            'user_name':user.user_ac_name.toString(),
                            'user_ifsc':user.ifsc.toString(),
                            'status':0

                          });
                          transRef.child("Wallet").child(uid).update({
                            'winning_amount':0
                          });
                          Navigator.pop(context);

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
  }

 void transactionDetails() {
    transRef.child("UPI").once().then((
        DataSnapshot snapshot) {

      var values= snapshot.value;
      print("---------------"+values.toString());
      values.forEach((key,value){
        if(value["status"]=="active"){
          print("-------valuesssss--------"+value.toString());
          upiID =  value['upiId'].toString();
          name = value['name'].toString();
        }
      });
/*      for(int i =0;i<values.length;i++){

        print("---------------"+values[i].toString());
if(values[i]["status"]=="active"){
  print("---------------"+values[i]['status'].toString());
  print("---------------"+values[i]['today_transaction'].toString());
  print("---------------"+values[i]['day_limit'].toString());
  upiID =  values[i]['upiId'].toString();
  name = values[i]['upiId'].toString();
  print("---------------"+values[i]['upiId'].toString());
}

      }*/

    });
//notifyListeners();
  }
}