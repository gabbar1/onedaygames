import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oneday/Language/Language.dart';
import 'package:oneday/Winner/Winners.dart';
import 'package:oneday/dashBoard/notificationView.dart';
import 'package:oneday/drawer/sidebar.dart';
import 'package:oneday/helper/smartRefresher.dart';
import 'package:oneday/profile/Profile.dart';
import 'package:oneday/dashBoard/API.dart';
import 'package:oneday/test/Leaderboard.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class _DashboardPageState extends State<DashboardPage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final List<Message> messages = [];
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

  void fcmSubscribe() {
    firebaseMessaging.subscribeToTopic('daily');
  }

  void fcmUnSubscribe() {
    firebaseMessaging.unsubscribeFromTopic('TopicToListen');
  }

  DatabaseReference transRef = FirebaseDatabase.instance.reference();
  String uid;
  String uid1 = "";
  int index;
  void afterBuildFunction(BuildContext context) {

    var type= Provider.of<API>(context, listen: false);
    Provider.of<API>(context, listen: false).getDailyLottery(context: context );
    Provider.of<API>(context, listen: false).getWeeklyLottery(context: context );
    Provider.of<API>(context, listen: false).getMonthlyLottery(context: context );
    Provider.of<API>(context, listen: false).getSpecialLottery(context: context );
    Provider.of<API>(context, listen: false).userDetail(uid);

  }
  RefreshController refreshController;
  @override
  void initState() {
    super.initState();
    this.uid = '';
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    this.uid = user.phoneNumber;
    transRef = FirebaseDatabase.instance.reference();
    Provider.of<API>(context, listen: false).userWallet(uid);

    Provider.of<Language>(context, listen: false).getLanguage(uid);
    refreshController = RefreshController(initialRefresh: true);
    WidgetsBinding.instance
       .addPostFrameCallback((_) => afterBuildFunction(context));

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var totalAmount = Provider.of<API>(context, listen: false).total_amount1 ?? 0;
    var winningAmount = Provider.of<API>(context, listen: false).winning_amount1 ?? 0;
    var num_of_game = Provider.of<API>(context, listen: false).num_of_game ?? 0;
    var language = Provider.of<Language>(context, listen: false);
    var vm = Provider.of<API>(context, listen: false);



    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "OneDay",
            style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline4),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {

                return showDialog<void>(
                  context: context,
                  barrierDismissible: true, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                        backgroundColor: Colors.amber[200],
                        title: Center(
                            child: Text(language.info.toUpperCase(),
                                style: GoogleFonts.barlowCondensed(
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .headline5,fontWeight: FontWeight.bold))),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(language.balance + totalAmount == null
                                ? " : ₹ 0"
                                : language.balance +
                                " : ₹ " +
                                totalAmount.toString(),style: GoogleFonts.barlowCondensed(fontSize: 15,fontWeight: FontWeight.bold)),
                            Divider(),
                            Text(winningAmount == null
                                ? " : ₹ 0"
                                : language.you_won +
                                " : ₹ " +
                                winningAmount.toString(),style: GoogleFonts.barlowCondensed(fontSize: 15,fontWeight: FontWeight.bold)),
                            Divider(),
                            Text(num_of_game == null
                                ? language.no_ticket + " : 0"
                                : language.no_ticket + " : "+  vm.num_of_game,style: GoogleFonts.barlowCondensed(fontSize: 15,fontWeight: FontWeight.bold)),
                          ],
                        ));
                  },
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.notification_important_outlined),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return NotificationView(uid: uid,);
                }));
              },
            ),
            SizedBox(
              width: 20,
            )
          ],
          backgroundColor: Colors.amber,
          leading: Builder(
            builder: (BuildContext context) {
              return InkWell(
                child: CircleAvatar(
                  radius: 1,
                  backgroundColor: Colors.amber,
                  child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(vm.userprofile == null
                          ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFDjXj1F8Ix-rRFgY_r3GerDoQwfiOMXVt-tZdv_Mcou_yIlUC&s"
                          : vm.userprofile.toString())),
                ),
                onTap: () {
                  Scaffold.of(context).openDrawer();
                 // print(vm.userprofile);
                },
              );
            },
          ),
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
        drawer: SidebarMenu(),
        body: TabBarView(
          children: [
            _myTickets(),
            _weekly(),
            _monthly(),
            _special()
          ],
        ),

      ),
    );
  }

  Widget _myTickets() {
    var totalAmount = Provider.of<API>(context, listen: false).total_amount1;
    var winningAmount =
        Provider.of<API>(context, listen: false).winning_amount1;
    var addedAmount = Provider.of<API>(context, listen: false).added_amount1;
    var num_of_game = Provider.of<API>(context, listen: false).num_of_game;
    final vm = Provider.of<API>(context, listen: true);
    var language = Provider.of<Language>(context, listen: false);
    return  vm.daily_ticket.length == 0 ? Center(child: Image.asset("assets/images/noTicket.png")):
    Align(alignment: Alignment.topCenter,
    child: SmartRefresher( controller: refreshController,onRefresh: () {
      refreshController.refreshCompleted();
      Provider.of<API>(context, listen: false).getDailyLottery(context: context );},
      child: ListView.builder(
        itemCount: vm.daily_ticket.length,
        shrinkWrap: true,
        itemBuilder: (context, snapshot) {
          vm.getremainingtime(vm.daily_ticket[snapshot].deadline);
          // print("-------deadline----------"+vm.daily_ticket[snapshot].deadline.toString());
          return InkWell(
            child: Card(
              margin: EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 10.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Text(language.oneday, style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:16, fontWeight: FontWeight.bold)),
                              Spacer(),
                              FutureBuilder(
                                  future: (vm.getremainingtime(
                                      vm.daily_ticket[snapshot].deadline)),
                                  builder: (context, AsyncSnapshot ftr) {
                                    //  print("--------deadline----"+vm.ticket_deadline1.toString());
                                    if (ftr.hasData) {
                                      if ((((vm.ticket_deadline1 / 3600).truncate().toString().padLeft(2,"0") + ":"+(((vm.ticket_deadline1 / 60).truncate() % 60).toString()).padLeft(2,"0")+":"+((vm.ticket_deadline1 % 60).toString())).padLeft(2,"0")).contains("-")) {
                                        return Text(language.closed, style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:16, fontWeight: FontWeight.bold));
                                      } else {
                                        return Text(((vm.ticket_deadline1 / 3600).truncate().toString().padLeft(2,"0") + ":"+(((vm.ticket_deadline1 / 60).truncate() % 60).toString()).padLeft(2,"0")+":"+((vm.ticket_deadline1 % 60).toString())).padLeft(2,"0"), style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:16, fontWeight: FontWeight.bold));
                                      }
                                    } else {
                                      return Text(language.loading, style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:16, fontWeight: FontWeight.bold));
                                    }
                                  }),
                            ],
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          Row(
                            children: [
                              Text(
                                language.leaderboard,
                                style: GoogleFonts.barlowCondensed(
                                    textStyle:
                                    Theme.of(context).textTheme.headline4,
                                    fontSize: 20,
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              RaisedButton(
                                child: Text("₹ "+vm.daily_ticket[snapshot].amount.toString(), style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline4,fontSize:23, fontWeight: FontWeight.bold)),
                                color: Colors.green,
                                onPressed: () {
                                  vm.comparetimeleft(
                                      vm.daily_ticket[snapshot].deadline);
                                  vm.AfterTimeLeft(
                                      language.ticket,
                                      vm.comparetimeleft(
                                          vm.daily_ticket[snapshot].deadline),
                                      context,
                                      language.announcedate,
                                      vm.daily_ticket[snapshot].result_date
                                          .toString(),
                                      language.winnerlist,
                                      language.cancel,
                                      uid,
                                      vm.daily_ticket[snapshot].type.toString(),
                                      vm.daily_ticket[snapshot].ticket_id
                                          .toString(),
                                      language.limit_ticket,
                                      totalAmount,
                                      vm.daily_ticket[snapshot].amount,
                                      language.insufficient,
                                      language.money_msg,
                                      language.remain_1st,
                                      language.remain_2nd,
                                      language.admoney,
                                      vm.email,
                                      vm.daily_ticket[snapshot].price,
                                      vm.daily_ticket[snapshot].numberofshell,
                                      winningAmount,
                                      addedAmount,
                                      vm.daily_ticket[snapshot].deadline
                                          .toString(),
                                      index);
                                },
                              )
                            ],
                          ),
                          StepProgressIndicator(
                            totalSteps: vm.daily_ticket[snapshot].people,
                            currentStep:
                            vm.daily_ticket[snapshot].numberofshell,
                            size: 8,
                            padding: 0,
                            selectedColor: Colors.red,
                            unselectedColor: Colors.red,
                            roundedEdges: Radius.circular(10),
                            selectedGradientColor: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.yellowAccent, Colors.deepOrange],
                            ),
                            unselectedGradientColor: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.white, Colors.white],
                            ),
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          Row(
                            children: [
                              Text((vm.daily_ticket[snapshot].price).toString(),
                                  style: GoogleFonts.barlowCondensed(
                                      textStyle:
                                      Theme.of(context).textTheme.headline5,
                                     fontSize:16,
                                      fontWeight: FontWeight.bold)),
                              Spacer(),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            onTap: () {
              print(vm.email);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return Leaderboard(
                    phone: uid,
                    amt: vm.daily_ticket[snapshot].amount.toString(),
                    email: vm.email,
                    price: vm.daily_ticket[snapshot].price.toString(),
                    typ: vm.daily_ticket[snapshot].name,
                    ticket_type: vm.daily_ticket[snapshot].type.toString(),
                    numberofsell:
                    vm.daily_ticket[snapshot].numberofshell.toString(),
                    total_amount: int.parse(totalAmount),
                    added_amount: int.parse(addedAmount),
                    winning_amount: int.parse(winningAmount),
                    ticket_id: vm.daily_ticket[snapshot].ticket_id,
                    deadline: vm.daily_ticket[snapshot].deadline,
                    ticket_deadline:
                    vm.comparetimeleft(vm.daily_ticket[snapshot].deadline),
                    people: vm.daily_ticket[snapshot].price,
                    index1: index,
                  );
                },
              ));
            },
          );
        }),),);
  }


  Widget _monthly() {
    //  print("monthly");
    var totalAmount = Provider.of<API>(context, listen: false).total_amount1;
    var winningAmount =
        Provider.of<API>(context, listen: false).winning_amount1;
    var addedAmount = Provider.of<API>(context, listen: false).added_amount1;
    var num_of_game = Provider.of<API>(context, listen: false).num_of_game;
    final vm = Provider.of<API>(context, listen: true);
    var language = Provider.of<Language>(context, listen: false);

    return vm.monthly_ticket.length == 0 ? Center(child: Center(child: Image.asset("assets/images/noTicket.png"))):
   Align(alignment: Alignment.topCenter,
     child:  SmartRefresher(
       controller: refreshController,onRefresh: () {
       refreshController.refreshCompleted();
       Provider.of<API>(context, listen: false).getMonthlyLottery(context: context );},
       child: ListView.builder(
         itemCount: vm.monthly_ticket.length,
           shrinkWrap: true,
         reverse: true,
         itemBuilder: (context, snapshot) {
           // print("-------------------------------------" +
           //      vm.monthly_ticket[snapshot].name);
           return InkWell(
             child: Card(
               margin: EdgeInsets.symmetric(
                 vertical: 5.0,
                 horizontal: 10.0,
               ),
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.only(
                   bottomRight: Radius.circular(10),
                   topRight: Radius.circular(10),
                   bottomLeft: Radius.circular(10),
                   topLeft: Radius.circular(10),
                 ),
               ),
               child: Padding(
                 padding: EdgeInsets.all(5),
                 child: Row(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: <Widget>[
                     Expanded(
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: <Widget>[
                           Row(
                             children: [
                               Text(language.oneday,
                                   style: GoogleFonts.barlowCondensed(
                                       textStyle:
                                       Theme.of(context).textTheme.headline5,
                                      fontSize:16,
                                       fontWeight: FontWeight.bold)),
                               Spacer(),
                               FutureBuilder(
                                   future: (vm.getremainingtime(
                                       vm.monthly_ticket[snapshot].deadline)),
                                   builder: (context, AsyncSnapshot ftr) {
                                     //  print("--------deadline----"+vm.ticket_deadline1.toString());
                                     if (ftr.hasData) {
                                       if ((((vm.ticket_deadline1 / 3600).truncate().toString().padLeft(2,"0") + ":"+(((vm.ticket_deadline1 / 60).truncate() % 60).toString()).padLeft(2,"0")+":"+((vm.ticket_deadline1 % 60).toString())).padLeft(2,"0")).contains("-")) {
                                         return Text(language.closed, style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:16, fontWeight: FontWeight.bold));
                                       } else {
                                         return Text(((vm.ticket_deadline1 / 3600).truncate().toString().padLeft(2,"0") + ":"+(((vm.ticket_deadline1 / 60).truncate() % 60).toString()).padLeft(2,"0")+":"+((vm.ticket_deadline1 % 60).toString())).padLeft(2,"0"), style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:16, fontWeight: FontWeight.bold));
                                       }
                                     } else {
                                       return Text(language.loading, style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:16, fontWeight: FontWeight.bold));
                                     }
                                   }),
                             ],
                           ),
                           Divider(
                             thickness: 1,
                           ),
                           Row(
                             children: [
                               Text(
                                 language.leaderboard,
                                 style: GoogleFonts.barlowCondensed(
                                     textStyle:
                                     Theme.of(context).textTheme.headline5,
                                     fontSize: 20,
                                     color: Colors.amber,
                                     fontWeight: FontWeight.bold),
                               ),
                               Spacer(),
                               RaisedButton(
                                 child: Text(vm.monthly_ticket[snapshot].amount
                                     .toString()),
                                 color: Colors.green,
                                 onPressed: () {
                                   vm.comparetimeleft(
                                       vm.monthly_ticket[snapshot].deadline);
                                   vm.AfterTimeLeft(
                                       language.ticket,
                                       vm.comparetimeleft(
                                           vm.monthly_ticket[snapshot].deadline),
                                       context,
                                       language.announcedate,
                                       vm.monthly_ticket[snapshot].result_date
                                           .toString(),
                                       language.winnerlist,
                                       language.cancel,
                                       uid,
                                       vm.monthly_ticket[snapshot].type.toString(),
                                       vm.monthly_ticket[snapshot].ticket_id
                                           .toString(),
                                       language.limit_ticket,
                                       totalAmount,
                                       vm.monthly_ticket[snapshot].amount,
                                       language.insufficient,
                                       language.money_msg,
                                       language.remain_1st,
                                       language.remain_2nd,
                                       language.admoney,
                                       vm.email,
                                       vm.monthly_ticket[snapshot].price,
                                       vm.monthly_ticket[snapshot].numberofshell,
                                       winningAmount,
                                       addedAmount,
                                       vm.monthly_ticket[snapshot].deadline
                                           .toString(),
                                       index);
                                 },
                               )
                             ],
                           ),
                           Divider(
                             thickness: 1,
                           ),
                           Row(
                             children: [
                               Text(
                                   (vm.monthly_ticket[snapshot].price)
                                       .toString(),
                                   style: GoogleFonts.barlowCondensed(
                                       textStyle:
                                       Theme.of(context).textTheme.headline5,
                                      fontSize:16,
                                       fontWeight: FontWeight.bold)),
                               Spacer(),
                             ],
                           ),
                         ],
                       ),
                     )
                   ],
                 ),
               ),
             ),
             onTap: () {
               print(vm.email);
               Navigator.of(context).push(MaterialPageRoute(
                 builder: (context) {
                   return Leaderboard(
                     phone: uid,
                     amt: vm.monthly_ticket[snapshot].amount.toString(),
                     email: vm.email,
                     price: vm.monthly_ticket[snapshot].price.toString(),
                     typ: vm.monthly_ticket[snapshot].name,
                     ticket_type: vm.monthly_ticket[snapshot].type.toString(),
                     numberofsell:
                     vm.monthly_ticket[snapshot].numberofshell.toString(),
                     total_amount: int.parse(totalAmount),
                     added_amount: int.parse(addedAmount),
                     winning_amount: int.parse(winningAmount),
                     ticket_id: vm.monthly_ticket[snapshot].ticket_id,
                     deadline: vm.monthly_ticket[snapshot].deadline,
                     ticket_deadline:
                     vm.comparetimeleft(vm.monthly_ticket[snapshot].deadline),
                     people: vm.monthly_ticket[snapshot].price,
                     index1: index,
                   );
                 },
               ));
             },
           );
         }),
     ),);
  }

  Widget _weekly() {
    var totalAmount = Provider.of<API>(context, listen: false).total_amount1;
    var winningAmount = Provider.of<API>(context, listen: false).winning_amount1;
    var addedAmount = Provider.of<API>(context, listen: false).added_amount1;
    var num_of_game = Provider.of<API>(context, listen: false).num_of_game;
    final vm = Provider.of<API>(context, listen: true);
    var language = Provider.of<Language>(context, listen: false);

    return vm.weekly_ticket.length == 0 ? Center(child: Center(child: Image.asset("assets/images/noTicket.png")),):
   Align(alignment: Alignment.topCenter,child:  SmartRefresher(
     controller: refreshController,onRefresh: () {
     refreshController.refreshCompleted();
     Provider.of<API>(context, listen: false).getWeeklyLottery(context: context );},
     child: ListView.builder(
         itemCount: vm.weekly_ticket.length,
         reverse: true,
         shrinkWrap: true,
         itemBuilder: (context, snapshot) {
           return InkWell(
             child: Card(
               margin: EdgeInsets.symmetric(
                 vertical: 5.0,
                 horizontal: 10.0,
               ),
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.only(
                   bottomRight: Radius.circular(10),
                   topRight: Radius.circular(10),
                   bottomLeft: Radius.circular(10),
                   topLeft: Radius.circular(10),
                 ),
               ),
               child: Padding(
                 padding: EdgeInsets.all(5),
                 child: Row(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: <Widget>[
                     Expanded(
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: <Widget>[
                           Row(
                             children: [
                               Text(language.oneday,
                                   style: GoogleFonts.barlowCondensed(
                                       textStyle:
                                       Theme.of(context).textTheme.headline5,
                                      fontSize:16,
                                       fontWeight: FontWeight.bold)),
                               Spacer(),
                               FutureBuilder(
                                   future: (vm.getremainingtime(
                                       vm.weekly_ticket[snapshot].deadline)),
                                   builder: (context, AsyncSnapshot ftr) {
                                     //  print("--------deadline----"+vm.ticket_deadline1.toString());
                                     if (ftr.hasData) {
                                       if ((((vm.ticket_deadline1 / 3600).truncate().toString().padLeft(2,"0") + ":"+(((vm.ticket_deadline1 / 60).truncate() % 60).toString()).padLeft(2,"0")+":"+((vm.ticket_deadline1 % 60).toString())).padLeft(2,"0")).contains("-")) {
                                         return Text(language.closed, style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:16, fontWeight: FontWeight.bold));
                                       } else {
                                         return Text(((vm.ticket_deadline1 / 3600).truncate().toString().padLeft(2,"0") + ":"+(((vm.ticket_deadline1 / 60).truncate() % 60).toString()).padLeft(2,"0")+":"+((vm.ticket_deadline1 % 60).toString())).padLeft(2,"0"), style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:16, fontWeight: FontWeight.bold));
                                       }
                                     } else {
                                       return Text(language.loading, style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:16, fontWeight: FontWeight.bold));
                                     }
                                   }),
                             ],
                           ),
                           Divider(
                             thickness: 1,
                           ),
                           Row(
                             children: [
                               Text(
                                 language.leaderboard,
                                 style: GoogleFonts.barlowCondensed(
                                     textStyle:
                                     Theme.of(context).textTheme.headline5,
                                     fontSize: 20,
                                     color: Colors.amber,
                                     fontWeight: FontWeight.bold),
                               ),
                               Spacer(),
                               RaisedButton(
                                 child: Text(vm.weekly_ticket[snapshot].amount
                                     .toString()),
                                 color: Colors.green,
                                 onPressed: () {
                                   vm.comparetimeleft(
                                       vm.weekly_ticket[snapshot].deadline);
                                   vm.AfterTimeLeft(
                                       language.ticket,
                                       vm.comparetimeleft(
                                           vm.weekly_ticket[snapshot].deadline),
                                       context,
                                       language.announcedate,
                                       vm.weekly_ticket[snapshot].result_date
                                           .toString(),
                                       language.winnerlist,
                                       language.cancel,
                                       uid,
                                       vm.weekly_ticket[snapshot].type.toString(),
                                       vm.weekly_ticket[snapshot].ticket_id
                                           .toString(),
                                       language.limit_ticket,
                                       totalAmount,
                                       vm.weekly_ticket[snapshot].amount,
                                       language.insufficient,
                                       language.money_msg,
                                       language.remain_1st,
                                       language.remain_2nd,
                                       language.admoney,
                                       vm.email,
                                       vm.weekly_ticket[snapshot].price,
                                       vm.weekly_ticket[snapshot].numberofshell,
                                       winningAmount,
                                       addedAmount,
                                       vm.weekly_ticket[snapshot].deadline
                                           .toString(),
                                       index);
                                 },
                               )
                             ],
                           ),
                           Divider(
                             thickness: 1,
                           ),
                           Row(
                             children: [
                               Text(
                                   (vm.weekly_ticket[snapshot].price).toString(),
                                   style: GoogleFonts.barlowCondensed(
                                       textStyle:
                                       Theme.of(context).textTheme.headline5,
                                      fontSize:16,
                                       fontWeight: FontWeight.bold)),
                               Spacer(),
                             ],
                           ),
                         ],
                       ),
                     )
                   ],
                 ),
               ),
             ),
             onTap: () {
               print(vm.email);
               Navigator.of(context).push(MaterialPageRoute(
                 builder: (context) {
                   return Leaderboard(
                     phone: uid,
                     amt: vm.weekly_ticket[snapshot].amount.toString(),
                     email: vm.email,
                     price: vm.weekly_ticket[snapshot].price.toString(),
                     typ: vm.weekly_ticket[snapshot].name,
                     ticket_type: vm.weekly_ticket[snapshot].type.toString(),
                     numberofsell:
                     vm.weekly_ticket[snapshot].numberofshell.toString(),
                     total_amount: int.parse(totalAmount),
                     added_amount: int.parse(addedAmount),
                     winning_amount: int.parse(winningAmount),
                     ticket_id: vm.weekly_ticket[snapshot].ticket_id,
                     deadline: vm.weekly_ticket[snapshot].deadline,
                     ticket_deadline:
                     vm.comparetimeleft(vm.weekly_ticket[snapshot].deadline),
                     people: vm.weekly_ticket[snapshot].numberofshell,
                     index1: index,
                   );
                 },
               ));
             },
           );
         }),
   ) ,);
  }

  Widget _special() {
    var totalAmount = Provider.of<API>(context, listen: false).total_amount1;
    var winningAmount =
        Provider.of<API>(context, listen: false).winning_amount1;
    var addedAmount = Provider.of<API>(context, listen: false).added_amount1;
    var num_of_game = Provider.of<API>(context, listen: false).num_of_game;
    final vm = Provider.of<API>(context, listen: true);
    var language = Provider.of<Language>(context, listen: false);
    return vm.special_ticket.length == 0 ? Center(child: Center(child: Image.asset("assets/images/noTicket.png")),):
    Align(
      alignment: Alignment.topCenter,
      child: SmartRefresher(
        controller: refreshController,onRefresh: () {
        refreshController.refreshCompleted();
        Provider.of<API>(context, listen: false).getSpecialLottery(context: context );},
        child: ListView.builder(
          itemCount: vm.special_ticket.length,
          reverse: true,
            shrinkWrap: true,
          itemBuilder: (context, snapshot) {
            return InkWell(
              child: Card(
                margin: EdgeInsets.symmetric(
                  vertical: 5.0,
                  horizontal: 10.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                Text(language.oneday,
                                    style: GoogleFonts.barlowCondensed(
                                        textStyle:
                                        Theme.of(context).textTheme.headline5,
                                       fontSize:16,
                                        fontWeight: FontWeight.bold)),
                                Spacer(),
                                FutureBuilder(
                                    future: (vm.getremainingtime(
                                        vm.special_ticket[snapshot].deadline)),
                                    builder: (context, AsyncSnapshot ftr) {
                                      //  print("--------deadline----"+vm.ticket_deadline1.toString());
                                      if (ftr.hasData) {
                                        if ((((vm.ticket_deadline1 / 3600).truncate().toString().padLeft(2,"0") + ":"+(((vm.ticket_deadline1 / 60).truncate() % 60).toString()).padLeft(2,"0")+":"+((vm.ticket_deadline1 % 60).toString())).padLeft(2,"0")).contains("-")) {
                                          return Text(language.closed, style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:16, fontWeight: FontWeight.bold));
                                        } else {
                                          return Text(((vm.ticket_deadline1 / 3600).truncate().toString().padLeft(2,"0") + ":"+(((vm.ticket_deadline1 / 60).truncate() % 60).toString()).padLeft(2,"0")+":"+((vm.ticket_deadline1 % 60).toString())).padLeft(2,"0"), style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:16, fontWeight: FontWeight.bold));
                                        }
                                      } else {
                                        return Text(language.loading, style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:16, fontWeight: FontWeight.bold));
                                      }
                                    }),
                              ],
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            Row(
                              children: [
                                Text(
                                  language.leaderboard,
                                  style: GoogleFonts.barlowCondensed(
                                      textStyle:
                                      Theme.of(context).textTheme.headline5,
                                      fontSize: 20,
                                      color: Colors.amber,
                                      fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                RaisedButton(
                                  child: Text(vm.special_ticket[snapshot].amount
                                      .toString()),
                                  color: Colors.green,
                                  onPressed: () {
                                    vm.comparetimeleft(
                                        vm.special_ticket[snapshot].deadline);
                                    vm.AfterTimeLeft(
                                        language.ticket,
                                        vm.comparetimeleft(
                                            vm.special_ticket[snapshot].deadline),
                                        context,
                                        language.announcedate,
                                        vm.special_ticket[snapshot].result_date
                                            .toString(),
                                        language.winnerlist,
                                        language.cancel,
                                        uid,
                                        vm.special_ticket[snapshot].type.toString(),
                                        vm.special_ticket[snapshot].ticket_id
                                            .toString(),
                                        language.limit_ticket,
                                        totalAmount,
                                        vm.special_ticket[snapshot].amount,
                                        language.insufficient,
                                        language.money_msg,
                                        language.remain_1st,
                                        language.remain_2nd,
                                        language.admoney,
                                        vm.email,
                                        vm.special_ticket[snapshot].price,
                                        vm.special_ticket[snapshot].numberofshell,
                                        winningAmount,
                                        addedAmount,
                                        vm.special_ticket[snapshot].deadline
                                            .toString(),
                                        index);
                                  },
                                )
                              ],
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            Row(
                              children: [
                                Text(
                                    (vm.special_ticket[snapshot].price)
                                        .toString(),
                                    style: GoogleFonts.barlowCondensed(
                                        textStyle:
                                        Theme.of(context).textTheme.headline5,
                                       fontSize:16,
                                        fontWeight: FontWeight.bold)),
                                Spacer(),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              onTap: () {
                print(vm.email);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return Leaderboard(
                      phone: uid,
                      amt: vm.special_ticket[snapshot].amount.toString(),
                      email: vm.email,
                      price: vm.special_ticket[snapshot].price.toString(),
                      typ: vm.special_ticket[snapshot].name,
                      ticket_type: vm.special_ticket[snapshot].type.toString(),
                      numberofsell:
                      vm.special_ticket[snapshot].numberofshell.toString(),
                      total_amount: int.parse(totalAmount),
                      added_amount: int.parse(addedAmount),
                      winning_amount: int.parse(winningAmount),
                      ticket_id: vm.special_ticket[snapshot].ticket_id,
                      deadline: vm.special_ticket[snapshot].deadline,
                      ticket_deadline:
                      vm.comparetimeleft(vm.special_ticket[snapshot].deadline),
                      people: vm.special_ticket[snapshot].price,
                      index1: index,
                    );
                  },
                ));
              },
            );
          }),
      ),);
  }

  Widget _test() {
    var totalAmount = Provider.of<API>(context, listen: false).total_amount1;
    var winningAmount =
        Provider.of<API>(context, listen: false).winning_amount1;
    var addedAmount = Provider.of<API>(context, listen: false).added_amount1;
    var num_of_game = Provider.of<API>(context, listen: false).num_of_game;
    final vm = Provider.of<API>(context, listen: true);
    var language = Provider.of<Language>(context, listen: false);
    return ListView.builder(
        itemCount: vm.daily_ticket.length,
        itemBuilder: (context, snapshot) {
          return InkWell(
            child: Card(
              margin: EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 10.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Text(language.oneday,
                                  style: GoogleFonts.barlowCondensed(
                                      textStyle:
                                          Theme.of(context).textTheme.headline5,
                                     fontSize:16,
                                      fontWeight: FontWeight.bold)),
                              Spacer(),
                              /*Consumer<API>(builder: (context, API, child) {
                                return vm.getremainingtime(
                                    vm.daily_ticket[snapshot].deadline);
                              }),*/
                            ],
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          Row(
                            children: [
                              Text(
                                language.leaderboard,
                                style: GoogleFonts.barlowCondensed(
                                    textStyle:
                                        Theme.of(context).textTheme.headline5,
                                    fontSize: 20,
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              RaisedButton(
                                child: Text(vm.daily_ticket[snapshot].amount
                                    .toString()),
                                color: Colors.green,
                                onPressed: () {
                                  vm.comparetimeleft(
                                      vm.daily_ticket[snapshot].deadline);
                                  vm.AfterTimeLeft(
                                     language.ticket,
                                      vm.comparetimeleft(
                                          vm.daily_ticket[snapshot].deadline),
                                      context,
                                      language.announcedate,
                                      vm.daily_ticket[snapshot].result_date
                                          .toString(),
                                      language.winnerlist,
                                      language.cancel,
                                      uid,
                                      vm.daily_ticket[snapshot].type.toString(),
                                      vm.daily_ticket[snapshot].ticket_id
                                          .toString(),
                                      language.limit_ticket,
                                      totalAmount,
                                      vm.daily_ticket[snapshot].amount,
                                      language.insufficient,
                                      language.money_msg,
                                      language.remain_1st,
                                      language.remain_2nd,
                                      language.admoney,
                                      vm.email,
                                      vm.daily_ticket[snapshot].price,
                                      vm.daily_ticket[snapshot].numberofshell,
                                      winningAmount,
                                      addedAmount,
                                      vm.daily_ticket[snapshot].deadline
                                          .toString(),
                                      index);
                                },
                              )
                            ],
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          Row(
                            children: [
                              Text((vm.daily_ticket[snapshot].price).toString(),
                                  style: GoogleFonts.barlowCondensed(
                                      textStyle:
                                          Theme.of(context).textTheme.headline5,
                                     fontSize:16,
                                      fontWeight: FontWeight.bold)),
                              Spacer(),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            onTap: () {},
          );
        });
  }

}

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}
