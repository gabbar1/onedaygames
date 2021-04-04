import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:oneday/userTransaction/userTransactionModel.dart';

class UserTransactionProvider extends ChangeNotifier {

  List<UserTransactionModel> transaction = <UserTransactionModel>[];
  DatabaseReference transRef = FirebaseDatabase.instance.reference();
  Future<void >getTransaction({String phoneNo}) async{
    print("=========Provider===============");
    transRef.child('User_Transaction').child(phoneNo).orderByValue().once().then((DataSnapshot snapshot) async{
      transaction.clear();
      var values=  await snapshot.value;
      if(snapshot!= null){
        Map<dynamic, dynamic> transactionList = snapshot.value;
        transactionList.forEach((key,value) {
          UserTransactionModel sold = UserTransactionModel.fromJson(value);
          transaction.add(sold);
          // print(sold.amount.toString());
          transaction.sort((a,b) => DateFormat('EEEE, d MMM, yyyy,h:mm:ss a').parse(b.time).compareTo(DateFormat('EEEE, d MMM, yyyy,h:mm:ss a').parse(a.time)));

        });
      }

    });
  }

}