import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:oneday/userTransaction/userTransactionModel.dart';

class UserTransactionProvider extends ChangeNotifier {

  List<UserTransactionModel> transaction =  List<UserTransactionModel>();
  DatabaseReference transRef = FirebaseDatabase.instance.reference();
  Future<void >getTransaction({String phoneNo}) async{
    print("=========Provider===============");
    transRef.child('User_Transaction').child(phoneNo).orderByValue().once().then((DataSnapshot snapshot) async{
      transaction.clear();
      var values=  await snapshot.value;
      if(values!=null){
        values.forEach((key, values) {
          UserTransactionModel lottery =  UserTransactionModel(
              email: values["email"],
              amount: values["amount"].toString(),
              name: values["name"],
              status: values["status"],
              time: values["time"],
              transactionId: values["transactionId"],
              upi: values["upi"].toString()
          );
          transaction.add(lottery);

        });
      }
    });
  }

}