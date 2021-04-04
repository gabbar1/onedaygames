import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

smartRefresh({RefreshController refreshController,Function onRefresh,Widget container}){
  return SmartRefresher(
      enablePullDown: true,
      header: (Platform.isIOS) ? WaterDropHeader() : WaterDropMaterialHeader(),
      controller: refreshController,
      onRefresh: () {
        onRefresh();
      },
      child: container);
}



