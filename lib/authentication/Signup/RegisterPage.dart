import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oneday/Language/Language.dart';
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
    var language = Provider.of<Language>(context, listen: false);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xffF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(language.regmsg,style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,)),
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
    var language = Provider.of<Language>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Form(autovalidate: _autoValidate, key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Name', style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,),
              ),
              TextFormField(
                validator: validateName,
                decoration: const InputDecoration(
                    hintText: "Enter Name"),
                  style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline6,),
                onChanged: (val){
                  register.name = val;
                },
              ),
              SizedBox(height: 16,),
              Text(language.phnno, style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,),),
              TextFormField(
                validator: validateMobile,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                maxLength: 10,
                decoration: const InputDecoration(
                  hintText: "Enter Mobile Number"),
                style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline6,),
                keyboardType: TextInputType.phone,
                onChanged: (val) {
                  register.phoneNo = "+91"+(val);
                },
              ),
              SizedBox(height: 16,),
              Text('Email', style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,)),
              TextFormField(
                validator: validateEmail,
                decoration: const InputDecoration(
                    hintText: "Enter Email ID"),
                style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline6,),
                keyboardType: TextInputType.emailAddress,
                onChanged: (val){
                  register.email = val;
                },
              ),
              SizedBox(height: 30,),
              SizedBox(width: double.infinity,
                child: RaisedButton(color: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 13),

                  child: Text(language.register, style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,),),
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