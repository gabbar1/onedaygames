import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oneday/Language/Language.dart';
import 'file:///E:/Client/hello_world/hello_world/oneday/lib/sendMoney/sendmoney.dart';
import 'file:///E:/Client/hello_world/hello_world/oneday/lib/dashBoard/API.dart';
import 'package:oneday/wallet/walletPageProvider.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:show_more_text_popup/show_more_text_popup.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../userTransaction/transactionView.dart';
import 'package:oneday/test/Send_money_avidence.dart';

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  DatabaseReference transRef = FirebaseDatabase.instance.reference();
  GlobalKey key = new GlobalKey();
  GlobalKey key1 = new GlobalKey();
  String uid;
  String phonenum;
  String status = "No request";
  String user_ac_name, user_ifsc, user_ac;

  void afterBuildFunction(BuildContext context) {

    Provider.of<API>(context, listen: false).userWallet(uid);

  }
  @override
  void initState() {
    super.initState();
    this.uid = '';
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    this.uid = user.phoneNumber;
    Provider.of<API>(context, listen: false).userWallet(uid);
    Provider.of<API>(context, listen: false).userDetail(uid);
    Provider.of<Language>(context, listen: false).getLanguage(uid);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => afterBuildFunction(context));
    setState(() {
      Provider.of<WalletPageProvider>(context, listen: false)
          .checkStatus(phoneNo: uid, context: context);
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var language = Provider.of<Language>(context, listen: false);
    var vm = Provider.of<API>(context, listen: false);
   // vm.userWallet(uid);
    return Consumer<API>(builder: (context, vm, child) {
      return Scaffold(

          backgroundColor: Colors.amber,
          appBar: AppBar(
            backgroundColor: Colors.amber,
            title: Text(language.wallet,
                style: GoogleFonts.barlowCondensed(
                    textStyle: Theme.of(context).textTheme.headline5,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ),
          body:ListView(
            children: [
              Container(
                height: 340,
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
                  child: Column(
                    children: [_mybalance(), _details()],
                  ),
                  color: Colors.white,
                ),
              ),
              Card(
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
                child: _transaction(),
                color: Colors.white,
              ),
              Card(
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
                child: _redeem(),
                color: Colors.white,
              ),
              Card(
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
                child: _sendmoeny(),
                color: Colors.white,
              ),
              Card(
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
                child: _refer(),
                color: Colors.white,
              )
            ],
          ));
    },);
  }

  Widget _mybalance() {

    var language = Provider.of<Language>(context, listen: false);
    var vm = Provider.of<API>(context, listen: false);
    vm.userWallet(uid);
    return Consumer<API>(builder: (context,myBalance,child){
      return Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(language.totalamnt,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 5,
          ),
          Center(
            child: Text(
                myBalance.total_amount1 == null ? "₹ 0" : "₹ " + myBalance.total_amount1,
                style: GoogleFonts.barlowCondensed(
                    textStyle: Theme.of(context).textTheme.headline5,
                    fontSize: 10,
                    fontWeight: FontWeight.bold)),
          ),
          FlatButton(
              color: Colors.green,
              onPressed: () {
                var vm = Provider.of<API>(context, listen: false);
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => Money_Avidence()));
              },
              child: Text(language.addmoney,
                  style: GoogleFonts.barlowCondensed(
                      textStyle: Theme.of(context).textTheme.headline5,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white))),
        ],
      );
    });
  }

  Widget _details() {
    var language = Provider.of<Language>(context, listen: false);
    var vm = Provider.of<API>(context, listen: false);
    return Padding(
      padding: EdgeInsets.all(5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Divider(
                  thickness: 2,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      language.addedmoney,
                      style: GoogleFonts.barlowCondensed(
                          textStyle: Theme.of(context).textTheme.headline5,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    IconButton(
                        key: key,
                        color: Colors.blue,
                        icon: Icon(
                          Icons.info_outline,
                          size: 20,
                        ),
                        onPressed: () {
                          showMoreText(language.admoney_msg);
                        }),
                  ],
                ),
                Text(
                    vm.added_amount1 == null
                        ? "₹ 0"
                        : "  ₹ " + vm.added_amount1,
                    style: GoogleFonts.barlowCondensed(
                        textStyle: Theme.of(context).textTheme.headline5,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
                Divider(
                  thickness: 2,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      language.winning,
                      style: GoogleFonts.barlowCondensed(
                          textStyle: Theme.of(context).textTheme.headline5,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    IconButton(
                        key: key1,
                        color: Colors.blue,
                        icon: Icon(
                          Icons.info_outline,
                          size: 20,
                        ),
                        onPressed: () {
                          showMoreText1(language.wiining_msg);
                        }),
                  ],
                ),
                Text(
                    vm.winning_amount1 == null
                        ? "₹ 0"
                        : "  ₹ " + vm.winning_amount1,
                    style: GoogleFonts.barlowCondensed(
                        textStyle: Theme.of(context).textTheme.headline5,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
                Divider(
                  thickness: 2,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _transaction() {
    var language = Provider.of<Language>(context, listen: false);
    var vm = Provider.of<API>(context, listen: false);
    return InkWell(
      child: Container(
        height: 60,
        child: Center(
          child: Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Text(language.transaction,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              Spacer(),
              Icon(Icons.arrow_forward_ios_sharp),
              SizedBox(
                width: 20,
              )
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => TransactionView(
                  phoneNo: uid,
                )));
      },
    );
  }

  Widget _redeem() {
    var language = Provider.of<Language>(context, listen: false);
    var vm = Provider.of<API>(context, listen: false);
    var wm = Provider.of<WalletPageProvider>(context, listen: false);

    return InkWell(
      child: Container(
        height: 60,
        child: Center(
          child: Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Text(language.redeem,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              Spacer(),
              Expanded(child:  Container(
                margin: EdgeInsets.all(10),
                  height: 25,

                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.red[500],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Consumer<WalletPageProvider>(
                    builder: (context, statusLang, child) {
                      return Center(
                        child: Text(statusLang.status,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      );
                    },
                  )),),
              SizedBox(
                width: 20,
              )
            ],
          ),
        ),
      ),
      onTap: () {
        wm.sendRedeemRequest(
            context: context, scaffoldKey: scaffoldKey, uid: uid);
      },
    );
  }

  Widget _sendmoeny() {
    var language = Provider.of<Language>(context, listen: false);
    var vm = Provider.of<API>(context, listen: false);
    return InkWell(
      child: Container(
        height: 60,
        child: Center(
          child: Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Text(language.sendmoney,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              Spacer(),
              Icon(Icons.arrow_forward_ios_sharp),
              SizedBox(
                width: 20,
              )
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => SendMoney()));
      },
    );
  }

  Widget _refer() {
    var language = Provider.of<Language>(context, listen: false);
    var vm = Provider.of<API>(context, listen: false);
    return InkWell(
      child: Container(
        height: 60,
        child: Center(
          child: Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Text(language.Refer,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              Spacer(),
              Icon(Icons.arrow_forward_ios_sharp),
              SizedBox(
                width: 20,
              )
            ],
          ),
        ),
      ),
      onTap: () {
        Share.share('for downloading go to the website https://onedaygames.in',
            subject: 'Look what I made!');
        Fluttertoast.showToast(msg: "Refer");
      },
    );
  }

  void showMoreText(String text) {
    ShowMoreTextPopup popup = ShowMoreTextPopup(context,
        text: text,
        textStyle: TextStyle(color: Colors.white),
        height: 40,
        width: 300,
        backgroundColor: Colors.blue[300],
        padding: EdgeInsets.all(4.0),
        borderRadius: BorderRadius.circular(10.0));

    /// show the popup for specific widget
    popup.show(
      widgetKey: key,
    );
  }

  void showMoreText1(String text) {
    ShowMoreTextPopup popup = ShowMoreTextPopup(context,
        text: text,
        textStyle: TextStyle(color: Colors.white),
        height: 40,
        width: 300,
        backgroundColor: Colors.blue[300],
        padding: EdgeInsets.all(4.0),
        borderRadius: BorderRadius.circular(10.0));

    /// show the popup for specific widget
    popup.show(
      widgetKey: key1,
    );
  }
}
