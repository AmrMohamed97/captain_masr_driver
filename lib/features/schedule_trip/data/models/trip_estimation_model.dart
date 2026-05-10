class TripEstimationModel {
  bool? success;
  String? message;
  Data? data;

  TripEstimationModel({
    this.success,
    this.message,
    this.data,
  });

  factory TripEstimationModel.fromJson(Map<String, dynamic> json) {
    return TripEstimationModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class Data {
  num? distanceKm;
  num? timeMinutes;
  num? price;
  num? totalPrice;

  Data({
    this.distanceKm,
    this.timeMinutes,
    this.price,
    this.totalPrice,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      distanceKm: (json['distance_km'] as num?),
      timeMinutes: (json['time_minutes'] as num?),
      price: (json['price'] as num?),
      totalPrice: (json['total_price'] as num?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'distance_km': distanceKm,
      'time_minutes': timeMinutes,
      'price': price,
      'total_price': totalPrice,
    };
  }
}