class DeliverySizeModel {
  final int? id;
  final String? name;

  DeliverySizeModel({
    required this.id,
    required this.name,
  });

  factory DeliverySizeModel.fromJson(Map<String, dynamic> json) {
    return DeliverySizeModel(
      id: json["id"],
      name: json["name"],
    );
  }
}
