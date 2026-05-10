class RiderShareTripDataModel {
  final int seatsCount;
  final List<int> seatsIds;
  final int mainPaymentMethodId;
  final int? subPaymentMethodId;
  final String pickupAddress;
  final double pickupLatitude;
  final double pickupLongitude;
  final String dropoffAddress;
  final double dropoffLatitude;
  final double dropoffLongitude;
  final int vehicleCategoryId;
  final String? date;
  final List<String>? dates;
  final String? time;

  RiderShareTripDataModel({
    required this.seatsCount,
    required this.seatsIds,
    required this.mainPaymentMethodId,
    required this.subPaymentMethodId,
    required this.pickupAddress,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.dropoffAddress,
    required this.dropoffLatitude,
    required this.dropoffLongitude,
    required this.vehicleCategoryId,
    required this.date,
    this.dates,
    this.time,
  });
}
