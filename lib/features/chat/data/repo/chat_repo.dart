import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/imports/imports.dart';

class ChatRepo {
  final DioConsumer api;

  ChatRepo(this.api);

  //! Send Message
  Future<Either<String, String>> sendMessage({
    required String requestType,
    required int tripId,
    required int senderId,
    required int recieverId,
    required String message,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.sendMessage,
        isFormData: true,
        data: {
          "request_type": requestType,
          "request_id": tripId, //! Trip id
          "sender_id": senderId,
          "receiver_id": recieverId,
          "message": message,
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
