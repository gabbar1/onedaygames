import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oneday/Model/user.dart';
import 'package:oneday/dashBoard/dashboard.dart';
import 'package:oneday/wallet/walletPageView.dart';
class KYC extends StatefulWidget {
  KYC({this.cls});
  String cls;
  @override
  _KYCState createState() => _KYCState();

}

class _KYCState extends State<KYC> {



  final formKey  = new  GlobalKey<FormState>();
  String phoneNo,verficationId,smsCode,mob,email,password,name;
  bool codeSent = false;
  final DBRef = FirebaseDatabase.instance.reference();
  String uid = '';
  String otp;
  int accountNo, reaccountNo;
  String ifsc,user_name;
  DatabaseReference transRef = FirebaseDatabase.instance.reference();
  String phonenum ;
  static String amount1;
  static String trans1;
  bool switch2 = true;
  String account_detl = "Enter Account Details";
  String act_no = "Account Number";
  String p_act_no = "Enter Account Number";
  String cact_no = "Confirmn Account Number";
  String p_cact_no = "Re Enter Account Number";
  String ifsc_no = "IFSC";
  String p_ifsc_no = "Enter IFSC";
  String name_ac = "Name";
  String p_name = "Enter Name";
  String enter_empty = "Please fill the Empty field";
  String account_matching = "Account Number is not matching";
  String submit = "SUBMIT";
  String info = "Info";

  @override
  void initState() {
    this.uid='' ;
    this.phonenum ;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    this.uid = user.phoneNumber;
    this.phonenum = user.phoneNumber;
    transRef = FirebaseDatabase.instance.reference();
    transRef.child("Users").child(uid).once().then((DataSnapshot snapshot){
      if(snapshot!= null){
        Map<dynamic, dynamic> values= snapshot.value;
        var user = User1.fromJson(values);
        setState(() {

          switch2 = user.bool_lang;
          if(switch2 == true){
             account_detl = "Enter Account Details";
             act_no = "Account Number";
             p_act_no = "Enter Account Number";
             cact_no = "Confirmn Account Number";
             p_cact_no = "Re Enter Account Number";
             ifsc_no = "IFSC";
             p_ifsc_no = "Enter IFSC";
             name_ac = "Name";
             p_name = "Enter Name";
             enter_empty = "Please fill the Empty field";
             account_matching = "Account Number is not matching";
             submit = "SUBMIT";
             info = "Info";
          }
          else if (switch2 == false){
            account_detl = "खाता विवरण दर्ज करें";
            act_no = "खाता संख्या";
            p_act_no = "खाता संख्या दर्ज करें";
            cact_no = "खाता संख्या की पुष्टि करें";
            p_cact_no = "खाता संख्या पुनः दर्ज करें";
            ifsc_no = "IFSC";
            p_ifsc_no = "IFSC दर्ज करें";
            name_ac = "नाम";
            p_name = "नाम दर्ज करें";
            enter_empty = "कृपया खाली क्षेत्र भरें";
            account_matching = "खाता संख्या मेल नहीं खा रही है";
            submit = "प्रस्तुत";
            info = "जानकारी";
          }
        });
      }
    });
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(account_detl,style: GoogleFonts.barlowCondensed(
            textStyle:
            Theme.of(context).textTheme.headline5,
            fontSize:20,
            fontWeight: FontWeight.bold)),

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

            child: Center(
                child:

                _phonedetails()
            ),
          ),


        ),
      ),

    );

  }



  Widget _phonedetails(){

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
                new Text(
                  act_no,
                    style: GoogleFonts.barlowCondensed(
                        textStyle:
                        Theme.of(context).textTheme.headline5,
                        fontSize:16,
                        fontWeight: FontWeight.bold)
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 25.0, right: 25.0, top: 2.0),
                child:
                new TextField(
                  style: GoogleFonts.barlowCondensed(
                      textStyle:
                      Theme.of(context).textTheme.headline5,
                      fontSize:16,
                      fontWeight: FontWeight.bold),
                  obscureText: true,
                  decoration:  InputDecoration(
                      hintText: p_act_no),
                  onChanged: (val){
                    this.accountNo=int.parse(val);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 25.0, right: 25.0, top: 25.0),
                child:
                new Text(
                  cact_no,
                    style: GoogleFonts.barlowCondensed(
                        textStyle:
                        Theme.of(context).textTheme.headline5,
                        fontSize:16,
                        fontWeight: FontWeight.bold)
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 25.0, right: 25.0, top: 2.0),
                child:
                new TextField(
                    style: GoogleFonts.barlowCondensed(
                        textStyle:
                        Theme.of(context).textTheme.headline5,
                        fontSize:16,
                        fontWeight: FontWeight.bold),
                  decoration:  InputDecoration(
                      hintText: p_cact_no),
                  onChanged: (val){
                    this.reaccountNo=int.parse(val);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 25.0, right: 25.0, top: 25.0),
                child:
                Text(ifsc_no,
                  style: GoogleFonts.barlowCondensed(
                      textStyle:
                      Theme.of(context).textTheme.headline5,
                      fontSize:16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 25.0, right: 25.0, top: 8.0),
                child:
                new TextField(
                    style: GoogleFonts.barlowCondensed(
                        textStyle:
                        Theme.of(context).textTheme.headline5,
                        fontSize:16,
                        fontWeight: FontWeight.bold),
                  decoration:  InputDecoration(

                      hintText: p_ifsc_no),
                  onChanged: (val){
                    this.ifsc = val;

                  },

                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 25.0, right: 25.0, top: 25.0),
                child:

                new Text(
                  name_ac,
                    style: GoogleFonts.barlowCondensed(
                        textStyle:
                        Theme.of(context).textTheme.headline5,
                        fontSize:16,
                        fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 25.0, right: 25.0, top: 2.0),

                child: new TextField(
                    style: GoogleFonts.barlowCondensed(
                        textStyle:
                        Theme.of(context).textTheme.headline5,
                        fontSize:16,
                        fontWeight: FontWeight.bold),
                  decoration:  InputDecoration(
                      hintText: p_name),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (val){
                    //  this.email=val;
                    this.user_name = val;
                  },
                ),
              ),
              SizedBox(height: 10,),
              Center(child: InkWell(

                onTap: () {
                  if(accountNo==null || reaccountNo==null||ifsc==null || user_name ==null){
                    Fluttertoast.showToast(msg:enter_empty );
                  }
                  if (accountNo != reaccountNo){
                    Fluttertoast.showToast(msg: account_matching );
                  }
                  else{
                    CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.amber)) ;
                    showDialog(context: context,
                        builder: (BuildContext context){
                          return Center(child: CircularProgressIndicator(),);
                        });
                     loginAction();


                    DBRef.child("Users").child(uid).update({
                      'ac no': accountNo,
                      'acname' : user_name,
                      'ifsc' : ifsc
                    });

                    Navigator.of(context).pop();
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
                        widget.cls == "WalletPage()"? WalletPage():DashboardPage()), (Route<dynamic> route) => false);

                  }
                },
                child: Container(
                  width: 230,
                  padding: EdgeInsets.symmetric(vertical: 13),
                  alignment: Alignment.center,
                  color: Colors.green,
                  child: Text(
                    submit,

                      style: GoogleFonts.barlowCondensed(
                          textStyle:
                          Theme.of(context).textTheme.headline5,
                          fontSize:16,
                          fontWeight: FontWeight.bold)

                  ),
                ),
              ),),
              SizedBox(height: 10,),


            ],
          ),
        ),

      ),

    );


  }


  Future<bool> loginAction() async {
    //replace the below line of code with your login request
    await new Future.delayed(const Duration(seconds: 2));
    return true;
  }

}
