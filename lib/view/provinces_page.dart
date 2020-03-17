import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

import 'package:fruits_weather/bean/province.dart';

import 'city_page.dart';

class ProvincesPageWidget extends StatefulWidget {
  ProvincesPageWidget({Key key}) : super(key: key);

  @override
  ProvincesPageStateWidget createState() => new ProvincesPageStateWidget();
}

class ProvincesPageStateWidget extends State<ProvincesPageWidget> {

  //定义一个省份list,将请求到的数据存入省份list里.
  List<Province> provinceList;

  //绘制UI界面.
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(

        //背景图片.
        image: DecorationImage(
          image: new ExactAssetImage('images/1.png'),
          fit: BoxFit.cover,
        ),
      ),

      child: _provincesBody(),
    );
  }

  Widget _provincesBody() {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: new AppBar(
          centerTitle: true,

          title: Text(
            "省份",
            style: TextStyle(
                fontSize: 30.0,
            ),
          ),

          backgroundColor: Colors.transparent,
        ),

        //网络请求
        body: FutureBuilder(
          future: Dio().get("http://guolin.tech/api/china"),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Response response = snapshot.data;
              //发生错误
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              provinceList = getProvinceList(response.data);

              //请求成功，通过项目信息构建用于显示项目名称的ListView.
              return ListView.builder(
                itemCount: provinceList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: ListTile(
                      title: Text(
                          "${provinceList[index].name}",
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                          ),
                      ),
                    ),

                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CityPageWidget(

                          //给下一页的citypage传入provinceID.
                          provinceID: provinceList[index].id,
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
        ));
  }
}
