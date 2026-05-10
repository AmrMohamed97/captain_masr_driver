import '../../../base/data/models/pagination_model.dart';
import 'calculation_model.dart';
import 'share_trip_model.dart';

class AvailableShareTripsModel {
  final List<ShareTripModel> trips;
  final CalculationModel? calculation;
  final PaginationModel? pagination;

  AvailableShareTripsModel({
    required this.trips,
    required this.calculation,
    required this.pagination,
  });

  factory AvailableShareTripsModel.fromJson(Map<String, dynamic> json) {
    return AvailableShareTripsModel(
      trips: (json["trips"]["data"] as List<dynamic>?)
              ?.map((e) => ShareTripModel.fromJson(e))
              .toList() ??
          <ShareTripModel>[],
      calculation: json["calculation"] != null
          ? CalculationModel.fromJson(json["calculation"])
          : null,
      pagination: json["trips"] != null
          ? PaginationModel.fromJson(json["trips"])
          : null,
    );
  }
}
