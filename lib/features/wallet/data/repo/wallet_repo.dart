import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/imports/imports.dart';
import '../models/transactions_response_model.dart';
import '../models/payment_method_model.dart';

class WalletRepo {
  final DioConsumer api;

  WalletRepo(this.api);

  //! Get Payment Methods
  Future<Either<String, List<PaymentMethodModel>>> getPaymentMethods() async {
    try {
      final Response response = await api.get(EndPoints.paymentMethods);
      return Right((response.data["data"] as List?)
              ?.map((e) => PaymentMethodModel.fromJson(e))
              .toList() ??
          <PaymentMethodModel>[]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Get Transactions
  Future<Either<String, TransactionsResponseModel>> getTransations({
    required int page,
    required bool isRider,
  }) async {
    try {
      final Response response = await api.get(
        isRider ? EndPoints.userTransactions : EndPoints.driverTransactions,
        queryParameters: {"page": page},
      );
      return Right(TransactionsResponseModel.fromJson(response.data["data"]));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Set Default Payment Method
  Future<Either<String, String>> setDefaultPaymentMethod({
    required int paymentMethodId,
    required int? subPaymentMethodId,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.setDefaultPaymentMethod,
        isFormData: true,
        data: {
          "payment_method_id": paymentMethodId,
          "sub_payment_method_id": subPaymentMethodId,
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
