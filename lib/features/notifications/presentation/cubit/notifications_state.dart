part of 'notifications_cubit.dart';

@immutable
sealed class NotificationsState {}

final class NotificationsInitial extends NotificationsState {}

final class NotificationsLoadingState extends NotificationsState {}

final class NotificationsErrorState extends NotificationsState {
  final String error;

  NotificationsErrorState({required this.error});
}

final class NotificationsSuccessState extends NotificationsState {}
