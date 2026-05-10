import 'package:dio/dio.dart';

import '../../app/app.dart';
import '../../features/splash/presentation/views/choose_role_view.dart';
import '../imports/imports.dart';
import 'error_model.dart';

//!ServerException
class ServerException implements Exception {
  final ErrorModel errorModel;
  ServerException(this.errorModel);
}

//!No Internet
class NoInternetException implements Exception {
  final ErrorModel errorModel;
  NoInternetException(this.errorModel);
}

//!CacheExeption
class CacheException implements Exception {
  final String errorMessage;
  CacheException({required this.errorMessage});
}

class BadCertificateException extends ServerException {
  BadCertificateException(super.errorModel);
}

class ConnectionTimeoutException extends ServerException {
  ConnectionTimeoutException(super.errorModel);
}

class BadResponseException extends ServerException {
  BadResponseException(super.errorModel);
}

class ReceiveTimeoutException extends ServerException {
  ReceiveTimeoutException(super.errorModel);
}

class ConnectionErrorException extends ServerException {
  ConnectionErrorException(super.errorModel);
}

class SendTimeoutException extends ServerException {
  SendTimeoutException(super.errorModel);
}

class UnauthorizedException extends ServerException {
  UnauthorizedException(super.errorModel);
}

class ForbiddenException extends ServerException {
  ForbiddenException(super.errorModel);
}

class NotFoundException extends ServerException {
  NotFoundException(super.errorModel);
}

class CofficientException extends ServerException {
  CofficientException(super.errorModel);
}

class CancelException extends ServerException {
  CancelException(super.errorModel);
}

class UnknownException extends ServerException {
  UnknownException(super.errorModel);
}

handleDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionError:
      throw NoInternetException(
        ErrorModel(
          detail: AppStrings.noInternetException(),
        ),
      );
    case DioExceptionType.badCertificate:
      throw BadCertificateException(ErrorModel.fromJson(e.response!.data));
    case DioExceptionType.connectionTimeout:
      throw ConnectionTimeoutException(ErrorModel(detail: e.error.toString()));

    case DioExceptionType.receiveTimeout:
      throw ReceiveTimeoutException(ErrorModel.fromJson(e.response!.data));

    case DioExceptionType.sendTimeout:
      throw SendTimeoutException(ErrorModel.fromJson(e.response!.data));

    case DioExceptionType.badResponse:
      switch (e.response?.statusCode) {
        case 400: // Bad request

          throw BadResponseException(ErrorModel.fromJson(e.response!.data));

        case 401: //unauthorized
          sl<Cache>().removeKey(AppConstants.token);
          sl<Cache>().removeKey(AppConstants.user);
          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
              return const ChooseRoleView();
            }),
            (route) => false,
          );
          throw UnauthorizedException(ErrorModel.fromJson(e.response!.data));

        case 403: //forbidden
          sl<Cache>().removeKey(AppConstants.token);
          sl<Cache>().removeKey(AppConstants.user);
          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
              return const ChooseRoleView();
            }),
            (route) => false,
          );
          throw ForbiddenException(ErrorModel.fromJson(e.response!.data));

        case 404: //not found
          throw NotFoundException(ErrorModel.fromJson(e.response!.data));

        case 409: //cofficient

          throw CofficientException(ErrorModel.fromJson(e.response!.data));

        case 413:
          throw BadResponseException(ErrorModel(detail: e.response!.data));

        case 422: //  Unprocessable Entity
          throw BadResponseException(
            ErrorModel.fromJson(e.response!.data)
              ..statusCodel = e.response?.statusCode,
          );

        case 450:
          throw BadResponseException(
            ErrorModel.fromJson(e.response!.data)
              ..statusCodel = e.response?.statusCode,
          );

        case 504: // Bad request
          throw BadResponseException(
            ErrorModel(
              detail: e.response!.data,
            )..statusCodel = e.response?.statusCode,
          );
        case 500:
          throw BadResponseException(ErrorModel(detail: e.response!.data));
      }

    case DioExceptionType.cancel:
      throw CancelException(ErrorModel(detail: e.toString()));

    case DioExceptionType.unknown:
      throw UnknownException(
        ErrorModel(detail: AppStrings.anErrorOccured()),
      );
  }
}
