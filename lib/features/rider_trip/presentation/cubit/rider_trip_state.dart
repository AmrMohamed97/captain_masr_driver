part of 'rider_trip_cubit.dart';

@immutable
sealed class RiderTripState {}

final class RiderTripInitial extends RiderTripState {}

final class RideBottomContainerExpandedToggleState extends RiderTripState {}

final class GetRouteLoadingState extends RiderTripState {}

final class GetRouteSuccessState extends RiderTripState {}

final class RideTimerState extends RiderTripState {
  final int counter;

  RideTimerState({int? counter})
      : counter = counter ?? DateTime.now().millisecondsSinceEpoch;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RideTimerState &&
          runtimeType == other.runtimeType &&
          counter == other.counter;

  @override
  int get hashCode => counter.hashCode;
}

final class RideCompleteState extends RiderTripState {}

final class AlmostArriveState extends RiderTripState {}

final class NewRiderJoinState extends RiderTripState {}

final class NewRequestsUpdateState extends RiderTripState {}

final class RiderTripLoadingState extends RiderTripState {}

final class RiderCancelTripErrorState extends RiderTripState {
  final String error;

  RiderCancelTripErrorState({required this.error});
}

final class RiderCancelTripSuccessState extends RiderTripState {
  final String message;

  RiderCancelTripSuccessState({required this.message});
}

final class RiderTripCancelledFromDriverState extends RiderTripState {}
