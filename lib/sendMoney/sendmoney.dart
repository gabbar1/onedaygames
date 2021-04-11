import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oneday/Model/user.dart';
import 'package:oneday/Language/Language.dart';
import 'package:oneday/sendMoney/sendMoneyProvider.dart';
import 'package:provider/provider.dart';


class SendMoney  extends StatefulWidget{
  @override
  _SendMoneyPageState createState() =>_SendMoneyPageState();
}

class _SendMoneyPageState  extends State<SendMoney>{

  DatabaseReference transRef = FirebaseDatabase.instance.reference();

  String uid="" ;
  String Amount ;
  static String phonenum ;
  String user_phone;
  String phone;
  String userprofile,userprofile1;
  String username,username1;
  String amount;
  String sender_amount;
  String sending_amount;
  bool _showTickets = false;


  @override
  void initState() {
    super.initState();
    this.uid="" ;
    // this.phonenum ;
    final FirebaseAuth auth = FirebaseAuth.instance;
    Provider.of<SendMoneyProvider>(context,listen: false).getSentDetails();
    final User user = auth.currentUser;
    this.uid = user.phoneNumber;
    phonenum= user.phoneNumber;
    transRef = FirebaseDatabase.instance.reference();
    Provider.of<SendMoneyProvider>(context,listen: false).getDetails(senderPhone: uid);
    Provider.of<Language>(context,listen:false).getLanguage(uid);

  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var sendVm = Provider.of<SendMoneyProvider>(context,listen:false);
    sendVm.getDetails(senderPhone: uid);
    var language = Provider.of<Language>(context,listen:false);
    return  Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          title: TextField(
            decoration:  InputDecoration(
                border: InputBorder.none,
                hintText: language.search),
            keyboardType: TextInputType.phone,
            autocorrect: true,
            onChanged: (val){
              if(val != uid){
                sendVm.receiversPhone(rPhone: val,sPhone: uid);
              }

            },),
          actions: [
            IconButton(icon: Icon(Icons.search),
                onPressed: (){

              if(sendVm.receiverPhone==null || sendVm.receiverPhone == uid.replaceAll("+91", "")){
                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(language.user_nt_found,style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),backgroundColor: Colors.amber,));
              }{
                print("-------------"+sendVm.receiverPhone);
                sendVm.receiversPhone(rPhone:sendVm.receiverPhone,sPhone: uid);
                sendVm.getUserInput();
                print("-------------------"+sendVm.receiverPhone);
              }

                }),
          ],
        ),
        body: Consumer<SendMoneyProvider>(builder: (context,sendMoney,child){
          return sendMoney.receiverPhone == null ?
              ListView.builder(itemCount: sendMoney.recieverList.length,itemBuilder: (context,snap){
               // sendMoney.getSearchedUser(senderPhone: "+91"+sendMoney.recieverList[snap].phone);
                return InkWell(
                  onTap: (){
                    print(sendMoney.recieverList[snap].phone);
                    sendMoney.getSentUserDetails(context: context,senderPhone: uid,scaffoldKey: _scaffoldKey,receiverPhone:sendMoney.recieverList[snap].phone );
                  //  sendMoney.sendMoneyPrevious(scaffoldKey: _scaffoldKey,senderPhone: uid,recieverPhone:  "+91"+sendMoney.recieverList[snap].phone,context: context);
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0,),
                    child :  Padding(padding: EdgeInsets.all(10),
                  child : Row(
                    children: <Widget>[
                      Row(crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(children: [
                            CircleAvatar(radius: 20,
                                backgroundImage: sendMoney.recieverList[snap].profile==null ? NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFDjXj1F8Ix-rRFgY_r3GerDoQwfiOMXVt-tZdv_Mcou_yIlUC&s"): NetworkImage(sendMoney.recieverList[snap].profile)
                            ),
                            SizedBox(width: 20,),
                            Text((sendMoney.recieverList[snap].phone==null ? "  "+language.user_nt_found: sendMoney.recieverList[snap].phone),
                                style : TextStyle(fontSize: 15.0,
                                    fontWeight:FontWeight.bold,color: Colors.black )),],),
                        ],),
                    ],
                  ),
                ),
                  ),
                );
              })
          /*FirebaseAnimatedList(
            query:transRef.child('Sent_money'),
            reverse: false,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (BuildContext context,DataSnapshot snapshot,Animation<double>animation,int index){
              Map transaction =snapshot.value;

              return
                InkWell(
                  onTap: (){
                    sendMoney.getSearchedUser(senderPhone: "+91"+transaction["phone"]);
                    sendMoney.sendMoneyPrevious(scaffoldKey: _scaffoldKey,senderPhone: uid,recieverPhone: "+91"+transaction["phone"],context: context);
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0,),
                    child :_buildTransactionItem(transaction : transaction),color: Colors.white,
                  ),
                );
            } ,
          )*/ : _menuHeader();
        },)

    );
  }



  Widget _menuHeader() {
    var sendVm = Provider.of<SendMoneyProvider>(context,listen:false);
    var language = Provider.of<Language>(context,listen:false);
    sendVm.getUserInput();
    sendVm.getDetails(senderPhone: uid);

    return
      InkWell(child:
      Consumer<SendMoneyProvider>(builder: (context,send,child){
        return Card(
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0,),
          child:
          Padding(
            padding: EdgeInsets.all(10),
            child : Row(
              children: <Widget>[
                Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(children: [
                      CircleAvatar(
                          radius: 20,
                          backgroundImage: send.userprofile==null ? NetworkImage("https://cdn2.iconfinder.com/data/icons/delivery-and-logistic/64/Not_found_the_recipient-no_found-person-user-search-searching-4-512.png"): NetworkImage(send.userprofile)
                      ),
                      SizedBox(width: 20,),
                      Text(( send.username==null ? "  "+language.user_nt_found: send.username),
                          style : TextStyle(fontSize: 15.0,
                              fontWeight:FontWeight.bold,color: Colors.black )),],)
                  ],),
              ],
            ),

          ),);
      },),
        onTap: (){

         var sendVM = Provider.of<SendMoneyProvider>(context,listen: false);
         sendVM.sendMoney(context: context,recieverPhone: sendVM.receiverPhone,senderPhone: uid,scaffoldKey: _scaffoldKey,userNames: sendVm.userName);
         sendVM.getWalletDetails(senderPhone: uid,recPhone: sendVM.receiverPhone);
           // Navigator.pop(context);

        },);


  }



}