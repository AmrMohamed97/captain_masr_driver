class DriverTodaySummaryModel {
  final num? totalEarning, totalTips, grandTotal;
  final int? tripCount;
  DriverTodaySummaryModel({
    required this.totalEarning,
    required this.totalTips,
    required this.grandTotal,
    required this.tripCount,
  });

  factory DriverTodaySummaryModel.fromJson(Map<String, dynamic> json) {
    return DriverTodaySummaryModel(
      totalEarning: json["total_earning"],
      totalTips: json["total_tips"],
      grandTotal: json["grand_total"],
      tripCount: json["trip_count"],
    );
  }
}
