class DriverSummaryModel {
  final num? totalOnline,
      totalEarning,
      totalTip,
      totalWithTip,
      totalAcceptedTrips,
      totalCanceledTrips,
      totalClasicTrips,
      totalShareTrips,
      totalGroupTrips,
      totalDeliveryTrips,
      totalClasicEarning,
      totalShareEarning,
      totalGroupEarning,
      totalDeliveryEarning;

  DriverSummaryModel({
    required this.totalOnline,
    required this.totalEarning,
    required this.totalTip,
    required this.totalWithTip,
    required this.totalAcceptedTrips,
    required this.totalCanceledTrips,
    required this.totalClasicTrips,
    required this.totalShareTrips,
    required this.totalGroupTrips,
    required this.totalDeliveryTrips,
    required this.totalClasicEarning,
    required this.totalShareEarning,
    required this.totalGroupEarning,
    required this.totalDeliveryEarning,
  });

  factory DriverSummaryModel.fromJson(Map<String, dynamic> json) {
    return DriverSummaryModel(
      totalOnline: json["total_online"],
      totalEarning: json["total_earning"],
      totalTip: json["total_tip"],
      totalWithTip: json["total_with_tip"],
      totalAcceptedTrips: json["total_accepted_trips"],
      totalCanceledTrips: json["total_canceled_trips"],
      totalClasicTrips: json["total_clasic_trips"],
      totalShareTrips: json["total_share_trips"],
      totalGroupTrips: json["total_group_trips"],
      totalDeliveryTrips: json["total_delivery_trips"],
      totalClasicEarning: json["total_clasic_earning"],
      totalShareEarning: json["total_share_earning"],
      totalGroupEarning: json["total_group_earning"],
      totalDeliveryEarning: json["total_delivery_earning"],
    );
  }
}
