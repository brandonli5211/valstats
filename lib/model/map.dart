class MapModel {
  String splash;
  String uuid;
  String assetPath;

  MapModel({required this.uuid, required this.splash, required this.assetPath});

  factory MapModel.fromJson(Map<String, dynamic> json) => MapModel(
      uuid: json["uuid"], splash: json["splash"], assetPath: json["assetPath"]);
}
