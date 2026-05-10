class VehicleCategoryModel {
  final int id;
  final String? name, logo;

  VehicleCategoryModel({
    required this.id,
    required this.name,
    required this.logo,
  });

  factory VehicleCategoryModel.fromJson(Map<String, dynamic> json) {
    return VehicleCategoryModel(
      id: json["id"],
      name: json["name"],
      logo: json["logo"],
    );
  }
}
