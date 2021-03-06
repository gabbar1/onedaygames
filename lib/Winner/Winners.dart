import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oneday/Language/Language.dart';
import 'package:oneday/Model/wallet.dart';
import 'package:oneday/Winner/winnerProvider.dart';
import 'package:oneday/helper/smartRefresher.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import 'WinnerList.dart';

class Winner  extends StatefulWidget{
  @override
  _WinnerPageState createState() =>_WinnerPageState();
}

class _WinnerPageState  extends State<Winner>{

  DatabaseReference transRef = FirebaseDatabase.instance.reference();
  String uid ;
  String ticket_image;
  var ticket_deadline;
  var ticket_deadline1;
  String winner;
  String result;
  String ticket_date;
  String type;
  void afterBuildFunction(BuildContext context) {

    var type= Provider.of<WinnerProvider>(context, listen: false);
    Provider.of<WinnerProvider>(context, listen: false).getDailyLottery(context: context);
    Provider.of<WinnerProvider>(context, listen: false).getweeklylottery();
    Provider.of<WinnerProvider>(context, listen: false).getmonthlylottery();
    Provider.of<WinnerProvider>(context, listen: false).getspaciallottery();

  }
  RefreshController refreshController;
  @override
  void initState() {
    super.initState();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    this.uid = user.phoneNumber;
    Provider.of<Language>(context, listen: false).getLanguage(uid);
    refreshController = RefreshController(initialRefresh: true);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => afterBuildFunction(context));

  }



  @override
  Widget build(BuildContext context) {
    var language = Provider.of<Language>(context, listen: false);
    Provider.of<WinnerProvider>(context, listen: false);
    transRef.child("Wallet").child(uid).once().then((DataSnapshot snapshot) {
      if(snapshot!= null){
        Map<dynamic, dynamic> values= snapshot.value;
        var wallet = Wallet.fromJson(values);
        if(this.mounted){
          setState(() {
           var  amount1 = wallet.total_amount.toString();
          });
        }
      }
    });


    return
      DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(language.winners,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline4,)),
            backgroundColor: Colors.amber,
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                Tab(
                  child: Text(
                    language.daily,
                    style: GoogleFonts.barlowCondensed(
                        textStyle: Theme.of(context).textTheme.headline5,
                        fontSize: 20),
                  ),
                ),
                Tab(
                  child: Text(
                    language.weekly,
                    style: GoogleFonts.barlowCondensed(
                        textStyle: Theme.of(context).textTheme.headline5,
                        fontSize: 20),
                  ),
                ),
                Tab(
                  child: Text(
                    language.monthly,
                    style: GoogleFonts.barlowCondensed(
                        textStyle: Theme.of(context).textTheme.headline5,
                        fontSize: 20),
                  ),
                ),
                Tab(
                  child: Text(
                    language.special,
                    style: GoogleFonts.barlowCondensed(
                        textStyle: Theme.of(context).textTheme.headline5,
                        fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _daily(),
              _weekly(),
              _monthly(),
              _special()
            ],
          ),
        ),
      );

  }
  Widget _daily() {
    final vm = Provider.of<WinnerProvider>(context, listen: true);
    var language = Provider.of<Language>(context, listen: false);
    return Consumer<WinnerProvider>(builder: (context,winners,child){
      return  vm.daily_ticket.length == 0 ? Center(child: Image.asset("assets/images/noTicket.png")):
      Align(alignment: Alignment.topCenter,
        child: SmartRefresher(
          controller: refreshController,onRefresh: () {
          refreshController.refreshCompleted();
          Provider.of<WinnerProvider>(context, listen: false).getDailyLottery(context: context );},

          child: ListView.builder(
              itemCount: vm.daily_ticket.length,
              shrinkWrap: true,
              itemBuilder: (context, snapshot) {
                vm.getremainingtime(vm.daily_ticket[snapshot].deadline);
                // print("-------deadline----------"+vm.daily_ticket[snapshot].deadline.toString());
                return InkWell(

                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0,),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        topLeft: Radius.circular(10),),
                    ),
                      elevation: 50,
                      shadowColor: Colors.lightBlue,

                    child: Padding(

                      padding: EdgeInsets.all(5),

                      child : Row(

                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child:  Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(children: [
                                  SizedBox(width: 5,),
                                  Text(vm.daily_ticket[snapshot].name,style: GoogleFonts.barlowCondensed(
                                      textStyle:
                                      Theme.of(context).textTheme.headline5,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      )),
                                  Spacer(),
                                  Text(vm.daily_ticket[snapshot].result_date.toString(),style: GoogleFonts.barlowCondensed(
                                      textStyle:
                                      Theme.of(context).textTheme.headline5,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      ))
                                  ,SizedBox(width: 5,),],),
                                Divider(thickness: 1,color: Colors.black54,),
                                Row(children: [
                                  SizedBox(width: 3,),
                                  FutureBuilder(
                                      future: (vm.getremainingtime(
                                          vm.daily_ticket[snapshot].deadline)),
                                      builder: (context, AsyncSnapshot ftr) {
                                        //  print("--------deadline----"+vm.ticket_deadline1.toString());
                                        if (ftr.hasData) {
                                          if ((((vm.ticket_deadline1 / 3600).truncate().toString().padLeft(2,"0") + ":"+(((vm.ticket_deadline1 / 60).truncate() % 60).toString()).padLeft(2,"0")+":"+((vm.ticket_deadline1 % 60).toString())).padLeft(2,"0")).contains("-")) {
                                            return Text(language.Result_Announced,style: GoogleFonts.barlowCondensed(
                                                textStyle:
                                                Theme.of(context).textTheme.headline5,
                                                fontSize: 20,
                                                color: Colors.amber,
                                                fontWeight: FontWeight.bold));
                                          } else {
                                            return Text(language.time_left+((vm.ticket_deadline1 / 3600).truncate().toString().padLeft(2,"0") + ":"+(((vm.ticket_deadline1 / 60).truncate() % 60).toString()).padLeft(2,"0")+":"+((vm.ticket_deadline1 % 60).toString())).padLeft(2,"0")+ "hrs",style: GoogleFonts.barlowCondensed(
                                                textStyle:
                                                Theme.of(context).textTheme.headline5,
                                                fontSize: 20,
                                                color: Colors.amber,
                                                fontWeight: FontWeight.bold));
                                          }
                                        } else {
                                          return Text(language.loading);
                                        }
                                      }),
                                  Divider(thickness: 1,color: Colors.black54,),
                                  Spacer(),
                                  Text(vm.daily_ticket[snapshot].type,style: GoogleFonts.barlowCondensed(
                                      textStyle:
                                      Theme.of(context).textTheme.headline4,
                                      fontSize: 20,
                                      color: Colors.amber,
                                      fontWeight: FontWeight.bold)),
                                  SizedBox(width: 5,),],),
                                Divider(thickness: 1,color: Colors.black54,),
                                StepProgressIndicator(
                                  totalSteps: 1,
                                  currentStep: 1,
                                  size: 8,
                                  padding: 0,
                                  selectedColor: Colors.red,
                                  unselectedColor: Colors.red,
                                  roundedEdges: Radius.circular(10),
                                  selectedGradientColor: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [Colors.yellowAccent,
                                      Colors.deepOrange],
                                  ),
                                  unselectedGradientColor: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [Colors.white,
                                      Colors.white],
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Row(children: [
                                  SizedBox(width: 5,),
                                  Text((vm.daily_ticket[snapshot].price).toString(),style: GoogleFonts.barlowCondensed(
                                      textStyle:
                                      Theme.of(context).textTheme.headline5,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      )),
                                  Spacer(),
                                ],),
                              ],),
                          )
                        ],
                      ),
                    ),
                    color: Colors.white,
                  ),
                  onTap: () {
                    {
                      ticket_deadline1 = ((DateTime.parse(vm.daily_ticket[snapshot].deadline)
                          .difference(DateTime.now())
                          .inSeconds));
                      ticket_deadline =
                          ((ticket_deadline1 / 3600).truncate().toString().padLeft(
                              2, "0") + ":" +
                              (((ticket_deadline1 / 60).truncate() % 60).toString())
                                  .padLeft(2, "0") + ":" +
                              ((ticket_deadline1 % 60).toString())).padLeft(2, "0");
                      // Fluttertoast.showToast(msg: ticket_deadline);
                      if (ticket_deadline1 > 0) {
                        return showDialog<void>(
                          context: context,
                          barrierDismissible: true, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(language.not_announced_msg+' ',style: GoogleFonts.barlowCondensed(
                                        textStyle:
                                        Theme.of(context).textTheme.headline5,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    // Text('Announcement date is ' + deadline),
                                    //Text('You Needed '+(transaction["amount"] - int.parse(amount1)).toString()+" ??? to play"),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                RaisedButton(
                                  color: Colors.green,
                                  child: Center(child: Text(language.ok,style: GoogleFonts.barlowCondensed(
                                        textStyle:
                                        Theme.of(context).textTheme.headline5,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                                  onPressed: () {
                                    Navigator.of(context).pop();

                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                      else{
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            //  builder: (context) => new Lottery_fill(phone: uid,amt: transaction['Amount'].toString(),price: transaction['price'].toString(),typ:transaction['Name'] ,ticket_type:transaction['ticket_type'].toString() ,numberofsell:transaction['numberofsell'].toString(),wallet_amount: int.parse(amount1),index1: index,)
                              builder: (context) =>
                              new WinnerList(ticket_id: vm.daily_ticket[snapshot].ticket_id,ticket_type: vm.daily_ticket[snapshot].type,)
                          ),
                        );
                      }


                    };
                  },
                );
              }),
        ),);
    });
  }
  Widget _monthly() {
    final vm = Provider.of<WinnerProvider>(context, listen: true);
    var language = Provider.of<Language>(context, listen: false);
    return  vm.monthly_ticket.length == 0 ? Center(child: Image.asset("assets/images/noTicket.png")):
    Align(alignment: Alignment.topCenter,
      child: SmartRefresher(
        controller: refreshController,onRefresh: () {
        refreshController.refreshCompleted();
        Provider.of<WinnerProvider>(context, listen: false).getmonthlylottery();},
        child: ListView.builder(
            itemCount: vm.monthly_ticket.length,
            shrinkWrap: true,
            itemBuilder: (context, snapshot) {
              vm.getremainingtime(vm.monthly_ticket[snapshot].deadline);
              // print("-------deadline----------"+vm.monthly_ticket[snapshot].deadline.toString());

              return InkWell(
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0,),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      topLeft: Radius.circular(10),),
                  ),
                  elevation: 50,
                  shadowColor: Colors.lightBlueAccent,
                  child: Padding(

                    padding: EdgeInsets.all(5),

                    child : Row(

                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child:  Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(children: [
                                SizedBox(width: 5,),
                                Text(vm.monthly_ticket[snapshot].name,style: GoogleFonts.barlowCondensed(
                                        textStyle:
                                        Theme.of(context).textTheme.headline5,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                    )),
                                Spacer(),
                                Text(vm.monthly_ticket[snapshot].result_date.toString(),style: GoogleFonts.barlowCondensed(
                                        textStyle:
                                        Theme.of(context).textTheme.headline5,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                    ))
                                ,SizedBox(width: 5,), ],),
                              Divider(thickness: 1,color: Colors.black54,),
                              Row(children: [
                                SizedBox(width: 3,),
                                FutureBuilder(
                                    future: (vm.getremainingtime(
                                        vm.monthly_ticket[snapshot].deadline)),
                                    builder: (context, AsyncSnapshot ftr) {
                                      //  print("--------deadline----"+vm.ticket_deadline1.toString());
                                      if (ftr.hasData) {
                                        if ((((vm.ticket_deadline1 / 3600).truncate().toString().padLeft(2,"0") + ":"+(((vm.ticket_deadline1 / 60).truncate() % 60).toString()).padLeft(2,"0")+":"+((vm.ticket_deadline1 % 60).toString())).padLeft(2,"0")).contains("-")) {
                                          return Text(language.Result_Announced,style: GoogleFonts.barlowCondensed(
                                        textStyle:
                                        Theme.of(context).textTheme.headline5,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                              color: Colors.amber));
                                        } else {
                                          return Text(language.time_left+((vm.ticket_deadline1 / 3600).truncate().toString().padLeft(2,"0") + ":"+(((vm.ticket_deadline1 / 60).truncate() % 60).toString()).padLeft(2,"0")+":"+((vm.ticket_deadline1 % 60).toString())).padLeft(2,"0")+ "hrs",style: GoogleFonts.barlowCondensed(
                                        textStyle:
                                        Theme.of(context).textTheme.headline5,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                              color: Colors.amber));
                                        }
                                      } else {
                                        return Text(language.loading);
                                      }
                                    }),
                                Divider(thickness: 1,color: Colors.black54,),
                                Spacer(),
                                Text(vm.monthly_ticket[snapshot].type,style: GoogleFonts.barlowCondensed(
                                        textStyle:
                                        Theme.of(context).textTheme.headline5,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                    color: Colors.amber,
                                ),
                                ),
                                SizedBox(width: 5,),],),
                              Divider(thickness: 1,color: Colors.black54,),
                              StepProgressIndicator(
                                totalSteps: 1,
                                currentStep: 1,
                                size: 8,
                                padding: 0,
                                selectedColor: Colors.red,
                                unselectedColor: Colors.red,
                                roundedEdges: Radius.circular(10),
                                selectedGradientColor: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.yellowAccent,
                                    Colors.deepOrange],
                                ),
                                unselectedGradientColor: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.white,
                                    Colors.white],
                                ),
                              ),
                              SizedBox(height: 10,),
                              Row(children: [
                                SizedBox(width: 5,),
                                Text((vm.monthly_ticket[snapshot].price).toString(),style: GoogleFonts.barlowCondensed(
                                        textStyle:
                                        Theme.of(context).textTheme.headline5,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                    )),
                                Spacer(),
                                ],),
                            ],),
                        )
                      ],
                    ),
                  ),
                  color: Colors.white,
                ),
                onTap: () {
                  {
                    ticket_deadline1 = ((DateTime.parse(vm.monthly_ticket[snapshot].deadline)
                        .difference(DateTime.now())
                        .inSeconds));
                    ticket_deadline =
                        ((ticket_deadline1 / 3600).truncate().toString().padLeft(
                            2, "0") + ":" +
                            (((ticket_deadline1 / 60).truncate() % 60).toString())
                                .padLeft(2, "0") + ":" +
                            ((ticket_deadline1 % 60).toString())).padLeft(2, "0");
                    // Fluttertoast.showToast(msg: ticket_deadline);
                    if (ticket_deadline1 > 0) {
                      return showDialog<void>(
                        context: context,
                        barrierDismissible: true, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(language.not_announced_msg+' ',style: GoogleFonts.barlowCondensed(
                                        textStyle:
                                        Theme.of(context).textTheme.headline5,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                )),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  // Text('Announcement date is ' + deadline),
                                  //Text('You Needed '+(transaction["amount"] - int.parse(amount1)).toString()+" ??? to play"),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              RaisedButton(
                                color: Colors.green,
                                child: Center(child: Text(language.ok,style: GoogleFonts.barlowCondensed(
                                        textStyle:
                                        Theme.of(context).textTheme.headline5,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                    ))),
                                onPressed: () {
                                  Navigator.of(context).pop();

                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                    else{
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          //  builder: (context) => new Lottery_fill(phone: uid,amt: transaction['Amount'].toString(),price: transaction['price'].toString(),typ:transaction['Name'] ,ticket_type:transaction['ticket_type'].toString() ,numberofsell:transaction['numberofsell'].toString(),wallet_amount: int.parse(amount1),index1: index,)
                            builder: (context) =>
                            new WinnerList(ticket_id: vm.monthly_ticket[snapshot].ticket_id,ticket_type: vm.monthly_ticket[snapshot].type,)
                        ),
                      );
                    }


                  };
                },
              );
            }),
      ),);
  }
  Widget _weekly() {
    final vm = Provider.of<WinnerProvider>(context, listen: true);
    var language = Provider.of<Language>(context, listen: false);
    return  vm.weekly_ticket.length == 0 ? Center(child: Image.asset("assets/images/noTicket.png")):
    Align(alignment: Alignment.topCenter,
      child: SmartRefresher(
        controller: refreshController,onRefresh: () {
        refreshController.refreshCompleted();
        Provider.of<WinnerProvider>(context, listen: false).getweeklylottery();},
        child: ListView.builder(
            itemCount: vm.weekly_ticket.length,
            shrinkWrap: true,
            itemBuilder: (context, snapshot) {
              vm.getremainingtime(vm.weekly_ticket[snapshot].deadline);
              // print("-------deadline----------"+vm.weekly_ticket[snapshot].deadline.toString());

              return InkWell(
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0,),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      topLeft: Radius.circular(10),),
                  ),
                  elevation: 50,
                  shadowColor: Colors.lightBlueAccent,
                  child: Padding(

                    padding: EdgeInsets.all(5),

                    child : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child:  Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(children: [
                                SizedBox(width: 5,),
                                Text(vm.weekly_ticket[snapshot].name,style: GoogleFonts.barlowCondensed(
                                        textStyle:
                                        Theme.of(context).textTheme.headline5,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                    )),
                                Spacer(),
                                Text(vm.weekly_ticket[snapshot].result_date.toString(),style: GoogleFonts.barlowCondensed(
                                        textStyle:
                                        Theme.of(context).textTheme.headline5,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                    ))
                              ,SizedBox(width: 5,),],),
                              Divider(thickness: 1,color: Colors.black54,),
                              Row(children: [
                                SizedBox(width: 3,),
                                FutureBuilder(
                                    future: (vm.getremainingtime(
                                        vm.weekly_ticket[snapshot].deadline)),
                                    builder: (context, AsyncSnapshot ftr) {
                                      //  print("--------deadline----"+vm.ticket_deadline1.toString());
                                      if (ftr.hasData) {
                                        if ((((vm.ticket_deadline1 / 3600).truncate().toString().padLeft(2,"0") + ":"+(((vm.ticket_deadline1 / 60).truncate() % 60).toString()).padLeft(2,"0")+":"+((vm.ticket_deadline1 % 60).toString())).padLeft(2,"0")).contains("-")) {
                                          return Text(language.Result_Announced,style: GoogleFonts.barlowCondensed(
                                        textStyle:
                                        Theme.of(context).textTheme.headline5,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                              color: Colors.amber));
                                        } else {
                                          return Text(language.time_left+((vm.ticket_deadline1 / 3600).truncate().toString().padLeft(2,"0") + ":"+(((vm.ticket_deadline1 / 60).truncate() % 60).toString()).padLeft(2,"0")+":"+((vm.ticket_deadline1 % 60).toString())).padLeft(2,"0")+ "hrs",style: GoogleFonts.barlowCondensed(
                                        textStyle:
                                        Theme.of(context).textTheme.headline5,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                          color: Colors.amber,
                                              ));
                                        }
                                      } else {
                                        return Text(language.loading);
                                      }
                                    }),
                                Divider(thickness: 3),
                                Spacer(),
                                Text(vm.weekly_ticket[snapshot].type,style: GoogleFonts.barlowCondensed(
                                        textStyle:
                                        Theme.of(context).textTheme.headline5,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                    color: Colors.amber,
                                    )),
                                SizedBox(width: 5,),],),
                              Divider(thickness: 1,color: Colors.black54,),
                              StepProgressIndicator(
                                totalSteps: 1,
                                currentStep: 1,
                                size: 8,
                                padding: 0,
                                selectedColor: Colors.red,
                                unselectedColor: Colors.red,
                                roundedEdges: Radius.circular(10),
                                selectedGradientColor: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.yellowAccent,
                                    Colors.deepOrange],
                                ),
                                unselectedGradientColor: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.white,
                                    Colors.white],
                                ),
                              ),
                              SizedBox(height: 10,),
                              Row(children: [
                                SizedBox(width: 5,),
                                Text((vm.weekly_ticket[snapshot].price).toString(),style: GoogleFonts.barlowCondensed(
                                        textStyle:
                                        Theme.of(context).textTheme.headline5,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                    )),
                                Spacer(),
                                ],),
                              ],),
                        )
                      ],
                    ),
                  ),
                  color: Colors.white,
                ),
                onTap: () {
                  {
                    ticket_deadline1 = ((DateTime.parse(vm.weekly_ticket[snapshot].deadline)
                        .difference(DateTime.now())
                        .inSeconds));
                    ticket_deadline =
                        ((ticket_deadline1 / 3600).truncate().toString().padLeft(
                            2, "0") + ":" +
                            (((ticket_deadline1 / 60).truncate() % 60).toString())
                                .padLeft(2, "0") + ":" +
                            ((ticket_deadline1 % 60).toString())).padLeft(2, "0");
                    // Fluttertoast.showToast(msg: ticket_deadline);
                    if (ticket_deadline1 > 0) {
                      return showDialog<void>(
                        context: context,
                        barrierDismissible: true, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(language.not_announced_msg+' ',style: GoogleFonts.barlowCondensed(
                                        textStyle:
                                        Theme.of(context).textTheme.headline5,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  // Text('Announcement date is ' + deadline),
                                  //Text('You Needed '+(transaction["amount"] - int.parse(amount1)).toString()+" ??? to play"),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              RaisedButton(
                                color: Colors.green,
                                child: Center(child: Text(language.ok,style: GoogleFonts.barlowCondensed(
                                        textStyle:
                                        Theme.of(context).textTheme.headline5,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                ))),
                                onPressed: () {
                                  Navigator.of(context).pop();

                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                    else{
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          //  builder: (context) => new Lottery_fill(phone: uid,amt: transaction['Amount'].toString(),price: transaction['price'].toString(),typ:transaction['Name'] ,ticket_type:transaction['ticket_type'].toString() ,numberofsell:transaction['numberofsell'].toString(),wallet_amount: int.parse(amount1),index1: index,)
                            builder: (context) =>
                            new WinnerList(ticket_id: vm.weekly_ticket[snapshot].ticket_id,ticket_type: vm.weekly_ticket[snapshot].type,)
                        ),
                      );
                    }


                  };
                },
              );
            }),
      ),);
  }
  Widget _special() {
    final vm = Provider.of<WinnerProvider>(context, listen: true);
    var language = Provider.of<Language>(context, listen: false);
    return  vm.special_ticket.length == 0 ? Center(child: Image.asset("assets/images/noTicket.png")):
    Align(alignment: Alignment.topCenter,
      child: SmartRefresher(
        controller: refreshController,onRefresh: () {
        refreshController.refreshCompleted();
        Provider.of<WinnerProvider>(context, listen: false).getspaciallottery();},
        child: ListView.builder(
            itemCount: vm.special_ticket.length,
            shrinkWrap: true,
            itemBuilder: (context, snapshot) {
              vm.getremainingtime(vm.special_ticket[snapshot].deadline);
              // print("-------deadline----------"+vm.special_ticket[snapshot].deadline.toString());

              return InkWell(
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0,),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      topLeft: Radius.circular(10),),
                  ),
                  elevation: 50,
                  shadowColor: Colors.lightBlueAccent,
                  child: Padding(

                    padding: EdgeInsets.all(5),

                    child : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child:  Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(children: [
                                SizedBox(width: 5,),
                                Text(vm.special_ticket[snapshot].name,style: GoogleFonts.barlowCondensed(
                                        textStyle:
                                        Theme.of(context).textTheme.headline5,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                    )),
                                Spacer(),
                                Text(vm.special_ticket[snapshot].result_date.toString(),style: GoogleFonts.barlowCondensed(
                                        textStyle:
                                        Theme.of(context).textTheme.headline5,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                    ),
                                )
                              ,SizedBox(width: 5,),],),
                              Divider(thickness: 1,color: Colors.black54,),
                              Row(children: [
                                SizedBox(width: 3,),
                                FutureBuilder(
                                    future: (vm.getremainingtime(
                                        vm.special_ticket[snapshot].deadline)),
                                    builder: (context, AsyncSnapshot ftr) {
                                      //  print("--------deadline----"+vm.ticket_deadline1.toString());
                                      if (ftr.hasData) {
                                        if ((((vm.ticket_deadline1 / 3600).truncate().toString().padLeft(2,"0") + ":"+(((vm.ticket_deadline1 / 60).truncate() % 60).toString()).padLeft(2,"0")+":"+((vm.ticket_deadline1 % 60).toString())).padLeft(2,"0")).contains("-")) {
                                          return Text(language.Result_Announced,style: GoogleFonts.barlowCondensed(
                                        textStyle:
                                        Theme.of(context).textTheme.headline5,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                              color: Colors.amber,
                                          ));
                                        } else {
                                          return Text(language.time_left+((vm.ticket_deadline1 / 3600).truncate().toString().padLeft(2,"0") + ":"+(((vm.ticket_deadline1 / 60).truncate() % 60).toString()).padLeft(2,"0")+":"+((vm.ticket_deadline1 % 60).toString())).padLeft(2,"0")+ "hrs",style: GoogleFonts.barlowCondensed(
                                        textStyle:
                                        Theme.of(context).textTheme.headline5,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                              color: Colors.amber));
                                        }
                                      } else {
                                        return Text(language.loading);
                                      }
                                    }),
                                Divider(thickness: 1,color: Colors.black54,),
                                Spacer(),
                                Text(vm.special_ticket[snapshot].type,style: GoogleFonts.barlowCondensed(
                                        textStyle:
                                        Theme.of(context).textTheme.headline5,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                color: Colors.amber)),
                                SizedBox(width: 5,),],),
                              Divider(thickness: 1,color: Colors.black54,),
                              StepProgressIndicator(
                                totalSteps: 1,
                                currentStep: 1,
                                size: 8,
                                padding: 0,
                                selectedColor: Colors.red,
                                unselectedColor: Colors.red,
                                roundedEdges: Radius.circular(10),
                                selectedGradientColor: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.yellowAccent,
                                    Colors.deepOrange],
                                ),
                                unselectedGradientColor: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.white,
                                    Colors.white],
                                ),
                              ),
                              SizedBox(height: 10,),
                              Row(children: [
                                SizedBox(width: 5,),
                                Text((vm.special_ticket[snapshot].price).toString(),style: GoogleFonts.barlowCondensed(
                                        textStyle:
                                        Theme.of(context).textTheme.headline5,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                    )),
                                Spacer(),
                              ],),
                            ],),
                        )
                      ],
                    ),
                  ),
                  color: Colors.white,
                ),
                onTap: () {
                  {
                    ticket_deadline1 = ((DateTime.parse(vm.special_ticket[snapshot].deadline)
                        .difference(DateTime.now())
                        .inSeconds));
                    ticket_deadline =
                        ((ticket_deadline1 / 3600).truncate().toString().padLeft(
                            2, "0") + ":" +
                            (((ticket_deadline1 / 60).truncate() % 60).toString())
                                .padLeft(2, "0") + ":" +
                            ((ticket_deadline1 % 60).toString())).padLeft(2, "0");
                    // Fluttertoast.showToast(msg: ticket_deadline);
                    if (ticket_deadline1 > 0) {
                      return showDialog<void>(
                        context: context,
                        barrierDismissible: true, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(language.not_announced_msg+' ',style: GoogleFonts.barlowCondensed(
                                        textStyle:
                                        Theme.of(context).textTheme.headline5,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  // Text('Announcement date is ' + deadline),
                                  //Text('You Needed '+(transaction["amount"] - int.parse(amount1)).toString()+" ??? to play"),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              RaisedButton(
                                color: Colors.green,
                                child: Center(child: Text(language.ok,style: GoogleFonts.barlowCondensed(
                                        textStyle:
                                        Theme.of(context).textTheme.headline5,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                                onPressed: () {
                                  Navigator.of(context).pop();

                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                    else{
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          //  builder: (context) => new Lottery_fill(phone: uid,amt: transaction['Amount'].toString(),price: transaction['price'].toString(),typ:transaction['Name'] ,ticket_type:transaction['ticket_type'].toString() ,numberofsell:transaction['numberofsell'].toString(),wallet_amount: int.parse(amount1),index1: index,)
                            builder: (context) =>
                            new WinnerList(ticket_id: vm.special_ticket[snapshot].ticket_id,ticket_type: vm.special_ticket[snapshot].type,)
                        ),
                      );
                    }


                  };
                },
              );
            }),
      ),);
  }
}
