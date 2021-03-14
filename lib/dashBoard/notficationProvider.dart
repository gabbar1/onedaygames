import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:oneday/Model/notification.dart';
import 'package:oneday/helper/constant.dart';

class NotificationProvider extends ChangeNotifier{
  DatabaseReference transRef = FirebaseDatabase.instance.reference();
  var notificationList = <NotificationModel>[];
  Future<void >getNotification({BuildContext context,String topic}) async{
    onLoading(context: context,strMessage: "Loading");
    transRef.child('notification').child(topic).once().then((DataSnapshot snapshot) {
      notificationList.clear();
      if(snapshot!= null){
        print("------fgghfhf-------"+snapshot.hashCode.toString());
        Navigator.pop(context);
        List<dynamic> notificationLists = snapshot.value;
        print(notificationLists.toString());
        notificationList = notificationLists.map((e) => NotificationModel.fromJson(e)).toList();
        notificationList.sort((a,b) => DateFormat('yyyy-MM-dd').parse(b.time).compareTo(DateFormat('yyyy-MM-dd').parse(a.time)));
        notifyListeners();
      }
    });

  }
}