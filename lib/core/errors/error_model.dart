// class ErrorModel {
//   final String errorMessage;

//   ErrorModel({required this.errorMessage});
//   factory ErrorModel.fromJson(Map<String, dynamic> jsonData) {
//     return ErrorModel(
//       errorMessage: jsonData[ApiKey.message],
//     );
//   }
// }

class ErrorModel {
  final String detail;
  int? statusCodel;

  ErrorModel({required this.detail});

  factory ErrorModel.fromJson(Map<String, dynamic> jsonData) {
    String detailMessage;

    if (jsonData.containsKey('data') &&
        jsonData['data'] is Map<String, dynamic>) {
      // Extract the first error message from the 'data' map
      final dataMap = jsonData['data'] as Map<String, dynamic>;
      final firstErrorMessages = dataMap.values.first;
      if (firstErrorMessages is List && firstErrorMessages.isNotEmpty) {
        detailMessage = firstErrorMessages.first;
      } else {
        detailMessage = 'An unknown error occurred in the data field';
      }
    } else if (jsonData.containsKey('message') &&
        jsonData['message'] is Map<String, dynamic>) {
      // Extract the first error message from the 'message' map
      final messageMap = jsonData['message'] as Map<String, dynamic>;
      final firstErrorMessages = messageMap.values.first;
      if (firstErrorMessages is List && firstErrorMessages.isNotEmpty) {
        detailMessage = firstErrorMessages.first;
      } else {
        detailMessage = 'An unknown error occurred in the message field';
      }
    } else if (jsonData.containsKey('message') &&
        jsonData['message'] is String) {
      // Take the 'message' if it's a simple string
      detailMessage = jsonData['message'];
    } else {
      // Default message if neither 'data' nor 'message' are found
      detailMessage = 'An unknown error occurred';
    }

    return ErrorModel(
      detail: detailMessage,
    );
  }
}
