import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oneday/Language/Language.dart';
import 'package:oneday/Model/user.dart';
import 'package:provider/provider.dart';

class WinnerList extends StatefulWidget {
  @override
  _WinnerListPageState createState() => _WinnerListPageState();
  WinnerList({this.ticket_type, this.ticket_id});
  String ticket_id, ticket_type;
}

class _WinnerListPageState extends State<WinnerList> {
  DatabaseReference transRef = FirebaseDatabase.instance.reference();
  String uid = "";
  String Amount;
  static String phonenum;
  bool _showTickets = false;
  String userprofile, username;
  String phone;

  @override
  void initState() {
    super.initState();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    this.uid = user.phoneNumber;
    phonenum = user.phoneNumber;
    transRef = FirebaseDatabase.instance.reference();
  }

  @override
  Widget build(BuildContext context) {

    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var language = Provider.of<Language>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(language.winners,
            style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5)),
      ),
      body: FirebaseAnimatedList(
        // reverse: true,
        query: transRef
            .child('Winners')
            .child(widget.ticket_type)
            .child(widget.ticket_id),
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          Map transaction = snapshot.value;
          return Container(
            child: Card(
              margin: EdgeInsets.all(5),
              elevation: 50,
              shadowColor: Colors.lightBlueAccent,
              child: Column(
                children: [
                  _buildTransactionItem(transaction: transaction),
                  Container(
                    child: Center(
                      child: _buildTransactionItem1(transaction: transaction),
                    ),
                    height: queryData.size.height / 7,
                    width: queryData.size.width,
                    color: Colors.amberAccent,
                  )
                ],
              ),
            ),
            height: 180,

          );
        },
      ),
    );
  }

  Widget _buildTransactionItem({Map transaction}) {
    var language = Provider.of<Language>(context, listen: false);
    return Padding(
      padding: EdgeInsets.all(10),
      child:  Row(
        children: [
          StreamBuilder<Event>(
              stream: FirebaseDatabase.instance
                  .reference()
                  .child('Users')
                  .child(transaction["phone"])
                  .onValue,
              builder:
                  (BuildContext context, AsyncSnapshot<Event> event) {
                if (!event.hasData)
                  return new CircleAvatar(
                      radius: 25,
                      backgroundImage: userprofile == null
                          ? NetworkImage(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFDjXj1F8Ix-rRFgY_r3GerDoQwfiOMXVt-tZdv_Mcou_yIlUC&s")
                          : NetworkImage(userprofile));
                Map<dynamic, dynamic> data = event.data.snapshot.value;
                userprofile = data['profile'].toString();
                return new CircleAvatar(
                    radius: 25,
                    backgroundImage:
                    NetworkImage(data['profile'].toString()));
              }),
          SizedBox(
            width: 15,
          ),
          StreamBuilder<Event>(
              stream: FirebaseDatabase.instance
                  .reference()
                  .child('Users')
                  .child(transaction["phone"])
                  .onValue,
              builder: (BuildContext context,
                  AsyncSnapshot<Event> event) {
                if (!event.hasData)
                  return username == null
                      ? Text(language.namep,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold))
                      : Text(username,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold));
                Map<dynamic, dynamic> data =
                    event.data.snapshot.value;
                username = data['name'].toString();
                return new Text(
                    data["name"].toString().toUpperCase(),
                    style: GoogleFonts.barlowCondensed(
                        textStyle: Theme.of(context).textTheme.headline5,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87));
              }),
        ],
      ),
    );
  }

  Widget _buildTransactionItem1({Map transaction}) {
    var language = Provider.of<Language>(context, listen: false);
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          SizedBox(width: 10,),
          Container(
            child: Column(
              children: [
                Text(
                  language.rank,
                  style: GoogleFonts.barlowCondensed(
                      textStyle: Theme.of(context).textTheme.headline5,
                      fontSize: 20,
                      //fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                SizedBox(
                  height: 1,
                ),
                Text(
                  "#" + transaction["rank"].toString(),
                  style: GoogleFonts.barlowCondensed(
                      textStyle: Theme.of(context).textTheme.headline5,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ],
            ),
          ),
          Spacer(),
          Expanded(
            child: Column(
              children: [
                Text(
                  language.won_amount,
                  style: GoogleFonts.barlowCondensed(
                      textStyle: Theme.of(context).textTheme.headline5,
                      fontSize: 20,
                      //fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                SizedBox(
                  height: 1,
                ),
                Text(
                  "₹" + transaction["price"].toString(),
                  style: GoogleFonts.barlowCondensed(
                      textStyle: Theme.of(context).textTheme.headline5,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ],
            ),
          ),
          SizedBox(width: 15,)
        ],
      ),
    );
  }
}
