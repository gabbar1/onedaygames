import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:oneday/Model/soldTicketModel.dart';
import 'package:oneday/helper/constant.dart';

class MyLotteriesProvider extends ChangeNotifier {
    DatabaseReference transRef = FirebaseDatabase.instance.reference();
    List<SoldTicketsModel> soldTickets = <SoldTicketsModel>[];
  Future<void> getMyTickets({String uid,BuildContext context}) async{
    onLoading(context:context,strMessage: "loading" );
    transRef = FirebaseDatabase.instance.reference();

    transRef.child("Sold_tickets").child(uid).once().then((DataSnapshot snapshot){

      if(snapshot!= null){
        Navigator.pop(context);
        Map<dynamic, dynamic> soldList = snapshot.value;
        soldList.forEach((key,value) {
          SoldTicketsModel sold = SoldTicketsModel.fromJson(value);
          soldTickets.add(sold);
         // print(sold.amount.toString());
          soldTickets.sort((a,b) => DateFormat('EEEE, d MMM, yyyy,h:mm:ss a').parse(b.time).compareTo(DateFormat('EEEE, d MMM, yyyy,h:mm:ss a').parse(a.time)));

        });
        notifyListeners();
      }
    });

  }
}