class DriverPreferencesModel {
  final bool classicRide, shareTrip, groupTrip, delivery;

  DriverPreferencesModel({
    required this.classicRide,
    required this.shareTrip,
    required this.groupTrip,
    required this.delivery,
  });

  factory DriverPreferencesModel.fromJson(Map<String, dynamic> json) {
    return DriverPreferencesModel(
      classicRide: json["classic_ride"] ?? false,
      shareTrip: json["share_trip"] ?? false,
      groupTrip: json["group_trip"] ?? false,
      delivery: json["delivery"] ?? false,
    );
  }

  Map toJson() => {
        "classic_ride": classicRide,
        "share_trip": shareTrip,
        "group_trip": groupTrip,
        "delivery": delivery,
      };
}
