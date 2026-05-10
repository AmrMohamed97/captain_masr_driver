class NotificationDataModel {
  final int? rideId, driverId;

  NotificationDataModel({
    required this.rideId,
    required this.driverId,
  });

  factory NotificationDataModel.fromJson(Map<String, dynamic> json) {
    return NotificationDataModel(
      rideId: json["ride_id"],
      driverId: json["driver_id"],
    );
  }
}
