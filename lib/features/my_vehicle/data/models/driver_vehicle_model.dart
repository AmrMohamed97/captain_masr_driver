import 'vehicle_brand_model.dart';
import 'vehicle_category_model.dart';
import 'vehicle_color_model.dart';
import 'vehicle_model_model.dart';
import 'vehicle_type_model.dart';

class DriverVehicleModel {
  final VehicleCategoryModel? vehicleCategory;
  final VehicleTypeModel? vehicleType;
  final VehicleBrandModel? vehicleBrand;
  final VehicleModelModel? vehicleModel;
  final VehicleColorModel? vehicleColor;
  final String? plateNumber, vehicleLicenseImage, vehicleLicenseExpiry;

  DriverVehicleModel({
    required this.vehicleCategory,
    required this.vehicleType,
    required this.vehicleBrand,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.plateNumber,
    required this.vehicleLicenseImage,
    required this.vehicleLicenseExpiry,
  });

  factory DriverVehicleModel.fromJson(Map<String, dynamic> json) {
    return DriverVehicleModel(
      vehicleCategory: json["vehicle_category"] != null
          ? VehicleCategoryModel.fromJson(json["vehicle_category"])
          : null,
      vehicleType: json["vehicle_type"] != null
          ? VehicleTypeModel.fromJson(json["vehicle_type"])
          : null,
      vehicleBrand: json["vehicle_brand"] != null
          ? VehicleBrandModel.fromJson(json["vehicle_brand"])
          : null,
      vehicleModel: json["vehicle_model"] != null
          ? VehicleModelModel.fromJson(json["vehicle_model"])
          : null,
      vehicleColor: json["vehicle_color"] != null
          ? VehicleColorModel.fromJson(json["vehicle_color"])
          : null,
      plateNumber: json["plate_number"],
      vehicleLicenseImage: json["vehicle_license"],
      vehicleLicenseExpiry: json["vehicle_license_expiry"],
    );
  }
}
