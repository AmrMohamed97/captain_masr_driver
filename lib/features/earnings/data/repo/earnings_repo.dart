import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/app_strings.dart';
import '../models/driver_summary_model.dart';

class EarningsRepo {
  final DioConsumer api;

  EarningsRepo(this.api);

  //! Get Driver Summary
  Future<Either<String, DriverSummaryModel>> getDriverSummary({
    required Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final Response response = await api.get(
        EndPoints.driverSummary,
        queryParameters: queryParameters,
      );
      return Right(
          DriverSummaryModel.fromJson(response.data["data"]["summary"]));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }
}
