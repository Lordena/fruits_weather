import 'dart:async';


import 'package:flutter/material.dart';

import 'package:fruits_weather/model/model.dart';
import 'package:fruits_weather/model/db_helper.dart';
import 'package:fruits_weather/view/provinces_page.dart';



import 'main_page.dart';


class CityManagePageWidget extends StatefulWidget {
  CityManagePageWidget({Key key}) : super(key: key);

  @override
  CityManagePageStateWidget createState() => new CityManagePageStateWidget();
}

class CityManagePageStateWidget extends State<CityManagePageWidget> {

  //创建一个CityName列表.
  List<CityName> _datas = new List();

  //创建db.
  var db = DatabaseHelper();

  //初始化.
  @override
  void initState() {
    _getDataFromDb();
    super.initState();
  }

  //从数据库中获取数据.
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

    //告诉界面要刷新一下.
    setState(() {});
  }

  //删除城市.
  Future<Null> _delete(int id) async {
    List datas = await db.getTotalList();
    if (datas.length > 0) {

      //修改指定城市数据
      CityName user = CityName.fromMap(datas[id]);
      db.deleteItem(user.id);
      _query();
    }
  }

  //查询所有城市.
  Future<Null> _query() async {
    _datas.clear();
    List datas = await db.getTotalList();
    if (datas.length > 0) {

      //数据库有数据.
      datas.forEach((cityname) {
        CityName dataListBean = CityName.fromMap(cityname);
        _datas.add(dataListBean);
      });
    }

    //更新界面.
    setState(() {});
  }

  //构建UI界面.
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(

        //设置背景图片.
        image: DecorationImage(
          image: new ExactAssetImage('images/city_manage.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: _citymanageBody(),
    );
  }


  Widget _citymanageBody() {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: new AppBar(
          leading: new GestureDetector(
            child: Icon( //home键
              Icons.arrow_back,
              color: Colors.white,
            ),

            //返回键返回上一页,即主页.
            onTap: () {
              Navigator.pop(context, MaterialPageRoute(builder: (context) {
                return MainPage();
              }));
            },
          ),

          backgroundColor: Colors.transparent,

          title: Text(
              "城市管理",
              style: TextStyle(
                fontSize: 25.0,
              )
          ),

          centerTitle: true,

        ),

        //右下角浮动按钮,按键跳转城市选择界面.
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange,

          child: Icon(
              Icons.add,
              color: Colors.white,
              size: 40.0,
          ),

          //按键触发事件.
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ProvincesPageWidget();
            }));
          },
        ),

        //有则显示,无则不显示.
        body: _datas.length != null
            ? ListView.builder(
                 itemCount: _datas.length,
                 itemBuilder: (context, index) {
                   final item = _datas[index].cityID;

                   return Dismissible(

                       // 每个Dismissible实例都必须包含一个Key。Key让Flutter能够对Widgets做唯一标识.
                       key: Key(item),

                       // 我们还需要提供一个函数，告诉应用，在项目被移出后，要做什么.
                       onDismissed: (direction) {

                         // 从数据源中移除项目.
                         //移除并更新UI.
                         setState(() {
                           _delete(index);
                           _datas.removeAt(index);
                          });
                       },

                        // 列表项被滑出时，显示一个好看的绿色背景.
                       background: Container(
                         color: Colors.greenAccent,
                       ),

                       child: ListTile(
                         title: Container(

                           //前后左右留白间距.
                           padding: EdgeInsets.all(
                                20
                           ),

                           //显示添加的城市.
                           child: Text(_datas[index].cityname,
                                 style: TextStyle(
                                   color: Colors.white,
                                   fontSize: 40,
                                   fontWeight: FontWeight.w400,
                                 ),
                               textAlign: TextAlign.center,
                           ),
                         ),

                         //点击城市跳转到对应的城市天气界面.
                         onTap: () {
                           Navigator.push(
                             context, MaterialPageRoute(builder: (context) {
                             return MainPage(
                               cityID: _datas[index].cityID,
                             );
                             },
                            ),
                           );
                         },
                       )
                   );
                 }
             )
            : Container()
    );
  }
}