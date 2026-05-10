import '../../../base/data/models/pagination_model.dart';
import 'rider_calculation_model.dart';
import 'rider_share_trip_model.dart';

class RiderAvailableShareTripsModel {
  final List<RiderShareTripModel> trips;
  final RiderCalculationModel? calculation;
  final PaginationModel? pagination;

  RiderAvailableShareTripsModel({
    required this.trips,
    required this.calculation,
    required this.pagination,
  });

  factory RiderAvailableShareTripsModel.fromJson(Map<String, dynamic> json) {
    return RiderAvailableShareTripsModel(
      trips: (json["trips"]["data"] as List<dynamic>?)
              ?.map((e) => RiderShareTripModel.fromJson(e))
              .toList() ??
          <RiderShareTripModel>[],
      calculation: json["calculation"] != null
          ? RiderCalculationModel.fromJson(json["calculation"])
          : null,
      pagination: json["trips"] != null
          ? PaginationModel.fromJson(json["trips"])
          : null,
    );
  }
}
