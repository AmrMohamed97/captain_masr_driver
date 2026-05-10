import '../../../rider_trip/data/models/trip_details_model.dart';

class CanceledTripModel {
  final String? canceledBy, cancelNote;
  final List<String> cancelReasons;
  final TripDetailsModel? ride;

  CanceledTripModel({
    required this.canceledBy,
    required this.cancelNote,
    required this.cancelReasons,
    required this.ride,
  });

  factory CanceledTripModel.fromJson(Map<String, dynamic> json) {
    return CanceledTripModel(
      canceledBy: json["canceled_by"],
      cancelNote: json["note"],
      cancelReasons: (json["cancel_reasons"] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          <String>[],
      ride:
          json["ride"] != null ? TripDetailsModel.fromJson(json["ride"]) : null,
    );
  }
}
