import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionProvider extends ChangeNotifier {
  DatabaseReference transRef = FirebaseDatabase.instance.reference();
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  bool isTransefer;
  String tranID;
  getTransaction() {
    transRef.child("User_Transaction").once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> map = snapshot.value;
      map.forEach((key, value) {
        //  print(key.toString());
        transRef
            .child("User_Transaction")
            .child(key.toString())
            .once()
            .then((DataSnapshot child) {
          Map<dynamic, dynamic> childMap = child.value;
          childMap.forEach((keys, values) {
            //  print(values["transaction_id"]);
            tranID = values["transaction_id"].toString();
          });
        });
      });
    });

  }

  setTransaction({BuildContext context,String input,String transID ,String uid,amount,upi,name,email}) {
    if (input == tranID) {
      // print(values["transaction_id"]);

      final snackBar =
      SnackBar(content: Text("This transaction ID already Used.."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }else {
      print("-------------transaction");
      print("-------------transaction"+uid);
      print("-------------transaction"+upi);
      print("-------------transaction"+amount.toString());
      print("-------------transaction"+input.toString());
      var now = new DateTime.now();
      transRef
          .child("User_Transaction")
          .child(uid)
          .push()
          .set({
        'amount': amount,
        'upi': upi,
        'transaction_id': input,
        'status': "P",
        'time':DateTime.now().toString(),
        'name': name,
        'email': email
      });

      firebaseMessaging.subscribeToTopic(uid.replaceAll("+", ""));

      //  Navigator.of(context).pop();
    }
    notifyListeners();
  }
}
