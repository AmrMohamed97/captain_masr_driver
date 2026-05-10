class CalculationModel {
  final double? distanceKm;
  final double? timeMinutes;
  final double? price;

  CalculationModel({
    this.distanceKm,
    this.timeMinutes,
    this.price,
  });

  factory CalculationModel.fromJson(Map<String, dynamic> json) =>
      CalculationModel(
        distanceKm: (json["distance_km"] as num?)?.toDouble(),
        timeMinutes: (json["time_minutes"] as num?)?.toDouble(),
        price: (json["price"] as num?)?.toDouble(),
      );
}
