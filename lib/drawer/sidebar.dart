import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oneday/AboutUs/aboutUs.dart';
import 'package:oneday/HowtoPlay/howtoplay.dart';
import 'package:oneday/KYC/kyc.dart';
import 'package:oneday/Model/user.dart';
import 'package:oneday/Model/wallet.dart';
import 'package:oneday/PrivacyPolicy/privacypolicy.dart';
import 'package:oneday/Winner/Winners.dart';
import 'package:oneday/Language/Language.dart';
import 'package:oneday/helper/constant.dart';
import 'file:///E:/Client/hello_world/hello_world/oneday/lib/myLotteries/MyLotteries.dart';
import 'file:///E:/Client/hello_world/hello_world/oneday/lib/profile/Profile.dart';
import 'package:oneday/screen/StartPage.dart';
import 'file:///E:/Client/hello_world/hello_world/oneday/lib/wallet/walletPageView.dart';
import 'package:oneday/services/authservice.dart';
import 'package:oneday/main.dart';
import 'file:///E:/Client/hello_world/hello_world/oneday/lib/dashBoard/API.dart';
import 'package:provider/provider.dart';


class SidebarMenu extends StatefulWidget {
  const SidebarMenu({Key key, this.scaffoldKey}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  _SidebarMenuState createState() => _SidebarMenuState();
}

class _SidebarMenuState extends State<SidebarMenu> {
  DatabaseReference transRef = FirebaseDatabase.instance.reference();

  String uid ;
  static String amount1='';
  static String amount='';
  static String userprofile1='';
  static String username1='';
  var  userprofile;
  var  username;
  var  userwallet;
  var  user_ac;



  @override
  void initState() {
    super.initState();
    this.uid='' ;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    this.uid = user.phoneNumber;
    Provider.of<Language>(context, listen: false).getLanguage(uid);
    Provider.of<API>(context, listen: false).userWallet(uid);
    Provider.of<API>(context, listen: false).userDetail(uid);
  


  }
  Widget _menuHeader() {
    final vm = Provider.of<API>(context, listen: true);
    final language = Provider.of<Language>(context, listen: true);
    transRef.child("Users").child(uid).once().then((DataSnapshot snapshot) {
      if(snapshot!= null){
        Map<dynamic, dynamic> values= snapshot.value;
        var user = User1.fromJson(values);
        if(this.mounted){
          setState(() {
            userprofile =user.profile;
            userprofile1 = userprofile;
            username = user.name;
            username1 =username;
            user_ac = user.user_ac;
          });
        }
      }
    });
    transRef.child("Wallet").child(uid).once().then((DataSnapshot snapshot) {
      if(snapshot!= null){
        Map<dynamic, dynamic> values= snapshot.value;
        var user = Wallet.fromJson(values);
        if(this.mounted){
          setState(() {
            amount =user.total_amount.toString();
            amount1 = user.total_amount.toString();
          });
        }
      }
    });
    return InkWell(
      child: Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(height: 50, width: 50,
            margin: EdgeInsets.only(left: 17, top: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(28),
              image: DecorationImage(
                image: NetworkImage(
                  vm.userprofile == null ? dummyProfilePic : vm.userprofile,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(vm.username.toString() == null ?"   " + "My Name":"   "+ vm.username.toString(),
              style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:20,fontWeight: FontWeight.bold)),
          Spacer(),
          Icon(Icons.arrow_forward_ios, size: 20,
            color: Colors.amber,),
          SizedBox(width: 8,),
      ],),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            Profile(),),
        );
      },
    );
  }

  Widget _userWallet() {
    final vm = Provider.of<API>(context, listen: true);
    final language = Provider.of<Language>(context, listen: true);
    return InkWell(
        child:
        Row(children: [
          Container(
            height: 65,
            width: 40,
            padding: EdgeInsets.only(left: 20),
            child:  SvgPicture
                .asset(
                "assets/icons/wallet.svg"),
          ),

          SizedBox(width: 15,),
          Text(language.mybalance,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:15,fontWeight: FontWeight.bold)),
          Spacer(),
          FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(color: Colors.amber)
              ),
              onPressed: null, child: Text(vm.total_amount1 == null ?"0" : vm.total_amount1,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:15,fontWeight: FontWeight.bold,color: Colors.black))
          ),
          SizedBox(width: 20,)
        ],),
        onTap: () {
          Navigator.push(context,
            MaterialPageRoute(
              ///builder: (context) => LoginPage(),
              builder: (context) => WalletPage(),
            ),
          );
        },
      );
  }

  Positioned _footer() {
    final language = Provider.of<Language>(context, listen: true);
    return

      Positioned(bottom: 0, right: 0, left: 0,
      child: Consumer<AuthService>(builder: (context,authservice,child){
        return Column(children: [  RaisedButton(
          color: Colors.red,
          child: Text(language.logout,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:15,fontWeight: FontWeight.bold)),
          onPressed: (){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
                StartPage()), (Route<dynamic> route) => false);
            authservice.signOut();
          },
        )],);
      },)
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<API>(context, listen: true);
    final language = Provider.of<Language>(context, listen: true);
    return Drawer(
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Container(
                    child: _menuHeader(),
                    color: Colors.black54,
                    height: 80,
                  ),
                  _userWallet(),
                  Row(children: [
                    Container(
                      height: 65,
                      width: 40,
                      padding: EdgeInsets.only(left: 20),
                      child:  SvgPicture
                          .asset(
                          "assets/icons/translation.svg"),
                    ),

                    SizedBox(width: 15,),
                    Text(language.language,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:15,fontWeight: FontWeight.bold)),
                    Spacer(),
                    FlutterSwitch(

                      toggleSize: 45.0,
                      value: language.status2,
                      borderRadius: 30.0,
                      padding: 1.0,
                      toggleColor: Color.fromRGBO(225, 225, 225, 1),
                      switchBorder: Border.all(
                        color: Colors.amber,
                        width: 1.0,
                      ),
                      toggleBorder: Border.all(
                        color: Color.fromRGBO(2, 107, 206, 1),
                        width: 2.0,
                      ),
                      activeColor: Colors.amber,
                      inactiveColor: Colors.black38,
                      onToggle: (val) {
                        Navigator.pop(context);
                        language.checkStatus(val, uid);
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
                            MyApp()), (Route<dynamic> route) => false);

                      },
                    ),
                    SizedBox(width: 20,)

                  ],),
                  InkWell(child:
                  Row(children: [
                    Container(
                      height: 65,
                      width: 40,
                      padding: EdgeInsets.only(left: 20),
                      child:  SvgPicture
                          .asset(
                          "assets/icons/kyc.svg"),
                    ),
                    SizedBox(width: 15,),
                    Text(language.kyc,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:15,fontWeight: FontWeight.bold)),
                    Spacer(),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(color: Colors.amber)
                      ),
                      /*child:
                            Text("Verfiy",style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold,
                                color: Colors.red ),),*/
                      child: vm.user_ac.contains("null")? Text(language.verify,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:15,fontWeight: FontWeight.bold,color: Colors.red),):Text(language.verified,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:15,fontWeight: FontWeight.bold,color: Colors.green)),
                      onPressed: null,
                    ),
                    SizedBox(width: 20,)
                  ],),
                  onTap: () {
                    print("ontap-----------"+vm.user_ac);
                    if (vm.user_ac.contains("null")){
                      Navigator.push(context, MaterialPageRoute(builder: (c) => KYC()),);
                    }


                  },),
                  InkWell(child: Row(children: [
                    Container(
                      height: 65,
                      width: 40,
                      padding: EdgeInsets.only(left: 20),
                      child:  SvgPicture
                          .asset(
                          "assets/icons/tickets.svg"),
                    ),
                    SizedBox(width: 15,),
                    Text(language.mytickets,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:15,fontWeight: FontWeight.bold))
                  ],), onTap: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyLotteries(),),
                    );
                  },),
                  InkWell(child: Row(children: [
                    Container(
                      height: 65,
                      width: 40,
                      padding: EdgeInsets.only(left: 20),
                      child:  SvgPicture
                          .asset(
                          "assets/icons/winners.svg"),
                    ),
                    SizedBox(width: 15,),
                    Text(language.winnerlist,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:15,fontWeight: FontWeight.bold)),
                 ],),
                   onTap: (){
                    Navigator.push(context,
                     MaterialPageRoute(builder: (c) => Winner(),),
                    );
                 },),
                  InkWell(child: Row(children: [
                    Container(
                      height: 65,
                      width: 40,
                      padding: EdgeInsets.only(left: 20),
                      child:  SvgPicture
                          .asset(
                          "assets/icons/guide.svg"),
                    ),
                    SizedBox(width: 15,),
                    Text(language.howtoplay,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:15,fontWeight: FontWeight.bold))

                  ],),
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          ///builder: (context) => LoginPage(),
                          builder: (context) => HowtoPlay(),
                        ),
                      );
                    },),
                  InkWell(child: Row(children: [
                    Container(
                      height: 65,
                      width: 40,
                      padding: EdgeInsets.only(left: 20),
                      child:  SvgPicture
                          .asset(
                          "assets/icons/privacy.svg"),
                    ),
                    SizedBox(width: 15,),
                    Text(language.policy,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:15,fontWeight: FontWeight.bold))


                  ],),onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        ///builder: (context) => LoginPage(),
                        builder: (context) => PrivacyPolicy(),
                      ),
                    );
                  },),
                  InkWell(child: Row(children: [
                    Container(
                      height: 65,
                      width: 40,
                      padding: EdgeInsets.only(left: 20),
                      child:  SvgPicture
                          .asset(
                          "assets/icons/about.svg"),
                    ),
                    SizedBox(width: 15,),
                    Text(language.aboutUs,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:15,fontWeight: FontWeight.bold))
                  ],),onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        ///builder: (context) => LoginPage(),
                        builder: (context) => AboutUs(),
                      ),
                    );
                  },),
                  Divider()
                ],
              ),
            ),
            _footer()

          ],
        ),
      ),
    );
  }
}
