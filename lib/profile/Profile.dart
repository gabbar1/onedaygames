import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oneday/Language/Language.dart';
import 'package:oneday/screen/StartPage.dart';
import 'package:oneday/wallet/walletPageView.dart';
import 'package:oneday/services/authservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oneday/dashBoard/API.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../screen/app_properties.dart';

class Profile extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<Profile>
    with SingleTickerProviderStateMixin {
  DatabaseReference transRef = FirebaseDatabase.instance.reference();
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _pinCode = TextEditingController();
  TextEditingController _state = TextEditingController();
  static String uid = '';

  String name;
  String email;
  String pin;
  String state;
  String urlpath;
  String imageurl;
  bool _visible = false;

  void afterBuildFunction(BuildContext context) {
    var vm = Provider.of<API>(context, listen: false);

    _nameController.text = vm.username;
    _emailController.text = vm.email;
    _pinCode.text = vm.pincode;
    _state.text = vm.state;
  }

  RefreshController refreshController;
  @override
  void initState() {
    super.initState();
    refreshController = RefreshController(initialRefresh: true);
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    uid = user.phoneNumber;
    Provider.of<API>(context, listen: false).userDetail(uid);
    Provider.of<Language>(context, listen: false).getLanguage(uid);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => afterBuildFunction(context));
  }

  final DBRef = FirebaseDatabase.instance.reference();
  File _image;
  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 40,
    );
    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future uploadPic(BuildContext context1) async {
    var language = Provider.of<Language>(context, listen: false);
    StorageReference firebaseStorage =
        FirebaseStorage.instance.ref().child(uid);
    StorageUploadTask uploadTask = firebaseStorage.child(uid).putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    DBRef.child("Users").child(uid).update({
      'profile': downloadUrl,
    });
    print(uid);
    if (mounted) {
      setState(() {
        print("Uploaded");
        print(downloadUrl);
        imageurl = downloadUrl;
        print(imageurl);
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(language.profileupdated,
              style: GoogleFonts.barlowCondensed(
                  textStyle: Theme.of(context).textTheme.headline5,
                  fontSize: 10,
                  fontWeight: FontWeight.bold)),backgroundColor: Colors.amber,
        ));

      });
    }
  }

  sendData() {
    print(uid);
    DBRef.child("Users").child(uid).update({
      'name': '${name ?? _nameController.text}',
      'email': '${email ?? _emailController.text}',
      'pincode': '${pin ?? _pinCode.text}',
      'state': '${state ?? _state.text}'
    });
  }

  walletData() {
    print(uid);
    DBRef.child("Wallet").child(uid).update({
      'phone': uid,
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _pinCode.dispose();
    _state.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _profileKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var language = Provider.of<Language>(context, listen: false);
    //  var vm = Provider.of<API>(context, listen: false);
    //   print("---------------name----------------------"+vm.username);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.amber,
        title: Text(language.profile,
            style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline4,)),
      ),
      body: Consumer<API>(
        builder: (context, vm, child) {
          return SmartRefresher(
              controller: refreshController,
              onRefresh: () {
                refreshController.refreshCompleted();
                Provider.of<API>(context, listen: false).userDetail(uid);
                //   print("---------------ndfsdfddfddame----------------------"+vm.username);
                print(uid);
              },
              child: ListView(
                padding: EdgeInsets.only(bottom: 50),
                children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      color: Colors.amber,
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
                          _profile(),
                          Visibility(
                            child: RaisedButton(
                              child: Text(language.upload,
                                  style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:15, fontWeight: FontWeight.bold)),
                              color: Colors.yellow[600],
                              onPressed: () {
                                _visible = false;
                                uploadPic(context)
                                    .then((value) => {vm.userDetail(uid)});
                              },
                            ),
                            visible: _visible,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              vm.username == null ? "My Name" : vm.username,
                              style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:30, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )),
                  SingleChildScrollView(
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
                                color: transparentYellow,
                                blurRadius: 4,
                                spreadRadius: 1,
                                offset: Offset(0, 1)),
                          ]),
                      child: Center(child: _userdetails()),
                    ),
                  )
                ],
              ));
        },
      ),
    );
  }

  Widget _userdetails() {
    var language = Provider.of<Language>(context, listen: false);
    var vm = Provider.of<API>(context, listen: false);
    if (_status == true) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 15),
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(4)),
                color: Colors.amber,
                boxShadow: [
                  BoxShadow(
                      color: transparentYellow,
                      blurRadius: 2,
                      spreadRadius: 0.5,
                      offset: Offset(0, 1)),
                ]),
            height: 85,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(width: 40,),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => WalletPage()),
                      );
                    },
                    child: Container(


                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 30,
                            width: 30,
                            child: SvgPicture.asset("assets/icons/wallet.svg"),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(language.wallet,
                              style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:20, fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  InkWell(onTap: () {
                    AuthService().signOut();
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StartPage()),
                              (Route<dynamic> route) => false);
                    });
                  },
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 30,
                          width: 30,
                          child: SvgPicture.asset("assets/icons/logout.svg"),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(language.logout,
                            style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Spacer(),
                  SizedBox(width: 20,),
                  InkWell(onTap: () {
                    setState(() {
                      _status = false;
                    });
                  },
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 30,
                          width: 30,
                          child: SvgPicture.asset("assets/icons/edit.svg"),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(language.Edit,
                            style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:20, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  SizedBox(width: 50,)
                ],
              ),
            ),
          ),
          ListTile(
            title: Text(language.Email,  style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:20, fontWeight: FontWeight.bold)),
            subtitle: Text(
              vm.email == null ? "My Email" : vm.email,
              style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:18, ),
            ),
            leading: Icon(Icons.email),
          ),
          Divider(),
          ListTile(
            title: Text(language.phone,
                 style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:20, fontWeight: FontWeight.bold)),
            subtitle: new Text(uid,
                style: GoogleFonts.barlowCondensed(
                  textStyle: Theme.of(context).textTheme.headline5,
                  fontSize: 18,
                )),
            leading: Icon(Icons.phone),
          ),
          Divider(),
          ListTile(
            title: Text(language.stt,
                 style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:20, fontWeight: FontWeight.bold)),
            subtitle: Text(vm.state == null ? "My State" : vm.state, style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:18, ),),
            leading: Icon(Icons.location_city),
          ),
          Divider(),
          ListTile(
            title: Text(language.pinc,
                 style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:20, fontWeight: FontWeight.bold)),
            subtitle: new Text(vm.pincode == null ? "my Pincode" : vm.pincode, style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:18, ),),
            leading: Icon(Icons.pin_drop),
          ),
        ],
      );
    } else {
      return  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding:
                  EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
              child: Text(language.namep,
                style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:22,fontWeight: FontWeight.bold ),)),
          Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 8.0),
              child: new TextFormField(
                style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:20 ),
                controller: _nameController,
                decoration: InputDecoration(hintText: language.enamep),
                onChanged: (val) {
                  this.name = val;
                },
                enabled: !_status,
              )),
          Padding(
              padding:
                  EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
              child: Text(
                language.Email,
                  style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:22,fontWeight: FontWeight.bold )
              )),
          Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
              child: new TextField(
                style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:20),
                controller: _emailController,
                decoration: InputDecoration(hintText: language.eEmail),
                onChanged: (val) {
                  this.email = val;
                },
                enabled: !_status,
              )),
          Padding(
            padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
            child: Text(
              language.phone,
               style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:22, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 20),
            child: new Text(
              uid,
              style: GoogleFonts.barlowCondensed(
                textStyle: Theme.of(context).textTheme.headline5,
                fontSize: 20,
              ),
            ),
          ),
          Padding(
              padding:
                  EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
              child: new Row(

                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: new Text(
                      language.pinc,
                        style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:22,fontWeight: FontWeight.bold )
                    ),
                  ),
                  Spacer(),
                  Container(
                    child: new Text(
                      language.stt,
                        style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:22,fontWeight: FontWeight.bold )
                    ),
                  ),
                  SizedBox(width: 123,)
                ],
              )),
          Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: new TextField(
                        style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:20 ),
                        controller: _pinCode,
                        decoration:
                            InputDecoration(hintText: language.epinc),
                        onChanged: (val) {
                          this.pin = val;
                        },
                        enabled: !_status,
                      ),
                    ),
                    flex: 2,
                  ),
                  Flexible(
                    child: new TextField(
                      style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:20 ),
                      controller: _state,
                      decoration:
                          InputDecoration(hintText: language.estt),
                      onChanged: (val) {
                        this.state = val;
                      },
                      enabled: !_status,
                    ),
                    flex: 2,
                  ),
                ],
              )),
          !_status ? _getActionButtons() : new Container(),
        ],
      );
    }
  }

  Widget _profile() {
    var language = Provider.of<Language>(context, listen: false);
    var vm = Provider.of<API>(context, listen: false);
    return InkWell(
      child: CircleAvatar(
        radius: 55,
        backgroundColor: Color(0xffFDCF09),
        child: CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(vm.userprofile == null
                ? "https://static.toiimg.com/photo/72975551.cms"
                : vm.userprofile)),
      ),
      onTap: () {
        getImage();
        _visible = true;
      },
    );
  }

  Widget _getActionButtons() {
    var language = Provider.of<Language>(context, listen: false);
    var vm = Provider.of<API>(context, listen: false);
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text(language.save,
                  style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:20 ),),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  setState(() {
                    _status = true;
                  });
                  sendData();
                  vm.userDetail(uid);
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text(language.cancel,
                  style: GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline5,fontSize:20 ),),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                  });
                  // FocusScope.of(context).requestFocus(new FocusNode());
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }
}
