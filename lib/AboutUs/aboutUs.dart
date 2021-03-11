
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oneday/Language/Language.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  WebViewController _controller;
  @override
  Widget build(BuildContext context) {
    var language = Provider.of<Language>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(language.aboutUs),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child:  Column(children: [Container(padding: EdgeInsets.all(10),child: Image.asset("assets/images/oneday.png"),),
         Expanded(child:  WebView(
           initialUrl:  'about:blank',
           onWebViewCreated : (WebViewController webViewController) {
             _controller = webViewController;
             _loadHtmlFromAssets();
           },
         ),)
        ],),)

    );
  }
  _loadHtmlFromAssets() async {
    var language = Provider.of<Language>(context, listen: false);
    String fileText;
    if(language.status2){
      fileText = await rootBundle.loadString('assets/files/aboutUsEng.html');
    }
    else{
      fileText = await rootBundle.loadString('assets/files/aboutUsHindi.html');
    }

    _controller.loadUrl( Uri.dataFromString(
        fileText,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8')
    ).toString());
  }
}
