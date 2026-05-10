import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/app_strings.dart';
import '../models/promo_code_model.dart';

class PromoCodesRepo {
  final DioConsumer api;

  PromoCodesRepo(this.api);

  //! Get Promo Codes
  Future<Either<String, List<PromoCodeModel>>> getPromoCodes({
    int? tripTypeId,
  }) async {
    try {
      final Response response = await api.get(
        EndPoints.promoCodes,
        queryParameters: {"trip_type_id": tripTypeId},
      );
      return Right(
        (response.data["data"] as List?)
                ?.map((e) => PromoCodeModel.fromJson(e))
                .toList() ??
            [],
      );
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }
}
