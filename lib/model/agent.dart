import 'dart:ui';

class AgentModel {
  final String uuid;
  final String displayName;
  final String description;
  final String? fullPortrait;
  final String? background;
  final List<String> gradientColors;
  final RoleModel? role;
  final List<AbilityModel> abilities;

  AgentModel({
    required this.uuid,
    required this.displayName,
    required this.description,
    this.fullPortrait,
    this.background,
    required this.gradientColors,
    this.role,
    required this.abilities,
  });

  factory AgentModel.fromJson(Map<String, dynamic> json) {
    final colors = (json['backgroundGradientColors'] as List?)
            ?.map((c) => c.toString())
            .toList() ??
        [];

    final roleJson = json['role'];
    final abilitiesJson = json['abilities'] as List? ?? [];

    return AgentModel(
      uuid: json['uuid'] ?? '',
      displayName: json['displayName'] ?? '',
      description: json['description'] ?? '',
      fullPortrait: json['fullPortrait'],
      background: json['background'],
      gradientColors: colors,
      role: roleJson != null ? RoleModel.fromJson(roleJson) : null,
      abilities:
          abilitiesJson.map((a) => AbilityModel.fromJson(a)).toList(),
    );
  }

  Color parseGradientColor(int index) {
    if (index >= gradientColors.length) return const Color(0xff0f1923);
    final hex = gradientColors[index];
    final value = int.tryParse(hex, radix: 16);
    if (value == null) return const Color(0xff0f1923);
    return Color(value);
  }
}

class RoleModel {
  final String displayName;
  final String? displayIcon;

  RoleModel({required this.displayName, this.displayIcon});

  factory RoleModel.fromJson(Map<String, dynamic> json) => RoleModel(
        displayName: json['displayName'] ?? '',
        displayIcon: json['displayIcon'],
      );
}

class AbilityModel {
  final String slot;
  final String displayName;
  final String description;
  final String? displayIcon;

  AbilityModel({
    required this.slot,
    required this.displayName,
    required this.description,
    this.displayIcon,
  });

  factory AbilityModel.fromJson(Map<String, dynamic> json) => AbilityModel(
        slot: json['slot'] ?? '',
        displayName: json['displayName'] ?? '',
        description: json['description'] ?? '',
        displayIcon: json['displayIcon'],
      );
}
