import 'package:dio/dio.dart';

import '../model/agent.dart';

class AgentHttpClient {
  final String url;

  AgentHttpClient(this.url);

  Future<List<AgentModel>> getAgents() async {
    var dio = Dio();
    var response = await dio.get(url);
    var data = response.data;
    if (data is String) return [];
    return (data["data"] as List)
        .map((e) => AgentModel.fromJson(e))
        .where((a) => a.fullPortrait != null)
        .toList();
  }
}
