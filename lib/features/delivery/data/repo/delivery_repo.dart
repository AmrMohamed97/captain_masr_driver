import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/imports/imports.dart';
import '../models/delivery_item_model.dart';
import '../models/delivery_size_model.dart';

class DeliveryRepo {
  final DioConsumer api;

  DeliveryRepo(this.api);

  //! Delivery Items
  Future<Either<String, List<DeliveryItemModel>>> getDeliveryItems({
    required int vehicleCategoryId,
  }) async {
    try {
      final Response response = await api.get(
        "${EndPoints.deliverItems}/$vehicleCategoryId",
      );
      return Right(
        (response.data["data"] as List?)
                ?.map((e) => DeliveryItemModel.fromJson(e))
                .toList() ??
            <DeliveryItemModel>[],
      );
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Delivery Items Sizes
  Future<Either<String, List<DeliverySizeModel>>> getDeliveryItemsSizes({
    required int vehicleCategoryId,
  }) async {
    try {
      final Response response = await api.get(
        "${EndPoints.deliverItemsSizes}/$vehicleCategoryId",
      );
      return Right(
        (response.data["data"] as List?)
                ?.map((e) => DeliverySizeModel.fromJson(e))
                .toList() ??
            <DeliverySizeModel>[],
      );
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }
}
