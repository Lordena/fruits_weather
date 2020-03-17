import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

import 'package:fruits_weather/bean/now_weather.dart';
import 'package:fruits_weather/bean/forecast_weather.dart';
import 'package:fruits_weather/view/provinces_page.dart';

import 'city_manage.dart';

class MainPage extends StatefulWidget {

  //定义cityID.
  final String cityID;

  //传入cityID.
  MainPage({Key key, this.cityID}) : super(key: key);

  @override
  MainPageState createState() => new MainPageState();
}

class MainPageState extends State<MainPage> {

  //城市ID.
  String _cityID;
  //当天天气.
  NowWeather _nowWeather;
  //七日天气.
  ForecastWeather _forecastWeather;

  //和风天气申请的一个key,注册并升级成为个人开发者可有每日16700次访问量.
  final String key = "2d683f2bc09a429d9c959eeef4552cfc";

  //切换页面时，子页面每次均会重新  initState  一次，导致每次都切换页面均会重绘.
  @override
  void initState() {
    //得到main.dart里的cityID.
    _cityID = widget.cityID;
    super.initState();
  }

  //UI入口.
  @override
  Widget build(BuildContext context) {

    //设置容器.
    return Container(
      decoration: BoxDecoration(

        //设置背景图片.
        image: DecorationImage(
          image: new ExactAssetImage('images/main_page.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: _weatherBody(),
    );
  }

  //父类为build.
  Widget _weatherBody() {
    return FutureBuilder(

      //通过API请求天气数据.
      future: Dio().get(
          "https://free-api.heweather.net/s6/weather/now?location=$_cityID&key=$key"),

      //获取当前城市ID的天气.
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        //连接状态连接成功.
        if (snapshot.connectionState == ConnectionState.done) {
          Response response = snapshot.data;

          //发生错误.
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          //格式转换.
          _nowWeather = NowWeather.fromJson(response.data);

          //请求成功，通过项目信息构建用于显示项目名称的ListView.
          return Scaffold(

            //背景颜色透明,这样才能看到上面设置的背景图片.
            backgroundColor: Colors.transparent,

            //导航栏.
            appBar: AppBar(
              leading: new GestureDetector(
                child: Icon(

                  //设置菜单添加键.
                  Icons.playlist_add,
                  size: 30.0,
                ),

                //按键触发事件,按home键跳转到下一个路由.
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {

                    //跳转至city_manage城市管理界面.
                    return CityManagePageWidget();
                  }));
                },
              ),

              //标题居中.
              centerTitle: true,

              //标题内容.
              title: Text(

                //获取所得的数据的地名.
                "${_nowWeather.heWeather6[0].basic.location}",
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w500,
                ),
              ),

              //导航栏背景颜色透明.
              backgroundColor: Colors.transparent,
            ),

            body: _nowWeather == null
                ? Text("正在加载")
                : SingleChildScrollView( //滚动视图布局.

                  //竖直排列.
                    child: Column(
                      children: <Widget>[

                        //显示温度.
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            " ${_nowWeather.heWeather6[0].now.tmp}°C",
                            style: TextStyle(
                              fontSize: 90.0,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        //显示晴雨.
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "        ${_nowWeather.heWeather6[0].now.condTxt}", //显示晴雨
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        //显示空气质量.
                        Padding(
                          padding: EdgeInsets.only(
                            top: 400.0,
                            left: 15.0,
                            right: 15.0,
                          ),
                          child: Container(
                            color: Colors.transparent,
                            child: _atmosphereList(),
                          ),
                        ),

                        //显示未来七天天气预报.
                        Padding(
                          padding: EdgeInsets.only(
                             top: 120.0,
                            left: 15.0,
                            right: 15.0,
                            bottom: 15.0,
                          ),
                          child: Container(
                            color: Colors.black38,
                            child: _weatherList(),
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        }

        // 请求未完成时弹出loading.
        return Scaffold(
          backgroundColor: Colors.transparent,

          appBar: AppBar(
            leading: new GestureDetector(
              child: Icon(
                Icons.playlist_add,
                size: 30.0,
              ),

              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ProvincesPageWidget();
                }));
              },
            ),

            centerTitle: true,

            //圆形加载进度条.
            title: CircularProgressIndicator(),

            backgroundColor: Colors.transparent,
          ),
        );
      },
    );
  }

  //空气质量.
  Widget _atmosphereList() {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.center,

          child: Text(
            "空气质量",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ),

        GridView(
          shrinkWrap: true,

          //不可滚动.
          physics: NeverScrollableScrollPhysics(),

          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

              //横轴三个子widget.
              crossAxisCount: 2,

              //显示区域宽高相等.
              childAspectRatio: 2
          ),

          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "${_nowWeather.heWeather6[0].now.vis}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                  ),
                ), //能见度

                Text(
                  "能见度",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ), //能见度

            Column(
              children: <Widget>[
                Text(
                  "${_nowWeather.heWeather6[0].now.hum}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                  ),
                ),

                Text(
                  "湿度",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ), //湿度
          ],
        )
      ],
    );
  }

  //七日天气.
  Widget _weatherList() {
    return Column(children: <Widget>[
      FutureBuilder(
        future: Dio().get(
            "https://free-api.heweather.net/s6/weather/forecast?location=$_cityID&key=$key"),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Response response = snapshot.data;
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            //数据给到_forecastWeather.
            _forecastWeather = ForecastWeather.fromJson(response.data);

            //请求成功，通过项目信息构建用于显示项目名称的ListView.
            return ListView.builder(
                shrinkWrap: true,

                //不允许滚动下拉.
                physics: NeverScrollableScrollPhysics(),

                //获取List长度.
                itemCount: _forecastWeather.heWeather6[0].dailyForecast.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(

                    //横向排列.
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[

                        //日期.
                        Text(
                          "${_forecastWeather.heWeather6[0].dailyForecast[index]
                              .date}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                          ),
                        ),

                        //晴雨.
                        Text(
                          "${_forecastWeather.heWeather6[0].dailyForecast[index]
                              .condTxtD}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                          ),
                        ),

                        //温度.
                        Text(
                          "${_forecastWeather.heWeather6[0].dailyForecast[index]
                              .tmpMax}°/${_forecastWeather.heWeather6[0]
                              .dailyForecast[index].tmpMin}°",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                          ),
                        ),
                      ],
                    ),
                  );
                });
          }

          // 请求未完成时弹出loading.
          //圆形加载进度条.
          return CircularProgressIndicator();
        },
      ),
    ]);
  }
}
