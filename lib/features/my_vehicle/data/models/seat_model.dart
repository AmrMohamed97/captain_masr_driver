class SeatModel {
  final int? id;
  final String? name;

  SeatModel({
    required this.id,
    required this.name,
  });

  factory SeatModel.fromJson(Map<String, dynamic> json) {
    return SeatModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
