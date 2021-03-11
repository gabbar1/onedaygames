import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oneday/Model/user.dart';
import 'package:oneday/Model/wallet.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class AddMoney extends StatefulWidget {
  AddMoney({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AddMoneyPageState createState() => _AddMoneyPageState();
}

class _AddMoneyPageState extends State<AddMoney> {
  DatabaseReference transRef = FirebaseDatabase.instance.reference();
  int totalAmount = 0;
  Razorpay razorpay;
  String uid = '';
  String email;
  String name;
  int added_amount;
  int total_amount;
  int winning_amount;
  int total_amnt;
  int added_amnt;
  bool switch2 = true;
  String add_cash = "Add Cash";
  String current_balance = "Current Balance";
  String input_hint = "Please enter some amount";
  String add = "ADD ";

  @override
  void initState() {
    // TODO: implement initState

    this.uid = '';
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    this.uid = user.phoneNumber;
    transRef = FirebaseDatabase.instance.reference();

    var dbRef = FirebaseDatabase.instance.reference();
    dbRef.child("Users").child(uid).once().then((DataSnapshot snapshot){


          if(snapshot!= null){
            Map<dynamic, dynamic> values= snapshot.value;
            var user = User1.fromJson(values);

            if(this.mounted){
              setState(() {
                email =user.email;
                name = user.name;

              });
            }

          }

      });


    dbRef.child("Wallet").child(uid).once().then((DataSnapshot snapshot){


      if(snapshot!= null){
        Map<dynamic, dynamic> values= snapshot.value;
        var wallet = Wallet.fromJson(values);

        if(this.mounted){
          setState(() {
            total_amount =wallet.total_amount;

          });
        }

      }

    });






    super.initState();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerPaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razorpay.clear();
  }

  Future<String> getEmail() async {
    String email = (await FirebaseDatabase.instance.reference().child("Users").child(uid).child("email").once()).value;
    //String amount = (await FirebaseDatabase.instance.reference().child("Users").child(uid).child("Email").once()).value;
    print('HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH'+email);

  }
//
//  Future<String> getName() async {
//    String name = (await FirebaseDatabase.instance.reference().child("Users").child(uid).child("Name").once()).value;
//    print('HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH'+name);
//    return name;
//  }
//
   get_total_amount(int a) async {
    int  total_amount = (await FirebaseDatabase.instance.reference().child("Wallet").child(uid).child("total_amount").once()).value;
    int  added_amount = (await FirebaseDatabase.instance.reference().child("Wallet").child(uid).child("added_amount").once()).value;
    if(total_amount!=null) {
      total_amnt = total_amount + a;
    }else{
      total_amnt=a;
    }
    print('HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH'+name);
  }
   get_added_amount(int b) async {

    int  added_amount = (await FirebaseDatabase.instance.reference().child("Wallet").child(uid).child("added_amount").once()).value;
    if(added_amount!=null) {
      added_amnt = added_amount + b;
    }else{
      added_amnt=b;
    }
    print('HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH'+name);
  }


  void openCheckOut() async {
   //String email1 =  getEmail().toString();
    if(totalAmount==0){
      Fluttertoast.showToast(msg: "Please enter valid amount");

    }
    else{
      String email1 = (await FirebaseDatabase.instance.reference().child("Users").child(uid).child("email").once()).value;
      print("bosssssssss"+email1);
      var options = {
        'key': 'rzp_test_Wm3siaTI62GYT8',
        'amount': totalAmount * 100,
        'name': name,
        'description': "Let's Win",
        'prefill': {'contact':uid,'email': email1},
        'external': {
          'wallets': ['paytm']
        }
      };
      try {
        razorpay.open(options);
      } catch (e) {
        debugPrint(e);
      }

    }

  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(add_cash,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize: 20,fontWeight: FontWeight.bold)),),
      body: Column(children: [
        Container(
          height: 60,color: Colors.white,
          width: queryData.size.width,
          child: Row(children: [  SizedBox(width: 20,)  ,  CircleAvatar(radius: 20, child:Image.asset("assets/icons/wallet.png")),SizedBox(width: 10,),Text(current_balance,style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),SizedBox(width: queryData.size.width/2.4,),Text("₹ "+total_amount.toString(),style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold))],),
        ),
        SizedBox(height: 20,),
        Container(
          height: 100,color: Colors.white,
          width: queryData.size.width,
          child: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly
            ],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText:input_hint,border: OutlineInputBorder()),
            onChanged: (value) {
              setState(() {
                Future<DataSnapshot> email1 = ( FirebaseDatabase.instance.reference().child("Wallet").child(uid).child("added_amount").once());
                print(email1);
                totalAmount = num.parse(value);
                get_added_amount(totalAmount);
                get_total_amount(totalAmount);
              });
            },
          ),
        ),
        SizedBox(height: 20,),
        Spacer(),

        Container(
          height: 60,color: Colors.white,
          width: queryData.size.width,
          child: FlatButton(child: Text(add+totalAmount.toString(),style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),color: Colors.green,onPressed: (){
            openCheckOut();
          },),
        )
      ],)

    );
  }

  void handlerPaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: 'Success: ' + totalAmount.toString());
    var now = new DateTime.now();
    final DBRef = FirebaseDatabase.instance.reference();
    DBRef.child("Wallet").child(uid).update({
      'name':name,
      'email':email,
      'total_amount':total_amnt,
      'added_amount':added_amnt,
      'time':DateFormat('EEEE, d MMM, yyyy,h:mm:ss a').format(now),
    });
    //  `Fluttertoast.showToast(msg: 'Success: ' + response.orderId);
    print(name);
    print(email);
    print(total_amnt);
    print(added_amnt);

    var nowT = new DateTime.now();
    final DBRefT = FirebaseDatabase.instance.reference().child("User_Transaction").child(uid);
    DBRefT.push().update({
      'name':name,
      'email':email,
      'amount':totalAmount,
      'time':DateFormat('EEEE, d MMM, yyyy,h:mm:ss a').format(nowT),
      'status':'Y'
    });
     Navigator.pop(context);
  }

  void handlerPaymentError(PaymentFailureResponse response) {


 /*   Fluttertoast.showToast(
        msg: 'Failure: ' + response.code.toString() + " - " + response.message);*/
    Fluttertoast.showToast(msg: response.message.toString());
    var nowT = new DateTime.now();

    if(response.message!="Payment Cancelled"){
      final DBRefT = FirebaseDatabase.instance.reference().child("User_Transaction").child(uid);
      DBRefT.push().update({
        'name':name,
        'email':email,
        'amount':totalAmount,
        'time': DateFormat('EEEE, d MMM, yyyy,h:mm:ss a').format(nowT),
        'status':'N'
      });

      Navigator.pop(context);
    }


  }

  void handlerExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: 'External Wallet: ' + response.walletName);
    Navigator.pop(context);
  }
}