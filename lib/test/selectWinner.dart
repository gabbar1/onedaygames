import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SelectWinner extends StatefulWidget {
  @override
  _SelectWinnerState createState() => _SelectWinnerState();
}
DatabaseReference transRef = FirebaseDatabase.instance.reference();
class _SelectWinnerState extends State<SelectWinner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: RaisedButton(
      onPressed: (){
        transRef.child("Ready_for_Result").child("daily").child("dail00005").once().then((DataSnapshot snapshot){
          Map<dynamic, dynamic> values = snapshot.value;
          values.forEach((key,values){

            print("----------------ticket--------------------"+key.toString());
          });
        });
      },
      child: Text("Select Winner"),),),);
  }
}
