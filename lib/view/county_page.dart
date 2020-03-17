import 'dart:async';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fruits_weather/model/model.dart';
import 'package:fruits_weather/model/db_helper.dart';
import 'package:fruits_weather/bean/county.dart';

import 'main_page.dart';

class CountyPageWidget extends StatefulWidget {
  final int provinceID;
  final int cityID;

  CountyPageWidget({Key key, this.provinceID, this.cityID}) : super(key: key);

  @override
  CountyPageWidgetState createState() => CountyPageWidgetState();
}

class CountyPageWidgetState extends State<CountyPageWidget> {

  //省份ID.
  int _provinceID;

  //城市ID.
  int _cityID;

  //创建县城列表.
  List<County> _county;

  ////创建一个CityName列表,用于保存选择的县城和县城ID.
  List<CityName> _datas = new List();

  //创建db.
  var db = DatabaseHelper();

  @override
  void initState() {

    //获取省级ID和市级ID.
    _provinceID = widget.provinceID;
    _cityID = widget.cityID;

    //获取数据库中的数据.
    _getDataFromDb();

    super.initState();
  }

  _getDataFromDb() async {

    //创建一个List.
    List datas = await db.getTotalList();
    if (datas.length > 0) {

      //数据库有数据
      datas.forEach((cityname) {
        CityName item = CityName.fromMap(cityname);
        _datas.add(item);
      });
    }
  }

  //保存城市ID,主页面会从本地存储拿城市ID,当从城市管理跳转到主页面时,主页会从数据库中拿.
  //节约时间空间.
  void _saveCityID(String cityID) async {

    //本地存储.
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("cityID", cityID);
  }

  //添加城市ID和城市名字至数据库中.
  Future<Null> _add(String cityName, String cityID) async {
    CityName city = new CityName();
    city.cityname = cityName;
    city.cityID = cityID;

    //保存数据到数据库中.
    await db.saveItem(city);
    _query();
  }

  //查询数据库.
  Future<Null> _query() async {
    _datas.clear();
    List datas = await db.getTotalList();
    if (datas.length > 0) {

      //数据库有数据.
      datas.forEach((city) {
        CityName dataListBean = CityName.fromMap(city);
        _datas.add(dataListBean);
      });
    }
  }

  //绘制UI界面.
  @override
  Widget build(BuildContext context) {
    return Container( //容器
      decoration: BoxDecoration(
        image: DecorationImage(
          image: new ExactAssetImage('images/3.png'),
          fit: BoxFit.cover,
        ),
      ),

      child: _countyBody(),
    );
  }

  @override
  Widget _countyBody() {
    return Scaffold(
      backgroundColor: Colors.transparent,

      appBar: new AppBar(
        centerTitle: true,
        title: Text(
          "区县",
          style: TextStyle(fontSize: 30.0),
        ),
        backgroundColor: Colors.transparent,
      ),

      //调用API.
      body: FutureBuilder(
        future: Dio().get("http://guolin.tech/api/china/$_provinceID/$_cityID"),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Response response = snapshot.data;

            //发生错误.
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            _county = getCountyList(response.data);

            //请求成功，通过项目信息构建用于显示项目名称的ListView.
            return ListView.builder(
              itemCount: _county.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: ListTile(
                    title: Text(
                        "${_county[index].name}",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                    ),
                  ),

                  onTap: () {

                    //数据库查重.
                    bool t = false;
                    _datas.forEach((item){
                      if(item.cityname == _county[index].name){
                        t = true;
                      }
                    });

                    //保存城市名和ID到数据库中.
                    if (t == false){_add(_county[index].name, _county[index].weatherId);}

                    //本地也存储城市ID.
                    _saveCityID(_county[index].weatherId);

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return MainPage(
                        cityID: _county[index].weatherId,
                      );
                    }));
                  },
                );
              },
            );
          }

          // 请求未完成时弹出loading.
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
