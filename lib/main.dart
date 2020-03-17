import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'view/main_page.dart';
import 'view/provinces_page.dart';

//程序入口.
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

  //定义一个cityID接收county_page界面得到的countryID.
  String _cityID;

  @override
  //初始化.
  void initState() {
    _readCounter();

    //调用超类需要用super.
    super.initState();
  }

  void _readCounter() async {

    //等待耗时操作的返回结果.
    //数据存储SharedPreferences,可实现增删改查.
    SharedPreferences preferences = await SharedPreferences.getInstance();

    //获得county_page界面传来的countryID.
    String cityID = preferences.getString("cityID");

    //传入参数,刷新UI视图.
    setState(() {
      _cityID = cityID;
    });
  }

  //搭建UI视图.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '水果天气',

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      //判断有无,无则去Province_Page界面开始选择城市,有则去main_page修改主界面城市.
      home: _cityID == null
          ? ProvincesPageWidget()
          : MainPage(
              //将cityID传入main_page.
              cityID: _cityID,
            ),
    );
  }
}
