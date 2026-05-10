class SavedPlaceModel {
  final int? id;
  final String? type, address, lat, long, iconType;

  SavedPlaceModel({
    required this.id,
    required this.type,
    required this.address,
    required this.lat,
    required this.long,
    required this.iconType,
  });

  factory SavedPlaceModel.fromJson(Map<String, dynamic> json) {
    return SavedPlaceModel(
      id: json["id"],
      type: json["type"],
      address: json["address"] ?? json["adddress"],
      lat: json["lat"],
      long: json["long"],
      iconType: json["icon_type"],
    );
  }
}
