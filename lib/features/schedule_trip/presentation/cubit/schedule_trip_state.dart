part of 'schedule_trip_cubit.dart';

@immutable
sealed class ScheduleTripState {}

final class ScheduleTripInitial extends ScheduleTripState {}

final class ScheduleTabBarToggleState extends ScheduleTripState {}

final class ScheduleTripPickState extends ScheduleTripState {}

final class GetCostPerSeatState extends ScheduleTripState {}

final class ChangeRequestsTabIndexState extends ScheduleTripState {}

final class DriverPostScheduleTripSuccessState extends ScheduleTripState {
  final TripDetailsModel trip;

  DriverPostScheduleTripSuccessState({required this.trip});
}

final class UserRequestScheduledTripSuccessState extends ScheduleTripState {}

final class ScheduleTripErrorState extends ScheduleTripState {
  final String errorMessage;

  ScheduleTripErrorState(this.errorMessage);
}

final class ScheduleTripLoadingState extends ScheduleTripState {}

final class ScheduleTripSuccessState extends ScheduleTripState {
  final String? message;

  ScheduleTripSuccessState({this.message});
}

final class DriverCancelScheduleSuccess extends ScheduleTripState {
  final String message;

  DriverCancelScheduleSuccess({required this.message});
}

final class DriverStartScheduleTripSuccessState extends ScheduleTripState {
  final String message;
  final int tripId;

  DriverStartScheduleTripSuccessState({
    required this.message,
    required this.tripId,
  });
}

final class TodayStatusChangedState extends ScheduleTripState {}
final class CalculateShareEstimatedErrorState extends ScheduleTripState {
  final String message;

  CalculateShareEstimatedErrorState({
    required this.message,
  });
}

final class CalculateShareEstimatedSuccessState extends ScheduleTripState {}
final class CalculateShareEstimatedLoadingState extends ScheduleTripState {}
