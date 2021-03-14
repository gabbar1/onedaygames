import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oneday/Model/notification.dart';
import 'package:oneday/dashBoard/notficationProvider.dart';
import 'package:provider/provider.dart';

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => afterBuildFunction(context));
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
      ),
      body: SingleChildScrollView(child: Consumer<NotificationProvider>(builder: (context,notification,child){
        return ListView.builder(
            itemCount: notification.notificationList.length,
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
                              Text(notification.notificationList[snapshot].title,
                                  style: GoogleFonts.barlowCondensed(
                                      textStyle:
                                      Theme.of(context).textTheme.headline5,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold)),
                              Text(notification.notificationList[snapshot].body,
                                  style: GoogleFonts.barlowCondensed(
                                      textStyle:
                                      Theme.of(context).textTheme.headline5,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold)),

                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),

              );
            });
      },),),
    );
  }
}
