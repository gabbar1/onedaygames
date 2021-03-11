import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oneday/Winner/Winners.dart';
import 'package:oneday/Language/Language.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
class HowtoPlay extends StatefulWidget {
  @override
  _HowtoPlayState createState() => _HowtoPlayState();
}

class _HowtoPlayState extends State<HowtoPlay> {
  WebViewController _controller;
  @override
  Widget build(BuildContext context) {

    var language = Provider.of<Language>(context, listen: false);
    return  Scaffold(
        appBar: AppBar(title: Text(language.howtoplay),),
        body: WebView(
          initialUrl:  'about:blank',
          onWebViewCreated : (WebViewController webViewController) {
            _controller = webViewController;
            _loadHtmlFromAssets();
          },
        )

    );
  }
  _loadHtmlFromAssets() async {
    var language = Provider.of<Language>(context, listen: false);
    String fileText;
    if(language.status2){
      fileText = await rootBundle.loadString('assets/files/howToPlayEng.html');
    }
    else{
      fileText = await rootBundle.loadString('assets/files/howToPlayHindi.html');
    }

    _controller.loadUrl( Uri.dataFromString(
        fileText,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8')
    ).toString());
  }
}
