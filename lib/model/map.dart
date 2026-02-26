class MapModel {
  String uuid;
  String displayName;
  String? coordinates;
  String? displayIcon;
  String splash;
  String assetPath;

  MapModel({
    required this.uuid,
    required this.displayName,
    this.coordinates,
    this.displayIcon,
    required this.splash,
    required this.assetPath,
  });

  factory MapModel.fromJson(Map<String, dynamic> json) => MapModel(
        uuid: json["uuid"] ?? '',
        displayName: json['displayName'] ?? '',
        coordinates: json['coordinates'],
        displayIcon: json['displayIcon'],
        splash: json["splash"] ?? '',
        assetPath: json["assetPath"] ?? '',
      );

  bool get isCompetitive => displayIcon != null && coordinates != null;
}
