import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oneday/Language/Language.dart';
import 'package:oneday/authentication/SignIn/logInProvider.dart';
import 'package:provider/provider.dart';



class LoginPage extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<LoginPage>
    with SingleTickerProviderStateMixin {

  final formKey  = new  GlobalKey<FormState>();
  bool visible = true;
  final DBRef = FirebaseDatabase.instance.reference();
  String uid = '';
  String otp;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var login = Provider.of<LoginProvider>(context,listen: false);
    var language = Provider.of<Language>(context, listen: false);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xffF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(language.Loginmsg,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,)),
      ),
      body: SingleChildScrollView(
        child:
        Padding(
          padding:
          EdgeInsets.only(left: 16.0, right: 16.0,top:10),
          child:
          Container(
            margin: EdgeInsets.symmetric(vertical: 5.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.yellow,
                      blurRadius: 4,
                      spreadRadius: 1,
                      offset: Offset(0, 1))
                ]),
            child: Center(child: _phonedetails()
            ),
          ),
        ),
      ),
    );
  }


  Widget _phonedetails(){
    var login = Provider.of<LoginProvider>(context,listen: false);
    var language = Provider.of<Language>(context, listen: false);
    return Visibility(
      child:
      Padding(
        padding: EdgeInsets.only(bottom: 10.0,top: 10),
        child:Padding(
          padding: EdgeInsets.only(bottom: 25.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    left: 25.0, right: 25.0, top: 25.0),
                child:
                Text(language.phnno,
                  style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 25.0, right: 25.0, top: 8.0),
                child:
                new TextField(
                  maxLength: 10,
                  decoration: const InputDecoration(

                      hintText: "Enter Mobile Number"),
                  style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline6,),
                  keyboardType: TextInputType.phone,
                  onChanged: (val){
                    login.phoneNo = "+91"+(val);

                  },

                ),
              ),
              SizedBox(height: 30,),
              Center(child: InkWell(

                onTap: () {

                  //verifyPhone(phoneNo);
                  if (login.phoneNo.length!=13){
                    Fluttertoast.showToast(msg: "Please Enter Valid Phone No");
                  }
                  else{
                    login.checkUserDetails(scaffoldKey: _scaffoldKey,context: context);

                  }
                },
                child: Container(
                  width: 250,
                  padding: EdgeInsets.symmetric(vertical: 13),
                  alignment: Alignment.center,
                  color: Colors.green,
                  child: Text(
                    'LOGIN',style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,)

                  ),
                ),
              ),),
              SizedBox(height: 10,),

            ],
          ),
        ),

      ),
      visible: visible,
    );


  }


  Future<bool> loginAction() async {
    //replace the below line of code with your login request
    await new Future.delayed(const Duration(seconds: 2));
    return true;
  }





}