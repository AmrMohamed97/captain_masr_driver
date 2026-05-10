class RiderCalculationModel {
  final double? distanceKm;
  final double? timeMinutes;
  final double? price;

  RiderCalculationModel({
    this.distanceKm,
    this.timeMinutes,
    this.price,
  });

  factory RiderCalculationModel.fromJson(Map<String, dynamic> json) =>
      RiderCalculationModel(
        distanceKm: (json["distance_km"] as num?)?.toDouble(),
        timeMinutes: (json["time_minutes"] as num?)?.toDouble(),
        price: (json["price"] as num?)?.toDouble(),
      );
}
