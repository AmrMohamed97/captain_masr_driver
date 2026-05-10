import '../../../login/data/models/user_model.dart';
import '../../../my_vehicle/data/models/seat_model.dart';

class RiderShareTripModel {
  final int? id;
  final int? driverId;
  final String? pickupAddress;
  final String? pickupLatitude;
  final String? pickupLongitude;
  final String? dropoffAddress;
  final String? dropoffLatitude;
  final String? dropoffLongitude;
   String? status;
   String? requestStatus;
  final bool? femaleRider;
  final bool? babyCarriage;
  final String? luggagesCount;
  final int? seatsAvailable;
  final List<int>? availableSeetsId;
  final List<SeatModel> availableSeets;
  final String? date;
  final String? time;
  final String? description;
  final String? type;
  final num? pickupDistance;
  final num? dropoffDistance;
  final UserModel? driver;
  final String? vehicleBrand;
  final String? vehicleModel;
  final String? vehicleColor;
  final String? vehiclePlats;
  final String? vehicleType;
  final List<String>? dates;
  final String? dateFrom;
  final String? dateTo;
  final List<int>? seatsIds;

  RiderShareTripModel({
    required this.id,
    required this.driverId,
    required this.pickupAddress,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.dropoffAddress,
    required this.dropoffLatitude,
    required this.dropoffLongitude,
    required this.status,
    required this.requestStatus,
    required this.femaleRider,
    required this.babyCarriage,
    required this.luggagesCount,
    required this.seatsAvailable,
    required this.availableSeetsId,
    required this.availableSeets,
    required this.date,
    required this.time,
    required this.description,
    required this.type,
    required this.pickupDistance,
    required this.dropoffDistance,
    required this.driver,
    required this.vehicleBrand,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.vehiclePlats,
    required this.vehicleType,
    required this.dates,
    required this.dateFrom,
    required this.dateTo,
    required this.seatsIds,
  });

  factory RiderShareTripModel.fromJson(Map<String, dynamic> json) => RiderShareTripModel(
        id: json["id"] as int?,
        driverId: json["driver_id"] as int?,
        pickupAddress: json["pickup_address"] as String?,
        pickupLatitude: json["pickup_latitude"] as String?,
        pickupLongitude: json["pickup_longitude"] as String?,
        dropoffAddress: json["dropoff_address"] as String?,
        dropoffLatitude: json["dropoff_latitude"] as String?,
        dropoffLongitude: json["dropoff_longitude"] as String?,
        status: json["status"] as String?,
        requestStatus: json["request_status"] as String?,
        femaleRider: json["female_rider"] as bool?,
        babyCarriage: json["baby_carriage"] as bool?,
        luggagesCount: json["luggages_count"] as String?,
        seatsAvailable: json["seats_available"] as int?,
        availableSeetsId: json["available_seets_id"] is List<int>
            ? json["available_seets_id"] as List<int>?
            : null,
        availableSeets: (json["available_seets"] as List?)
                ?.map((e) => SeatModel.fromJson(e))
                .toList() ??
            <SeatModel>[],
        date: json["date"] as String?,
        time: json["time"] as String?,
        description: json["description"] as String?,
        type: json["type"] as String?,
        pickupDistance: json["pickup_distance"] as num?,
        dropoffDistance: json["dropoff_distance"] as num?,
        driver:
            json["driver"] != null ? UserModel.fromJson(json["driver"]) : null,
        vehicleBrand: json["driver"]?["vehicle"]?["vehicle_brand"] ??
            json["driver"]?["vehicle"]?["brand"],
        vehicleModel: json["driver"]?["vehicle"]?["vehicle_model"] ??
            json["driver"]?["vehicle"]?["model"],
        vehicleColor: json["driver"]?["vehicle"]?["vehicle_color"] ??
            json["driver"]?["vehicle"]?["color"],
        vehiclePlats: json["driver"]?["vehicle"]?["vehicle_plate"] ??
            json["driver"]?["vehicle"]?["plate"],
        vehicleType: json["driver"]?["vehicle"]?["vehicle_type"] ??
            json["driver"]?["vehicle"]?["type"],
        dates: json["dates"],
        dateFrom: json["date_from"] as String?,
        dateTo: json["date_to"] as String?,
        seatsIds: json["seats_ids"] is List<int>
            ? json["seats_ids"] as List<int>?
            : null,
      );
}
