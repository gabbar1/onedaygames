import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:oneday/Model/number.dart';
import 'package:oneday/Model/user.dart';

class TicketProvider extends ChangeNotifier {
  int number;
  int num_of_game;
  DatabaseReference transRef = FirebaseDatabase.instance.reference();
  
  checkBoughtTicket({String phone, String ticket_type, String ticket_id}) {
    transRef = FirebaseDatabase.instance.reference();
    transRef
        .child("Bought_tickets")
        .child(phone)
        .child(ticket_type)
        .child(ticket_id)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      var numbers = Number.fromJson(values);
      if (numbers.number == null) {
        this.number = 0;
      } else {
        this.number = numbers.number;
      }
      notifyListeners();
    });
  }
  
  checkNumberofGame({String phone}){
    transRef = FirebaseDatabase.instance.reference();
    transRef.child("Users").child(phone).once().then((DataSnapshot snapshot){
      Map<dynamic, dynamic> values= snapshot.value;
      var numbers = User1.fromJson(values);
      if(numbers.num_of_game == null){
          this.num_of_game =0;
      }
      else{
        this.num_of_game =int.parse(numbers.num_of_game);
      }
 notifyListeners();

    });
  }
  
  updateTicketDetails(
      {String phone,
      String typ,
      String price,
      String amt,
      String ticket_id,
      String strPin,
      String resultdate,
      String deadline,
      String ticket_type,
      int ticketCount,
      String numberofsell,
      int added_amount,
      int winning_amount,
      int total_amount,
      int nuOfgame,
      String tName}){
    transRef = FirebaseDatabase.instance.reference();
    var now = new DateTime.now();
    transRef.child("Sold_tickets").child(phone).push().set({
      'name':typ,
      'phone':phone,
      'price':price,
      'amount':amt,
      'ticket_id': ticket_id,
      'ticket_no':strPin,
      'resultdate':resultdate,
      'name':tName,
      'time':DateFormat('EEEE, d MMM, yyyy,h:mm:ss a').format(now),
      'deadline':deadline
    });
    transRef.child("Ready_for_Result").child(ticket_type).child(ticket_id).child(phone).child((number+1).toString()).set({
      'name':typ,
      'phone':phone,
      'price':price,
      'amount':amt,
      'ticket_id': ticket_id,
      'ticket_no':strPin,
      'time':DateFormat('EEEE, d MMM, yyyy,h:mm:ss a').format(now),
      'deadline':deadline,
      'resultdate':resultdate
    });
    transRef.child("Lottery").child(ticket_type).child(ticket_id).update({
      'numberofsell':int.parse(numberofsell)+1
    });
    if(added_amount==0 ||added_amount == null){

      transRef.child("Wallet").child(phone).update({
        'winning_amount':winning_amount-int.parse(amt),
        'total_amount':total_amount-int.parse(amt),
        'time':DateFormat('EEEE, d MMM, yyyy,h:mm:ss a').format(now),
      });
    }
    else{

      transRef.child("Wallet").child(phone).update({
        'added_amount':added_amount-int.parse(amt),
        'total_amount':total_amount-int.parse(amt),
        'time':DateFormat('EEEE, d MMM, yyyy,h:mm:ss a').format(now),
      });
    }
    transRef.child('User_Transaction').child(phone).push().set({
      'amount':amt,
      'status':"T",
      'time':DateFormat('EEEE, d MMM, yyyy,h:mm:ss a').format(now),
    });
    Fluttertoast.showToast(msg: ticketCount.toString());
    transRef.child("Bought_tickets").child(phone).child(ticket_type).child(ticket_id).update({
      'number':number+1
    });
    transRef.child("Users").child(phone).update({
      'num_of_game':num_of_game+1
    });
  }
}
