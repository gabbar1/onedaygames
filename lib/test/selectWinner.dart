import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:oneday/Language/Language.dart';
import 'package:provider/provider.dart';

class SelectWinner extends StatefulWidget {

  @override
  _SelectWinnerState createState() => _SelectWinnerState();
}
DatabaseReference transRef = FirebaseDatabase.instance.reference();

class _SelectWinnerState extends State<SelectWinner> {

  @override
  Widget build(BuildContext context) {
    var language = Provider.of<Language>(context,listen:false);
    return Scaffold(

      body: Center(child: RaisedButton(
      onPressed: (){

        transRef.child("Ready_for_Result").child("daily").child("dail00005").once().then((DataSnapshot snapshot){
          Map<dynamic, dynamic> values = snapshot.value;
          values.forEach((key,values){

            print("----------------ticket--------------------"+key.toString());
          });
        });
      },

      child: Text(language.selwin),),),);
  }
}
