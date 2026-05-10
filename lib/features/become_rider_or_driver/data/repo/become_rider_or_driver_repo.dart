import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/app_strings.dart';

class BecomeRiderOrDriverRepo {
  final DioConsumer api;

  BecomeRiderOrDriverRepo(this.api);

  //! Become Rider
  Future<Either<String, String>> becomeRider() async {
    try {
      final Response response = await api.post(
        EndPoints.becomeRider,
      );
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Become Driver
  Future<Either<String, String>> becomeDriver({
    String? idNumber,
    MultipartFile? nationalId,
    String? nationalIdExpiry,
    String? vehicleTypeId,
    String? vehicleBrandId,
    String? vehicleModelId,
    String? vehicleColorId,
    MultipartFile? vehicleLicense,
    String? vehicleLicenseExpiry,
    MultipartFile? driverLicense,
    String? driverLicenseExpiry,
    String? vehicleCategoryId,
    String? plateNumber,
    required bool isConvertedBefore,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.becomeDriver,
        isFormData: !isConvertedBefore,
        data: isConvertedBefore
            ? null
            : {
                'ID_number': idNumber,
                "national_id": nationalId,
                'national_id_expiry': nationalIdExpiry,
                'vehicle_type_id': vehicleTypeId,
                'vehicle_brand_id': vehicleBrandId,
                'vehicle_model_id': vehicleModelId,
                'vehicle_color_id': vehicleColorId,
                "vehicle_license": vehicleLicense,
                'vehicle_license_expiry': vehicleLicenseExpiry,
                "driver_license": driverLicense,
                'driver_license_expiry': driverLicenseExpiry,
                'vehicle_category_id': vehicleCategoryId,
                'plate_number': plateNumber,
              },
      );
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }
}
