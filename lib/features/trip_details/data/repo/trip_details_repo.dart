import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/imports/imports.dart';
import '../../../rider_trip/data/models/trip_details_model.dart';

class TripDetailsRepo {
  final DioConsumer api;

  TripDetailsRepo(this.api);

  //! Complete Trip Details
  Future<Either<String, TripDetailsModel>> completedTripDetails({
    required int tripId,
    required bool isRider,
  }) async {
    try {
      final Response response = await api.get(
        "${isRider ? EndPoints.userCompletedTrips : EndPoints.driverCompletedTrips}/$tripId",
      );
      return Right(TripDetailsModel.fromJson(response.data["data"]));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }
}
