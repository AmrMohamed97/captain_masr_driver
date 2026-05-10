part of 'rider_share_trip_cubit.dart';

sealed class RiderShareTripState {}

final class RiderShareTripInitial extends RiderShareTripState {}

final class RideShareBottomContainerExpandedToggleState extends RiderShareTripState {}

final class GetRouteShareLoadingState extends RiderShareTripState {}

final class GetRouteShareSuccessState extends RiderShareTripState {}

final class RideShareTimerState extends RiderShareTripState {
  final int counter;

  RideShareTimerState({int? counter})
      : counter = counter ?? DateTime.now().millisecondsSinceEpoch;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RideShareTimerState &&
          runtimeType == other.runtimeType &&
          counter == other.counter;

  @override
  int get hashCode => counter.hashCode;
}

final class RideShareCompleteState extends RiderShareTripState {
  final TripDetailsModel? tripDetails;
  RideShareCompleteState({ this.tripDetails});
}

final class AlmostShareArriveState extends RiderShareTripState {}

final class NewShareRiderJoinState extends RiderShareTripState {}

final class NewShareRequestsUpdateState extends RiderShareTripState {}

final class RiderShareTripLoadingState extends RiderShareTripState {}

final class RiderShareCancelTripErrorState extends RiderShareTripState {
  final String error;

  RiderShareCancelTripErrorState({required this.error});
}

final class RiderShareCancelTripSuccessState extends RiderShareTripState {
  final String message;

  RiderShareCancelTripSuccessState({required this.message});
}

final class RiderShareTripCancelledFromDriverState extends RiderShareTripState {}
