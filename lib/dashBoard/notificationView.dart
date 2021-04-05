import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oneday/Language/Language.dart';
import 'package:oneday/Model/notification.dart';
import 'package:oneday/dashBoard/notficationProvider.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'API.dart';

class NotificationView extends StatefulWidget {
  final String uid;
  NotificationView({this.uid});
  @override
  _NotificationViewState createState() => _NotificationViewState();
}


class _NotificationViewState extends State<NotificationView> {

  void afterBuildFunction(BuildContext context) {
    var  notification = Provider.of<NotificationProvider>(context,listen: false);
    notification.getNotification(context: context,topic: widget.uid.replaceAll("+", ""));
  }
  RefreshController refreshController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<Language>(context, listen: false).getLanguage(widget.uid);
    refreshController = RefreshController(initialRefresh: true);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => afterBuildFunction(context));
  }
  @override
  Widget build(BuildContext context) {
    var language = Provider.of<Language>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(language.notification),
      ),
      body: Consumer<NotificationProvider>(builder: (context,notification,child){
        return SmartRefresher(controller: refreshController,child:  ListView.builder(
            itemCount: notification.notificationList.length,
            shrinkWrap: true,
            itemBuilder: (context, snapshot) {


              return Container(
                height:   100,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(notification.notificationList[snapshot].title,
                            style: GoogleFonts.barlowCondensed(
                                textStyle:
                                Theme.of(context).textTheme.headline5,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        Divider(thickness: 2,),
                        Text(notification.notificationList[snapshot].body,
                            style: GoogleFonts.barlowCondensed(
                              textStyle:
                              Theme.of(context).textTheme.headline5,
                              fontSize: 12,
                            )),

                      ],
                    ),
                  ),
                ),

              );
            }),onRefresh: (){
          refreshController.refreshCompleted();
          var  notification = Provider.of<NotificationProvider>(context,listen: false);
          notification.getNotification(context: context,topic: widget.uid.replaceAll("+", ""));

        },);
      },)
    );
  }
}
