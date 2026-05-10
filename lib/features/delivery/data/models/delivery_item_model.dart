class DeliveryItemModel {
  final int? id;
  final String? name, logo;

  DeliveryItemModel({
    required this.id,
    required this.name,
    required this.logo,
  });

  factory DeliveryItemModel.fromJson(Map<String, dynamic> json) {
    return DeliveryItemModel(
      id: json["id"],
      name: json["name"],
      logo: json["logo"],
    );
  }
}
