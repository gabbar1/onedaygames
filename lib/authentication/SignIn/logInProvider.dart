import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oneday/authentication/SignIn/OtpVerification.dart';
import 'file:///E:/Client/hello_world/hello_world/oneday/lib/dashBoard/dashboard.dart';

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
        timeout: const Duration(seconds: 30),
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: smsSent, codeAutoRetrievalTimeout: autoTimeout);
    notifyListeners();
  }

  checkUserDetails(
      {GlobalKey<ScaffoldState> scaffoldKey, BuildContext context}) async{
    final DBRef = FirebaseDatabase.instance.reference();
    var snapshot = await DBRef.child("Users").once();
    if(snapshot.value.toString().contains(phoneNo)){
      verifyPhone(phoneNo);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return OtpVerification();
          }));
    }
    else{
      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("User not found Please Register",style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),));
    }
  }

  Future<void> signIn({String otp, BuildContext context}) async {
    try{
      await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.getCredential(
        verificationId: verficationId,
        smsCode: otp,
      ));
      Future.delayed(Duration(seconds: 5), () {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
            DashboardPage()), (Route<dynamic> route) => false);
       // Navigator.of(context).pop();
      }) ;
      //Navigator.pop(context);
    } on Exception catch(e){
      Fluttertoast.showToast(msg: "Please enter valid otp");
        otp=null;

    }
    notifyListeners();
  }
}