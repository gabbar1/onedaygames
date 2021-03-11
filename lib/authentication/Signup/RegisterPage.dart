import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oneday/authentication/Signup/RegisterProvider.dart';
import 'package:oneday/utils/validator.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<RegisterPage>
    with SingleTickerProviderStateMixin, Validator {
  bool _autoValidate = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xffF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Register & win",style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0,top:10),
          child: Container(
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
                child: _phoneDetails()
            ),
          ),
        ),
      ),
    );
  }

  Widget _phoneDetails() {
    var register = Provider.of<RegisterProvider>(context,listen: false);
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Form(autovalidate: _autoValidate, key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Name', style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
              ),
              TextFormField(
                validator: validateName,
                decoration: const InputDecoration(
                    hintText: "Enter Name"),
                onChanged: (val){
                  register.name = val;
                },
              ),
              SizedBox(height: 16,),
              Text("Phone", style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
              TextFormField(
                validator: validateMobile,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  hintText: "Enter Mobile Number"),
                keyboardType: TextInputType.phone,
                onChanged: (val) {
                  register.phoneNo = "+91"+(val);
                },
              ),
              SizedBox(height: 16,),
              Text('Email', style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
              TextFormField(
                validator: validateEmail,
                decoration: const InputDecoration(
                    hintText: "Enter Email ID"),
                keyboardType: TextInputType.emailAddress,
                onChanged: (val){
                  register.email = val;
                },
              ),
              SizedBox(height: 16,),
              SizedBox(width: double.infinity,
                child: RaisedButton(color: Colors.green,
                  child: Text('Register', style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      register.checkUserDetails(context: context,scaffoldKey: _scaffoldKey);
                    }
                  }),
              ),
            ],
          ),
      ),
    );
  }



}