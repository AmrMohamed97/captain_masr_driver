import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:captain_masr_driver/core/services/service_locator.dart';
import '../../data/models/notification_detail_model.dart';
import '../../data/repo/notifications_repo.dart';

part 'notification_detail_state.dart';

class NotificationDetailCubit extends Cubit<NotificationDetailState> {
  NotificationDetailCubit(this.notificationId)
      : super(NotificationDetailInitial()) {
    getDetail();
  }

  final String notificationId;
  NotificationDetailModel? detail;

  Future<void> getDetail() async {
    emit(NotificationDetailLoadingState());
    final result = await sl<NotificationsRepo>()
        .getNotificationById(id: notificationId);
    result.fold(
      (error) => emit(NotificationDetailErrorState(error: error)),
      (model) {
        detail = model;
        emit(NotificationDetailSuccessState());
      },
    );
  }
}
