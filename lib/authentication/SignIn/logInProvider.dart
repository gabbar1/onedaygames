import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oneday/Language/Language.dart';
import 'package:oneday/authentication/SignIn/OtpVerification.dart';
import 'package:oneday/dashBoard/homeNavigator.dart';
import 'package:provider/provider.dart';

class LoginProvider extends ChangeNotifier{
  bool codeSent = false;
  String phoneNo,verficationId,smsCode,mob,email,password,name;
  Future<void>  verifyPhone(phoneNo) async{
    final PhoneVerificationCompleted verified  = (AuthCredential authResult){

    };
    final PhoneVerificationFailed verificationFailed  = (FirebaseAuthException authException){
      print('${authException.message}');
      Fluttertoast.showToast(msg: "Code not Verified");
    };

    final PhoneCodeSent smsSent  = (String verId,[int forceResend]){
      this.codeSent=true;
      this.verficationId = verId;
    };

    final  PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId){
          this.verficationId = verId;
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: smsSent, codeAutoRetrievalTimeout: autoTimeout);
    notifyListeners();
  }

  checkUserDetails(
      {GlobalKey<ScaffoldState> scaffoldKey, BuildContext context}) async{
    final DBRef = FirebaseDatabase.instance.reference();
    var language = Provider.of<Language>(context, listen: false);
    var snapshot = await DBRef.child("Users").once();
    if(snapshot.value.toString().contains(phoneNo)){
      verifyPhone(phoneNo).whenComplete((){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return OtpVerification();
            }));
      });

    }
    else{
      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(language.userreg,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,)),backgroundColor: Colors.amber,));
    }
  }

  Future<void> signIn({String otp, BuildContext context}) async {
    try{
      showDialog(context: context,
          builder: (BuildContext context) {
            return Center(child: CircularProgressIndicator(),);
          });
      await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.getCredential(
        verificationId: verficationId,
        smsCode: otp,
      )).then((value) => {
       // Navigator.of(context).pop(),
        if(FirebaseAuth.instance.onAuthStateChanged.isEmpty != null){
            WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
      HomeNavigator()), (Route<dynamic> route) => false);
      })
        }
      /*  StreamBuilder( stream: FirebaseAuth.instance.onAuthStateChanged,builder:(BuildContext context,spanshot){
          if(spanshot.hasData){
            print("-------------------------logedin");
            print(spanshot.data);
            return HomeNavigator();
          }else{
            print("-------------------------logedinNot");
            print(spanshot.data);
            return Text("Loading");
          }
        },),*/
    /*  WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
      HomeNavigator()), (Route<dynamic> route) => false);
      })
*/
      });

      //Navigator.pop(context);
    } on Exception catch(e){
      Fluttertoast.showToast(msg: e.toString());
        otp=null;

    }
    notifyListeners();
  }
}