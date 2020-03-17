import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

import 'package:fruits_weather/bean/city.dart';
import 'package:fruits_weather/view/county_page.dart';

class CityPageWidget extends StatefulWidget {
  CityPageWidget({Key key, this.provinceID}) : super(key: key);

  //上一层的provinceID.
  final int provinceID;

  @override
  CityPageWidgetState createState() => CityPageWidgetState();
}

class CityPageWidgetState extends State<CityPageWidget> {

  //保存上一层得到的省份ID,并用于网络请求的参数.
  int _provinceID;

  //城市list,用于存储网络请求获得的数据.
  List<City> _cityList;

  //初始化并获取上一层得到的省份ID.
  @override
  void initState() {
    _provinceID = widget.provinceID;
    super.initState();
  }

  //绘制UI界面.
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: new ExactAssetImage('images/2.png'),
          fit: BoxFit.cover,
        ),
      ),

      child: _cityBody(),
    );
  }

  @override
  Widget _cityBody() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: new AppBar(
        centerTitle: true,
        title: Text(
          "城市",
          style: TextStyle(
              fontSize: 30.0,
          ),
        ),

        backgroundColor: Colors.transparent,
      ),

      //发送网络请求.
      body: FutureBuilder(
        future: Dio().get("http://guolin.tech/api/china/$_provinceID"),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Response response = snapshot.data;
            //发生错误
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            _cityList = getCityList(response.data);
            //请求成功，通过项目信息构建用于显示项目名称的ListView
            return ListView.builder(
              itemCount: _cityList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: ListTile(
                    title: Text(
                      "${_cityList[index].name}",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CountyPageWidget(
                        provinceID: _provinceID,
                        cityID: _cityList[index].id,
                      );
                    }));
                  },
                );
              },
            );
          }
          // 请求未完成时弹出loading
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
