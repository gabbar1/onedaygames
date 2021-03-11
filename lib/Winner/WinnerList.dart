import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oneday/Model/user.dart';
class WinnerList  extends StatefulWidget{
  @override
  _WinnerListPageState createState() =>_WinnerListPageState();
  WinnerList({ this.ticket_type, this.ticket_id});
  String ticket_id,ticket_type;
}

class _WinnerListPageState  extends State<WinnerList>{
  DatabaseReference transRef = FirebaseDatabase.instance.reference();
  String uid="" ;
  String Amount ;
  static String phonenum ;
  bool _showTickets = false;
  String userprofile,username;
  String phone;
  String language;
  String winners = "Winners";
  String rank = "Rank";
  String won_amount = "Amount Won";
  bool switch2 = true;


  @override
  void initState() {
    //this.uid="" ;
    // this.phonenum ;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    this.uid = user.phoneNumber;
    phonenum = user.phoneNumber;
    transRef = FirebaseDatabase.instance.reference();
    transRef.child("Users").child(uid).once().then((DataSnapshot snapshot){
      if(snapshot!= null){
        Map<dynamic, dynamic> values= snapshot.value;
        var user = User1.fromJson(values);
        setState(() {
          language = user.language.toString();
          switch2 = user.bool_lang;
          if(switch2 == true){
            winners = "Winners";
            rank = "Rank";
            won_amount = "Amount Won";
          }
          else if (switch2 == false){
            winners = "विजेता";
            rank = "पद";
            won_amount = "जीती गई रकम";


          }
        });
      }
    });
    super.initState();

  }





  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    return  Scaffold(
      appBar: AppBar(backgroundColor: Colors.amber,
        title: Text(winners,style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),),
      body:
      FirebaseAnimatedList( // reverse: true,
        query: transRef.child('Winners').child(widget.ticket_type).child(widget.ticket_id),
        itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double>animation,int index) {
          Map transaction =snapshot.value;
          return
            Container(child:

            Card(margin: EdgeInsets.all(10),
              elevation: 5,
              child: Column(children: [_buildTransactionItem(transaction : transaction),Container(child:Center(child: _buildTransactionItem1(transaction : transaction),),height: queryData.size.height/10,width: queryData.size.width,color: Colors.blue[100],)],),),
            height: 200,width: 50,);
        },
      ),
    );
  }

  Widget _buildTransactionItem({Map transaction}){

    return Padding(padding: EdgeInsets.all(10),
      child : Row(
        children: <Widget>[
          Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
             Row(children: [
               StreamBuilder<Event>(
                 stream: FirebaseDatabase.instance
                     .reference()
                     .child('Users')
                     .child(transaction["phone"]).onValue,
                 builder: (BuildContext context, AsyncSnapshot<Event> event){
                   if(!event.hasData)
                     return new
                     CircleAvatar(radius: 25,
                         backgroundImage:  userprofile==null ? NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFDjXj1F8Ix-rRFgY_r3GerDoQwfiOMXVt-tZdv_Mcou_yIlUC&s"): NetworkImage( userprofile)
                     );
                   Map<dynamic,dynamic> data = event.data.snapshot.value;
                   userprofile = data['profile'].toString();
                   return new
                   CircleAvatar(radius: 25,
                       backgroundImage:  NetworkImage(data['profile'].toString())
                   );
                 }
             ),
               SizedBox(width: 15,) ,
               Column(children: [Row(children: [Column(children: [
                  StreamBuilder<Event>(
                      stream: FirebaseDatabase.instance
                          .reference()
                          .child('Users')
                          .child(transaction["phone"]).onValue,
                      builder: (BuildContext context, AsyncSnapshot<Event> event){
                        if(!event.hasData)
                          return    username ==null ? Text("Name",style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold)):Text(username,style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold));
                        Map<dynamic,dynamic> data = event.data.snapshot.value;
                        username = data['name'].toString();
                        return new    Text(data["name"].toString().toUpperCase(),style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold));
                      }
                  ),

                ],), SizedBox(width: 100,),
                 Container(
                   height: 25,
                     width: 50,
                     decoration: BoxDecoration(
                         border: Border.all(
                           color: Colors.red[500],
                         ),
                         borderRadius: BorderRadius.all(Radius.circular(5))
                     ),
                     child: Center(child: Text(widget.ticket_type,style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),)
                 )],), SizedBox(height: 10,),],) ,

             ],

             ),

            ],

          ),

        ],
      ),
    );
  }

  Widget _buildTransactionItem1({Map transaction}){

    return Padding(padding: EdgeInsets.all(10),
      child : Row(
        children: <Widget>[
          Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: [
                SizedBox(width: 15,) ,
                Column(children: [
                  Row(children: [
                    Column(children: [
                      Text(rank,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black12),),
                      SizedBox(height: 5,),
                      Text("#"+transaction["rank"].toString(),style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),),
                    ],),
                    SizedBox(width: 250,),
                    Column(children: [
                      Text(won_amount,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black12),),
                      SizedBox(height: 5,),
                      Text("₹"+transaction["price"].toString(),style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black12),),
                    ],)
                  ],),
                ],) ,
              ],
              ),
            ],

          ),

        ],
      ),
    );
  }


}