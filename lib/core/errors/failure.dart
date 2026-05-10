import 'package:dio/dio.dart';

/// Base failure class with optional status code and error code
abstract class Failure {
  final String message;
  final int? statusCode;
  final String? errorCode;

  Failure(this.message, {this.statusCode, this.errorCode});

  @override
  String toString() => message;
}

/// Server-related failures (HTTP errors, API errors)
class ServerFailure extends Failure {
  ServerFailure(super.message, {super.statusCode, super.errorCode});

  factory ServerFailure.unexpectedError() => ServerFailure(
    dioExceptiosMessages['unknown'] ?? 'حدث خطأ ما يرجي المحاولة في وقت لاحق',
  );

  /// Create ServerFailure from DioException
  factory ServerFailure.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure(
          dioExceptiosMessages['connectionTimeout'] ??
              'انتهت مدة الاتصال لجلب البيانات',
        );

      case DioExceptionType.sendTimeout:
        return ServerFailure(
          dioExceptiosMessages['sendTimeout'] ??
              'انتهت مدة الاتصال لارسال البيانات',
        );

      case DioExceptionType.receiveTimeout:
        return ServerFailure(
          dioExceptiosMessages['receiveTimeout'] ??
              'انتهت مدة الاتصال للحصول على البيانات',
        );

      case DioExceptionType.badCertificate:
        return ServerFailure(
          dioExceptiosMessages['badCertificate'] ??
              'حدث خطأ في التوثيق يرجي الاتصال بمركز المعلومات',
        );

      case DioExceptionType.badResponse:
        if (error.response != null) {
          return ServerFailure.fromResponse(error.response!);
        }
        return ServerFailure(
          _extractErrorMessage(error) ??
              dioExceptiosMessages['unknown'] ??
              'حدث خطأ ما يرجي المحاولة في وقت لاحق',
        );

      case DioExceptionType.cancel:
        return ServerFailure(
          dioExceptiosMessages['cancel'] ?? 'تم رفض الطلب من قبل الخادم',
        );

      case DioExceptionType.connectionError:
        return ServerFailure(
          dioExceptiosMessages['connectionError'] ??
              'يرجى التحقق من الاتصال بالانترنت',
        );

      case DioExceptionType.unknown:
        return ServerFailure(
          _extractErrorMessage(error) ??
              dioExceptiosMessages['unknown'] ??
              'حدث خطأ ما يرجي المحاولة في وقت لاحق',
        );
    }
  }

  /// Create ServerFailure from HTTP Response
  factory ServerFailure.fromResponse(Response response) {
    final statusCode = response.statusCode ?? 0;
    final data = response.data;
    final message = _extractMessageFromResponse(data, statusCode);

    return ServerFailure(
      message,
      statusCode: statusCode,
      errorCode: _extractErrorCode(data),
    );
  }

  /// Extract error message from response data
  static String _extractMessageFromResponse(dynamic data, int statusCode) {
    // Handle string responses
    if (data is String) {
      return data.isNotEmpty ? data : _getDefaultMessage(statusCode);
    }

    // Handle map responses
    if (data is Map<String, dynamic>) {
      // Try common message fields
      final message =
          data['message'] ?? data['Message'] ?? data['error'] ?? data['Error'];

      if (message is String && message.isNotEmpty) {
        return message;
      }

      // Try errors array/object
      final errors = data['errors'];
      if (errors != null) {
        if (errors is List && errors.isNotEmpty) {
          return errors.first.toString();
        }
        if (errors is Map && errors.isNotEmpty) {
          return errors.values.first.toString();
        }
        if (errors is String) {
          return errors;
        }
      }
    }

    return _getDefaultMessage(statusCode);
  }

  /// Extract error code from response data
  static String? _extractErrorCode(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['code']?.toString() ??
          data['Code']?.toString() ??
          data['errorCode']?.toString();
    }
    return null;
  }

  /// Extract error message from DioException
  static String? _extractErrorMessage(DioException error) {
    if (error.response?.data != null) {
      return _extractMessageFromResponse(
        error.response!.data,
        error.response?.statusCode ?? 0,
      );
    }
    return error.message;
  }

  /// Get default message based on status code
  static String _getDefaultMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'طلب غير صحيح';
      case 401:
        return dioExceptiosMessages['Unauthorized'] ?? 'يرجى تسجيل الدخول اولا';
      case 403:
        return 'غير مصرح لك بالوصول';
      case 404:
        return 'المورد غير موجود';
      case 500:
        return 'حدث خطأ في الخادم';
      case 502:
        return 'خطأ في البوابة';
      case 503:
        return 'الخدمة غير متاحة حالياً';
      default:
        return 'حدث خطأ ما';
    }
  }
}

/// Network-related failures (no internet, connection issues)
class NetworkFailure extends Failure {
  NetworkFailure([super.message = 'يرجى التحقق من الاتصال بالانترنت']);
}

/// Cache-related failures
class CacheFailure extends Failure {
  CacheFailure([super.message = 'حدث خطأ في التخزين المحلي']);
}

/// Validation failures (input validation errors)
class ValidationFailure extends Failure {
  final Map<String, List<String>>? fieldErrors;

  ValidationFailure(super.message, {this.fieldErrors});
}

/// Unknown/Unhandled failures
class UnknownFailure extends Failure {
  UnknownFailure(super.message);
}

Map<String, String> dioExceptiosMessages = {
  "Unauthorized": "يرجى تسجيل الدخول اولا",
  "connectionTimeout": "انتهت مدة الاتصال لجلب البيانات",
  "sendTimeout": "انتهت مدة الاتصال لارسال البيانات",
  "receiveTimeout": "انتهت مدة الاتصال للحصول على البيانات",
  "badCertificate": " حدث خطأ في التوثيق يرجي الاتصال بمركز المعلومات",
  "cancel": "تم رفض الطلب من قبل الخادم",
  "connectionError": "يرجى التحقق من الاتصال بالانترنت",
  "unknown":
      " حدث خطأ ما يرجي المحاولة في وقت لاحق واذا استمر الخطأ يرجى التواصل مع الدعم الفني",
};
