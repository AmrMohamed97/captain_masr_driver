class CompleteTripResponseModel {
  final bool? success;
  final String? message;
  final RideData? data;

  CompleteTripResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory CompleteTripResponseModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return CompleteTripResponseModel();

    return CompleteTripResponseModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? RideData.fromJson(json['data']) : null,
    );
  }
}

class RideData {
  final String? status;
  final DateTime? completedAt;
  final Payment? payment;
  final int? completedTrips;

  RideData({
    this.status,
    this.completedAt,
    this.payment,
    this.completedTrips,
  });

  factory RideData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return RideData();

    return RideData(
      status: json['status'],
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'])
          : null,
      payment:
          json['payment'] != null ? Payment.fromJson(json['payment']) : null,
      completedTrips: json['completed_trips'],
    );
  }
}

class Payment {
  final String? total;
  final num? systemCut;
  final num? driverEarning;

  Payment({
    this.total,
    this.systemCut,
    this.driverEarning,
  });

  factory Payment.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Payment();

    return Payment(
      total: json['total'],
      systemCut: json['system_cut'],
      driverEarning: json['driver_earning'],
    );
  }
}