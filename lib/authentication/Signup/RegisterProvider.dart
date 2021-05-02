
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oneday/Language/Language.dart';
import 'package:oneday/Model/user.dart';
import 'package:oneday/Model/wallet.dart';
import 'package:oneday/authentication/Signup/OtpVerification.dart';
import 'package:oneday/dashBoard/homeNavigator.dart';
import 'package:oneday/helper/constant.dart';
import 'package:oneday/dashBoard/dashboard.dart';
import 'package:provider/provider.dart';

class RegisterProvider extends ChangeNotifier{
  String phoneNo,verficationId,smsCode,mob,email,password,name;
  bool codeSent = false;



  checkUserDetails({GlobalKey<ScaffoldState> scaffoldKey, BuildContext context}) async{

    var language = Provider.of<Language>(context,listen:false);
    final DBRef = FirebaseDatabase.instance.reference();
    var snapshot = await DBRef.child("Users").once();
    if (!snapshot.value.toString().contains(phoneNo)){
      verifyPhone(phoneNo);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return OtpVerification();
          }));
    }
    else{
      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(language.reg,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,)),backgroundColor: Colors.amber,));
    }
    notifyListeners();
  }

  Future<void>  verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified  = (AuthCredential authResult){
      // getuserDetail(phoneNo);
      // AuthService().signIn(authResult);
    };
    final PhoneVerificationFailed verificationFailed  = (FirebaseAuthException authException){
      print('${authException.message}');
      Fluttertoast.showToast(msg: "Code not Verified");
    };

    final PhoneCodeSent smsSent  = (String verId,[int forceResend]){
      this.codeSent = true;
      this.verficationId = verId;

      Fluttertoast.showToast(msg: verficationId.toString());
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
 Future<void> updateDetail() async{
    final DBRef = FirebaseDatabase.instance.reference();
    Random random = new Random();
    int randomNumber = random.nextInt(8);
    User1 user = await User1(
        name: name,
        phone: phoneNo,
        email: email,
        pincode: "enter pincode",
        profile: dummyProfilePicList[randomNumber],
        state: "enter state",
        num_of_game: "0",
        language : 'Eng',
        bool_lang:true
    );
    Wallet wallet = await Wallet(
        phone: phoneNo,
        total_amount: 0,
        winning_amount: 0,
        added_amount: 0
    );
    DBRef.child("Wallet").child(phoneNo).set(wallet.toJson());
    DBRef.child("Users").child(phoneNo).set(user.toJson());
   // Navigator.of(context).pop();
  }
  Future<void> signUp({String otp,BuildContext context}) async {
    try{
      showDialog(context: context,
          builder: (BuildContext context) {
            return Center(child: CircularProgressIndicator(),);
          });
      await FirebaseAuth.instance.signInWithCredential(PhoneAuthProvider.getCredential(
        verificationId: verficationId,
        smsCode: otp,
        //8160137998
      )).then((value) =>  {
       // Navigator.of(context).pop(),
        if(FirebaseAuth.instance.onAuthStateChanged.isEmpty != null){
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
                HomeNavigator()), (Route<dynamic> route) => false);
          })
        }


      });
     // updateDetail(context: context);

    } on Exception catch(e){
      Fluttertoast.showToast(msg: e.toString());
        otp=null;
    }

  }
}