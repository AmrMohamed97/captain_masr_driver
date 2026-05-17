part of 'notification_detail_cubit.dart';

sealed class NotificationDetailState {}

final class NotificationDetailInitial extends NotificationDetailState {}

final class NotificationDetailLoadingState extends NotificationDetailState {}

final class NotificationDetailSuccessState extends NotificationDetailState {}

final class NotificationDetailErrorState extends NotificationDetailState {
  final String error;
  NotificationDetailErrorState({required this.error});
}
