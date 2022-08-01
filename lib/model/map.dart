class MapModel {
  String splash;
  String uuid;
  String assetPath;
  String displayName;
  String coordinates;

  MapModel({required this.uuid, required this.splash, required this.assetPath, required this.displayName, required this.coordinates});

  factory MapModel.fromJson(Map<String, dynamic> json) => MapModel(
      uuid: json["uuid"], splash: json["splash"], assetPath: json["assetPath"], displayName: json['displayName'], coordinates: json['coordinates']);
}
