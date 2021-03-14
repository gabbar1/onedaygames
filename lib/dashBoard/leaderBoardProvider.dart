import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:oneday/Model/winner_price.dart';

class LeaderBoardProvider extends ChangeNotifier{

  DatabaseReference transRef = FirebaseDatabase.instance.reference();
  var leaderBoardList = <Winner_price>[];
  Future<void >getLeaderBoard({String ticket_type,ticket_id}) async{

    transRef.child("Lottery").child(ticket_type).child(ticket_id).child("winner_count").once().then((DataSnapshot snapshot){
      leaderBoardList.clear();
      if(snapshot!= null){
        var leaderList = snapshot.value;
        print("--------LeaderBoard------"+leaderList.toString());
        Iterable list =snapshot.value;
        leaderBoardList =list.map((model) => Winner_price.fromJson(model)).toList();
      }
    });

  }

}