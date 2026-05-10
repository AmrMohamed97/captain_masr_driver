class PromoCodeModel {
  final int? id;
  final num? percentage;
  final String? endDate, name, title, description;

  PromoCodeModel({
    required this.id,
    required this.percentage,
    required this.endDate,
    required this.name,
    required this.title,
    required this.description,
  });

  factory PromoCodeModel.fromJson(Map<String, dynamic> json) {
    return PromoCodeModel(
      id: json["id"],
      percentage: json["percentage"],
      endDate: json["end_date"],
      name: json["name"],
      title: json["title"],
      description: json["description"],
    );
  }
}
