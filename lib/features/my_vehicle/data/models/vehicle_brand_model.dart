class VehicleBrandModel {
  final int? id, vehicleTypeId;
  final String? name;

  VehicleBrandModel({
    required this.id,
    required this.vehicleTypeId,
    required this.name,
  });

  factory VehicleBrandModel.fromJson(Map<String, dynamic> json) {
    return VehicleBrandModel(
      id: json["id"],
      vehicleTypeId: json["vehicle_type_id"],
      name: json["name"],
    );
  }
}
