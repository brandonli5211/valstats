import 'package:dio/dio.dart';

import '../model/map.dart';

class MapHttpClient {
  String url;

  MapHttpClient(this.url);

  getMap() async {
    var dio = Dio();
    var response = await dio.get(url);
    var data = response.data;
    return (data["data"] as List).map((e) => MapModel.fromJson(e));
  }
}
