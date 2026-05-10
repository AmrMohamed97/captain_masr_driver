class NotifiedDriverModel {
  final int? id;
  final String? image, name;

  NotifiedDriverModel({
    required this.id,
    required this.image,
    required this.name,
  });

  factory NotifiedDriverModel.fromJson(Map json) {
    return NotifiedDriverModel(
      id: json["id"],
      image: json["image"],
      name: json["name"],
    );
  }
}
