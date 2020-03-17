//城市表.
class CityName {
  String cityname;
  String cityID;
  int id;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['cityname'] = cityname;
    map['cityID'] = cityID;
    map['id'] = id;
    return map;
  }

  static CityName fromMap(Map<String, dynamic> map) {
    CityName city = new CityName();
    city.cityname = map['cityname'];
    city.cityID = map['cityID'];
    city.id = map['id'];
    return city;
  }

  static List<CityName> fromMapList(dynamic mapList) {
    List<CityName> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }

}