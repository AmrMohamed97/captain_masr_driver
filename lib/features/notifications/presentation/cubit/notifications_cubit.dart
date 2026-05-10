import '../../../../core/imports/imports.dart';
import '../../../base/data/models/pagination_model.dart';
import '../../data/models/notification_model.dart';
import '../../data/repo/notifications_repo.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsInitial()) {
    getNotifications();
    initPagination();
  }

  //! Pagination
  ScrollController scrollController = ScrollController();
  PaginationModel? pagination;
  int page = 0;

  void initPagination() {
    const double scrollThreshold = 200.0;
    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
              (scrollController.position.maxScrollExtent - scrollThreshold) &&
          state is! NotificationsLoadingState) {
        if ((pagination?.lastPage ?? 0) > page) {
          getNotifications();
        }
      }
    });
  }

  //! Notifications
  List<NotificationModel> notifications = [];

  Future<void> getNotifications() async {
    emit(NotificationsLoadingState());
    final result = await sl<NotificationsRepo>().getNotifications(
      page: page + 1,
    );
    result.fold(
      (error) => emit(NotificationsErrorState(error: error)),
      (model) {
        notifications += model.notifications;
        pagination = model.pagination;
        page += 1;
        emit(NotificationsSuccessState());
      },
    );
  }
}
