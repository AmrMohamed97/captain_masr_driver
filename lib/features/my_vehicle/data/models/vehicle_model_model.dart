class VehicleModelModel {
  final int? id, vehicleBrandId;
  final String? name;

  VehicleModelModel({
    required this.id,
    required this.vehicleBrandId,
    required this.name,
  });

  factory VehicleModelModel.fromJson(Map<String, dynamic> json) {
    return VehicleModelModel(
      id: json["id"],
      vehicleBrandId: json["vehicle_brand_id"],
      name: json["name"],
    );
  }
}
