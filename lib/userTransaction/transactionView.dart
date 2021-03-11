import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'file:///E:/Client/hello_world/hello_world/oneday/lib/dashBoard/API.dart';
import 'package:oneday/test/Leaderboard.dart';
import 'package:oneday/userTransaction/userTransactionProvider.dart';
import 'package:provider/provider.dart';
import 'package:oneday/Language/Language.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
class TransactionView extends StatefulWidget {
  String phoneNo;
  TransactionView({this.phoneNo});
  @override
  _TransactionViewState createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {


  @override
  void initState() {
    super.initState();
    Provider.of<UserTransactionProvider>(context, listen: false).getTransaction(phoneNo: widget.phoneNo);

  }



  @override
  Widget build(BuildContext context) {

    var language = Provider.of<Language>(context, listen: false);
    var tm = Provider.of<UserTransactionProvider>(context, listen: false);
    return   Scaffold(backgroundColor: Colors.amber,
    appBar: AppBar(backgroundColor: Colors.amber,
    title: Text(language.transaction,style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5)),),
      body: _transaction()


    );
  }

  Widget _transaction() {

    final vm = Provider.of<API>(context, listen: true);
   final tm = Provider.of<UserTransactionProvider>(context, listen: true);
    var language = Provider.of<Language>(context, listen: false);

      return Align(alignment: Alignment.topCenter,child:  ListView.builder(
          itemCount: tm.transaction.length,
          reverse: true,
          shrinkWrap: true,
          itemBuilder: (context, snapshot) {
            // vm.getremainingtime(vm.daily_ticket[snapshot].deadline);
            return Card(

                child :Padding(

                  padding: EdgeInsets.all(10),
                  child : Row(
                    children: <Widget>[
                      Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(tm.transaction[snapshot].amount.toString() == null ? "0": tm.transaction[snapshot].amount.toString(),
                              style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5)),
                          Divider(),
                          Text((tm.transaction[snapshot].time.toString()),style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize: 15,fontWeight: FontWeight.bold,color: Colors.blue))
                        ],),
                      Spacer(),
                      if(tm.transaction[snapshot].status.toString()=="Y")
                        Text(language.success,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize: 15,fontWeight: FontWeight.bold,color: Colors.green),)
                      else if(tm.transaction[snapshot].status.toString()=="N")
                        Text(language.failed,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize: 15,fontWeight: FontWeight.bold,color: Colors.red))
                      else if(tm.transaction[snapshot].status.toString()=="S")
                          Text(language.sent,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize: 15,fontWeight: FontWeight.bold,color: Colors.blue),)
                        else if(tm.transaction[snapshot].status.toString()=="T") Text(language.purchased,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize: 15,fontWeight: FontWeight.bold,color: Colors.orange))
                          else if(tm.transaction[snapshot].status.toString()=="P") Text(language.pending,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize: 15,fontWeight: FontWeight.bold,color: Colors.deepPurple))
                            else if(tm.transaction[snapshot].status.toString()=="R") Text(language.received,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize: 15,fontWeight: FontWeight.bold,color: Colors.deepPurple))

                    ],
                  ),

                )
            );

          }),);


  }

}
