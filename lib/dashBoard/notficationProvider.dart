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
        Navigator.pop(context);
        Map<dynamic,dynamic> notificationLists = snapshot.value;
        notificationLists.forEach((key, value) {
          NotificationModel notificationModel = NotificationModel.fromJson(value);
          notificationList.add(notificationModel);
          notificationList.sort((a,b) => DateFormat('yyyy-MM-dd').parse(b.time).compareTo(DateFormat('yyyy-MM-dd').parse(a.time)));
        });
        print(notificationLists.toString());
        notifyListeners();
      }
    });

  }
}