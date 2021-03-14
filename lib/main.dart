import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oneday/authentication/SignIn/logInProvider.dart';
import 'package:oneday/authentication/Signup/RegisterProvider.dart';
import 'package:oneday/Language/Language.dart';
import 'package:oneday/dashBoard/leaderBoardProvider.dart';
import 'package:oneday/dashBoard/notficationProvider.dart';
import 'package:oneday/sendMoney/sendMoneyProvider.dart';
import 'package:oneday/test/TransactionProvider.dart';
import 'Winner/winnerProvider.dart';
import 'file:///E:/Client/hello_world/hello_world/oneday/lib/dashBoard/API.dart';
import 'package:oneday/ticket/ticketProvider.dart';
import 'package:oneday/wallet/walletPageProvider.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

import 'myLotteries/myLotteriesProvider.dart';
import 'services/authservice.dart';
import 'userTransaction/userTransactionProvider.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(providers:[
    ChangeNotifierProvider<Language>(create: (_) => Language()),
    ChangeNotifierProvider<API>(create: (_) => API()),
    ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
    ChangeNotifierProvider<RegisterProvider>(create: (_) => RegisterProvider()),
    ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
    ChangeNotifierProvider<TicketProvider>(create: (_) => TicketProvider()),
    ChangeNotifierProvider<UserTransactionProvider>(create: (_) => UserTransactionProvider()),
    ChangeNotifierProvider<WalletPageProvider>(create: (_) => WalletPageProvider()),
    ChangeNotifierProvider<SendMoneyProvider>(create: (_) => SendMoneyProvider()),
    ChangeNotifierProvider<WinnerProvider>(create: (_) => WinnerProvider()),
    ChangeNotifierProvider<TransactionProvider>(create: (_) => TransactionProvider()),
    ChangeNotifierProvider<MyLotteriesProvider>(create: (_) => MyLotteriesProvider()),
    ChangeNotifierProvider<LeaderBoardProvider>(create: (_) => LeaderBoardProvider()),
    ChangeNotifierProvider<NotificationProvider>(create: (_) => NotificationProvider()),
  ],
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
//GoogleFonts.barlowCondensed(
//           textStyle: Theme.of(context).textTheme.headline5
      theme: ThemeData(primaryColor: Colors.amber,fontFamily: GoogleFonts.barlowCondensed().toString() ,
          accentColor:  Colors.amber),
      home: MyApp()
      )
  ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin.initialize(platform);
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {

        print("onMessage: $message");
        final title = message['notification']['title'];
        final body = message['notification']['body'];
        showNotification(title:title,body:body);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        final notification = message['data'];
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    super.initState();
  }
  showNotification({var title,body}) async {
print("0000000000000000"+title.toString());
    var android = new AndroidNotificationDetails(
      'sdffds dsffds',
      "CHANNLE NAME",
      "channelDescription",
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platform);
  }

  @override
  Widget build(BuildContext context) {
    return new SplashScreen(seconds: 1,
      navigateAfterSeconds:  AuthService().handleAuth(),
      title: new Text('Welcome to OneDay',
        style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
      ),
      image: new Image.asset('assets/images/oneday.png'),
      //  backgroundGradient: new LinearGradient(colors: [Colors.cyan, Colors.blue], begin: Alignment.topLeft, end: Alignment.bottomRight),
      backgroundColor: Colors.amber,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      onClick: ()=>print("Flutter Egypt"),
      loaderColor: Colors.red,
    );
  }
}
//TextStyle(fontSize: 15,fontWeight: FontWeight.bold)
