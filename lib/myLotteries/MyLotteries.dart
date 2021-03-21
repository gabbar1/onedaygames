import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oneday/Model/soldTicketModel.dart';
import 'package:oneday/Model/user.dart';
import 'package:oneday/myLotteries/myLotteriesProvider.dart';
import 'package:provider/provider.dart';
class MyLotteries  extends StatefulWidget{
  @override
  _MyLotteriesPageState createState() =>_MyLotteriesPageState();
}

class _MyLotteriesPageState  extends State<MyLotteries>{
  DatabaseReference transRef = FirebaseDatabase.instance.reference();
  String uid="" ;
  String Amount ;
  static String phonenum ;
  bool _showTickets = false;
  String language;
  String mytickets = "My Tickets";
  String noticket_msg ="Sorry You don't have any ticket";
  String ticke_no = "Your ticket number is";
  String price_money = "Price Money";
  String result_date = "Result Date";

  void afterBuildFunction(BuildContext context) {

    Provider.of<MyLotteriesProvider>(context,listen: false).getMyTickets(uid: uid,context: context);

  }

  @override
  void initState() {
    //this.uid="" ;
    // this.phonenum ;
    super.initState();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    this.uid = user.phoneNumber;
    phonenum = user.phoneNumber;
    transRef = FirebaseDatabase.instance.reference();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => afterBuildFunction(context));
    transRef.child("Users").child(uid).once().then((DataSnapshot snapshot){
      if(snapshot!= null){
        Map<dynamic, dynamic> values= snapshot.value;
        var user = User1.fromJson(values);
        setState(() {

          language = user.language.toString();
          if(language == "Eng"){
            mytickets="My Tickets";
            noticket_msg ="Sorry You don't have any ticket";
            ticke_no= "Your ticket number is";
            price_money = "Price Money";
            result_date = "Result Date";
          }
          else if (language == "Hind"){
            mytickets="मेरा टिकट";
            noticket_msg ="क्षमा करें, आपके पास कोई टिकट नहीं है";
            ticke_no= "आपका टिकट नंबर है";
            price_money = "इनाम की राशी";
            result_date ="परिणाम दिनांक";

          }
        });
      }
    });
    checkUser();

  }

  checkUser() {
    transRef.child('Sold_tickets').once().then((s) {
      Map<dynamic, dynamic> values = s.value;
      if (values.containsKey(uid)) {
        setState(() {
          _showTickets = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var vm =  Provider.of<MyLotteriesProvider>(context,listen: false);
    return  Scaffold(
      appBar: AppBar(backgroundColor: Colors.amber,
        title: Text(mytickets,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,)),),
      body: ListView.builder(
        itemCount:  vm.soldTickets.length,
          itemBuilder: (context,snap){
            return Card(margin: EdgeInsets.all(10),
            child: _buildTransactionItem(soldTicketsModel: vm.soldTickets[snap]));
      })

/*      _showTickets ?
        Center(child: Text(noticket_msg,style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),) :
      FirebaseAnimatedList( // reverse: true,
        query: transRef.child('Sold_tickets').child(uid),
        itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double>animation,int index) {
          Map transaction = snapshot.value;
       //   print('uid $uid');
          if (transaction.isEmpty) {
            return Center(child: Text(noticket_msg,style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),);
          } else {
            return Card(margin: EdgeInsets.all(10),
              child: _buildTransactionItem(soldTicketsModel: vm.soldTickets[snap]);
          }
        },*/
  //    ),
    );
  }

  Widget _buildTransactionItem({SoldTicketsModel soldTicketsModel}){
    return Padding(padding: EdgeInsets.all(10),
      child : Row(
        children: <Widget>[
          Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text((soldTicketsModel.ticketNo)== null ? "₹" : ticke_no+"  "+soldTicketsModel.ticketNo.toString(),
                  style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black)),
              Divider(thickness: 8,),
              Text((soldTicketsModel.price)== null ? "0" :price_money+" "+ soldTicketsModel.price.toString(),
                  style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize: 15,fontWeight: FontWeight.bold,color: Colors.purple)),
              Divider(thickness: 2,),
              Text(result_date+" "+(soldTicketsModel.deadline).toString(),style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize: 15,fontWeight: FontWeight.bold,color: Colors.green)),
              Divider(thickness: 2,),
              Text((soldTicketsModel.time).toString(),style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize: 15,fontWeight: FontWeight.bold,color: Colors.blue))
            ],),
          Spacer(),
          Column(children: [
            Text((soldTicketsModel.name).toString(),style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize: 15,fontWeight: FontWeight.bold,color: Colors.green))
          ],),
        ],
      ),
    );
  }


}