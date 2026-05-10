class VehicleColorModel {
  final int? id;
  final String? name;

  VehicleColorModel({
    required this.id,
    required this.name,
  });

  factory VehicleColorModel.fromJson(Map<String, dynamic> json) {
    return VehicleColorModel(
      id: json["id"],
      name: json["name"],
    );
  }
}
