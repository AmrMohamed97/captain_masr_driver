import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../preferences/data/models/preferences_model.dart';

class TripDetailsModel {
  final int? id,
      userId,
      rideId,
      riderId,
      requestId,
      // tripId,
      smallCount,
      mediumCount,
      largeCount,
      seatsNeeded,
      vehicleCategoryId,
      tripTypeId,
      driverId,
      tripCode,
      shareRideId;
  final String? riderName,
      riderImage,
      riderPhone,
      riderPhoneCode,
      pickupAddress,
      dropoffAddress,
      pickupDate,
      pickupTime,
      tripType,
      status,
      startedAt,
      completedAt,
      arrivedAt,
      todayStatus,
      createdAt,
      updatedAt,
      driverImage,
      driverName,
      driverPhone,
      driverPhoneCode,
      vehicleBrand,
      vehicleModel,
      vehicleColor,
      vehiclePlats,
      vehicleType,
      deliverType,
      paymentOfDeliverType,
      deliverItem,
      deliverItemSize,
      notes,
      deliveryImage,
      deliveryImageDriver,
      dateFrom,
      dateTo,
      date,
      time,
      seatsAvailable,
      type;
  final double? pickupLatitude,
      pickupLongitude,
      dropoffLatitude,
      dropoffLongitude;
  final num? riderRating,
      distanceKm,
      timeMinutes,
      price,
      totalPrice,
      distanceBetRiderAndDriver,
      driverRating,
      timeBetRiderAndDriver;
  final List<LatLng> stops;
  final bool? femaleDriver, babyCarriage, luggages;
  final PreferencesModel? preferences;
  List<TripDetailsModel> requests;
  List<TripDetailsModel> riders;
  final List<String>? days;
  final List<int>? seatsIds;

  TripDetailsModel({
    required this.id,
    required this.userId,
    required this.rideId,
    required this.riderId,
     this.requestId,
    // required this.tripId,
    required this.smallCount,
    required this.mediumCount,
    required this.largeCount,
    required this.seatsNeeded,
    required this.vehicleCategoryId,
    required this.tripTypeId,
    required this.riderName,
    required this.riderImage,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.pickupDate,
    required this.pickupTime,
    required this.tripType,
    required this.status,
    required this.createdAt,
     this.arrivedAt,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.dropoffLatitude,
    required this.dropoffLongitude,
    required this.riderRating,
    required this.distanceKm,
    required this.timeMinutes,
    required this.price,
    required this.totalPrice,
    required this.stops,
    required this.femaleDriver,
    required this.babyCarriage,
    required this.luggages,
    required this.distanceBetRiderAndDriver,
    required this.driverId,
    required this.driverImage,
    required this.driverRating,
    required this.timeBetRiderAndDriver,
    required this.driverName,
    required this.vehicleBrand,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.vehiclePlats,
    required this.vehicleType,
    required this.preferences,
    required this.tripCode,
    required this.riderPhone,
    required this.driverPhone,
    required this.riderPhoneCode,
    required this.driverPhoneCode,
    required this.deliverItem,
    required this.deliverItemSize,
    required this.deliverType,
    required this.paymentOfDeliverType,
    required this.notes,
    required this.requests,
    required this.shareRideId,
    required this.riders,
    required this.updatedAt,
    required this.deliveryImage,
    required this.deliveryImageDriver,
    required this.dateFrom,
    required this.dateTo,
     this.date,
    required this.time,
    required this.seatsAvailable,
    required this.type,
    required this.days,
    required this.seatsIds,
    this.startedAt,
    this.completedAt,
    this.todayStatus,
  });

  factory TripDetailsModel.fromJson(Map json) {
    return TripDetailsModel(
      id: json["id"] ?? json["trip_id"],
      userId: json["user_id"],
      rideId: int.tryParse(json["ride_id"]?.toString() ?? "0"),
      riderId: json["rider_id"],
      requestId: json["request_id"],
      // tripId: json["trip_id"],
      smallCount: json["small_count"],
      mediumCount: json["medium_count"],
      largeCount: json["large_count"],
      seatsNeeded: json["seats_needed"],
      vehicleCategoryId: json["vehicle_category_id"],
      tripTypeId: json["trip_type_id"],
      riderName: json["rider_name"],
      riderImage: json["rider_image"]?.toString(),
      pickupAddress: json["pickup_address"],
      dropoffAddress: json["dropoff_address"],
      pickupDate: json["pickup_date"],
      pickupTime: json["pickup_time"],
      tripType: json["trip_type"]?.toString(),
      status: json["status"],
      completedAt: json["completed_at"]?.toString(),
      todayStatus: json["today_status"]?.toString(),
      startedAt: json["started_at"]?.toString(),
      createdAt: json["created_at"],
      arrivedAt: json["arrived_at"],
      pickupLatitude:
          double.tryParse(json["pickup_latitude"]?.toString() ?? "0.0"),
      pickupLongitude:
          double.tryParse(json["pickup_longitude"]?.toString() ?? "0.0"),
      dropoffLatitude:
          double.tryParse(json["dropoff_latitude"]?.toString() ?? "0.0"),
      dropoffLongitude:
          double.tryParse(json["dropoff_longitude"]?.toString() ?? "0.0"),
      riderRating: json["rider_rating"],
      distanceKm: json["distance_km"],
      timeMinutes: json["time_minutes"],
      totalPrice: num.tryParse(json["total_price"]?.toString() ?? "0.0"),
      price: num.tryParse(
          (json["price"]?.toString() ?? json["cost"])?.toString() ?? "0.0"),
      // totalPrice: num.tryParse(
      //     (json["total_price"]?.toString() ?? json["cost"])?.toString() ?? "0.0"),
      // stops: (json["stops"] as List?)
      //         ?.map((e) => LatLng(e["latitude"], e["longitude"]))
      //         .toList() ??
      //     <LatLng>[],
      stops: (json["stops"] as List?)
              ?.map((e) => LatLng(
                    double.parse(e["latitude"]),
                    double.parse(e["longitude"]),
                  ))
              .toList() ??
          <LatLng>[],
      femaleDriver: json["female_driver"],
      babyCarriage: json["baby_carriage"],
      luggages: json["luggages"],
      distanceBetRiderAndDriver: json["distance_bet_rider_and_driver"],
      driverId: json["driver_id"],
      driverImage: json["driver_image"],
      driverRating: json["driver_rating"],
      timeBetRiderAndDriver: json["time_bet_rider_and_driver"],
      driverName: json["driver_name"],
      vehicleBrand:
          json["vehicle"]?["vehicle_brand"] ?? json["vehicle"]?["brand"],
      vehicleModel:
          json["vehicle"]?["vehicle_model"] ?? json["vehicle"]?["model"],
      vehicleColor:
          json["vehicle"]?["vehicle_color"] ?? json["vehicle"]?["color"],
      vehiclePlats:
          json["vehicle"]?["vehicle_plate"] ?? json["vehicle"]?["plate"],
      vehicleType: json["vehicle"]?["vehicle_type"] ?? json["vehicle"]?["type"],
      preferences: json["preferences"] != null
          ? PreferencesModel.fromJson(json["preferences"])
          : null,
      tripCode: int.tryParse(json["trip_code"].toString()),
      driverPhone: json["driver_phone"],
      riderPhone: json["rider_phone"],
      driverPhoneCode: json["driver_phone_code"]?.toString(),
      riderPhoneCode: json["rider_phone_code"]?.toString(),
      deliverItem: json["deliver_item"],
      deliverItemSize: json["deliver_item_size"],
      deliverType: json["deliver_type"],
      paymentOfDeliverType: json["payment_of_deliver_type"],
      notes: json["notes"],
      requests: (json["requests"] as Map?)
              ?.map((key, value) =>
                  MapEntry(key, TripDetailsModel.fromJson(value)))
              .values
              .toList() ??
          [],
      shareRideId: int.tryParse(json["share_ride_id"]?.toString() ?? "0"),
      riders: json["riders"] is Map
          ? (json["riders"] as Map?)
                  ?.map((key, value) =>
                      MapEntry(key, TripDetailsModel.fromJson(value)))
                  .values
                  .toList() ??
              []
          : json["riders"] is List
              ? (json["riders"] as List?)
                      ?.where((element) => element != null)
                      .map((element) => TripDetailsModel.fromJson(element))
                      .toList() ??
                  []
              : [],
      updatedAt: json["updated_at"],
      deliveryImage: json["delivery_image"],
      deliveryImageDriver: json["delivery_image_driver"],
      // Support both API format (date_from/date_to) and Firebase format (from/to)
      dateFrom: json["date_from"] ?? json["from"],
      dateTo: json["date_to"] ?? json["to"],
      date: json["date"],
      time: json["time"],
      seatsAvailable: json["seats_available"]?.toString(),
      type: json["type"],
      days: json["days"] is List
          ? (json["days"] as List).map((e) => e.toString()).toList()
          : (json["days"] != null ? [json["days"].toString()] : null),
      seatsIds: (json["seats_ids"] as List?)
          ?.map((e) => int.tryParse(e.toString()) ?? 0)
          .toList(),
    );
  }
  Map<String,dynamic> toMap(){
    return {
      "id": id,
      "user_id": userId,
      "ride_id": rideId,
      "rider_id": riderId,
      "small_count": smallCount,
      "medium_count": mediumCount,
      "large_count": largeCount,
      "seats_needed": seatsNeeded,
      "vehicle_category_id": vehicleCategoryId,
      "trip_type_id": tripTypeId,
      "rider_name": riderName,
      "rider_image": riderImage,
      "pickup_address": pickupAddress,
      "dropoff_address": dropoffAddress,
      "pickup_date": pickupDate,
      "pickup_time": pickupTime,
      "trip_type": tripType,
      "status": status,
      "created_at": createdAt,
      "arrived_at": arrivedAt,
      "pickup_latitude": pickupLatitude,
      "pickup_longitude": pickupLongitude,
      "dropoff_latitude": dropoffLatitude,
      "dropoff_longitude": dropoffLongitude,
      "rider_rating": riderRating,
      "distance_km": distanceKm,
      "time_minutes": timeMinutes,
      "price": price,
      "total_price": totalPrice,
      "stops": stops,
      "female_driver": femaleDriver,
      "baby_carriage": babyCarriage,
      "luggages": luggages,
      "distance_bet_rider_and_driver": distanceBetRiderAndDriver,
      "driver_id": driverId,
      "driver_image": driverImage,
      "driver_rating": driverRating,
      "time_bet_rider_and_driver": timeBetRiderAndDriver,
      "driver_name": driverName,
      "vehicle_brand": vehicleBrand,
      "vehicle_model": vehicleModel,
      "vehicle_color": vehicleColor,
      "vehicle_plats": vehiclePlats,
      "vehicle_type": vehicleType,
      "preferences": preferences,
      "trip_code": tripCode,
      "rider_phone": riderPhone,
      "driver_phone": driverPhone,
      "rider_phone_code": riderPhoneCode,
      "driver_phone_code": driverPhoneCode,
      "deliver_item": deliverItem,
      "deliver_item_size": deliverItemSize,
      "deliver_type": deliverType,
      "payment_of_deliver_type": paymentOfDeliverType,
      "notes": notes,
      "requests": requests,
      "share_ride_id": shareRideId,
      "riders": riders,
      "updated_at": updatedAt,
      "delivery_image": deliveryImage,
      "delivery_image_driver": deliveryImageDriver,
      "date_from": dateFrom,
      "date_to": dateTo,
      "date": date,
      "time": time,
      "seats_available": seatsAvailable,
      "type": type,
      "days": days,
      "seats_ids": seatsIds,
      "started_at": startedAt,
      "completed_at": completedAt,
      "today_status": todayStatus,
    };
  }
  // Map<String, dynamic> toJson() => toMap();
}
