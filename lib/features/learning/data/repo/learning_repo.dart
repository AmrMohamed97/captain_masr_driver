import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/databases/api/end_points.dart';

class LearningRepo {
  final DioConsumer api;

  LearningRepo(this.api);

  Future<String> getLearningUrl() async {
    final response = await api.post(EndPoints.getLearningUrl);
    return response.data['url'] as String;
  }

  Future<String> sendMessageToAdmin({
    required String contactType,
    required String contactValue,
    required String message,
  }) async {
    final response = await api.post(EndPoints.sendMessageToAdmin, data: {
      "contact_type": contactType,
      "contact_value": contactValue,
      "message": message,
    });
    return response.data['message'] as String;
  }
}