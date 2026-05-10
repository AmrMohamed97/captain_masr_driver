import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/app_strings.dart';

class RatingRepo {
  final DioConsumer api;

  RatingRepo(this.api);

  //! Rider Rate Trip
  Future<Either<String, String>> riderRateTrip({
    required int tripId,
    required List<bool>? carValues,
    required List<bool>? driverValues,
    required List<bool>? deliveryValues,
    required double tip,
    required double overallRating,
    required String? note,
    String? type,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.riderRateTrip.replaceAll("ID", tripId.toString()),
        data: {
          "ride_id": tripId,
          if (carValues != null)
            "car_rate": {
              "clean": carValues[0],
              "comfy": carValues[1],
              "spacious": carValues[2],
            },
          if (driverValues != null)
            "driver_rate": {
              "on_time": driverValues[0],
              "helpful": driverValues[1],
              "polite": driverValues[2],
            },
          if (deliveryValues != null)
            "delivery_rate": {
              "on_time": deliveryValues[0],
              "fast": deliveryValues[1],
              "polite": deliveryValues[2],
              "package_in_good_condition": deliveryValues[3],
            },
          "tip": tip,
          "overall_rating": overallRating,
          "note": note,
          if (type != null) "type": type,
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
