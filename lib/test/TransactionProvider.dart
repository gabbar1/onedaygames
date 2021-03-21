import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oneday/Model/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  DatabaseReference transRef = FirebaseDatabase.instance.reference();
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  bool isTransefer;
  List<UserTransaction> transactionList = <UserTransaction>[];
  String tranID;
  bool isAlready = false;
 Future<void> getTransaction({String inValidTransaction,addRequest,String trans,BuildContext context,uid,email,name,upi,amount,destupi,upiNo,todayLimit})  async{
    transRef.child("User_Transaction").once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> map = snapshot.value;
      //print(map.remove(snapshot.key));
      map.forEach((key, values) {
        values.forEach((childKey, childValues) {
          UserTransaction userT = UserTransaction.fromJson(childValues);
          if(userT.transactionId == trans){
            this.isAlready =true;
            print(isAlready);
            notifyListeners();
          }

       });
      });

      if(isAlready){
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
              new Text(inValidTransaction, style: TextStyle(fontWeight: FontWeight.w500)),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text(
                    "Ok",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    isAlready = false;
                  },
                ),
              ],
            );
          },
        );
      }
      else{
        var now = DateTime.now();
        transRef
            .child("User_Transaction")
            .child(uid)
            .push()
            .set({
          'amount': amount,
          'upi': upi,
          'transaction_id': trans,
          'status': "P",
          'time':DateFormat('EEEE, d MMM, yyyy,h:mm:ss a').format(now),
          'name': name,
          'email': email
        }).whenComplete(() {
          transRef
              .child("UPI")
              .child(upiNo)
              .update({
            'today_transaction': int.parse(todayLimit)+int.parse(amount)
          });
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
                                      new Text(addRequest, style: TextStyle(fontWeight: FontWeight.w500)),
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
        });
      }

    });

 notifyListeners();
  }

 }
