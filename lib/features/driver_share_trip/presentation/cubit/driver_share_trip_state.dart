part of 'driver_share_trip_cubit.dart';

@immutable
sealed class DriverShareTripState {}

final class DriverShareTripInitial extends DriverShareTripState {}

final class DriverShareBottomContainerExpandedToggleState extends DriverShareTripState {}

final class DriverShareTripGetRouteLoadingState extends DriverShareTripState {}

final class DriverShareTripGetRouteSuccessState extends DriverShareTripState {}

final class DriverShareTimerState extends DriverShareTripState {
  final int counter;

  DriverShareTimerState({int? counter})
      : counter = counter ?? DateTime.now().millisecondsSinceEpoch;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DriverShareTimerState &&
          runtimeType == other.runtimeType &&
          counter == other.counter;

  @override
  int get hashCode => counter.hashCode;
}

final class DriverShareTripCompleteState extends DriverShareTripState {}

final class SelectShareTripCodeState extends DriverShareTripState {}

final class VerifyShareTripCodeState extends DriverShareTripState {}

final class SelectShareRiderState extends DriverShareTripState {}

// final class OnMyWayShareRiderJoinRequestState extends DriverShareTripState {}

final class DriverShareTripLoadingState extends DriverShareTripState {}

final class DriverShareTripErrorState extends DriverShareTripState {
  final String error;

  DriverShareTripErrorState({required this.error});
}

final class DriverShareTripSuccessState extends DriverShareTripState {
  final String message;

  DriverShareTripSuccessState({required this.message});
}

final class DriverCancelShareTripSuccessState extends DriverShareTripState {
  final String message;

  DriverCancelShareTripSuccessState({required this.message});
}
final class DriverCancelShareTripForRiderSuccessState extends DriverShareTripState {
  final String message;

  DriverCancelShareTripForRiderSuccessState({required this.message});
}

final class DriverShareTripCancelledFromRiderState extends DriverShareTripState {}

final class DriverShareTripCompletedState extends DriverShareTripState {
  final CompleteTripResponseModel? completeTripResponseModel;
  final TripDetailsModel? tripDetails;
  DriverShareTripCompletedState({this.completeTripResponseModel, this.tripDetails});
}

final class NewShareRiderJoinState extends DriverShareTripState {
  final TripDetailsModel tripDetails;

  NewShareRiderJoinState({required this.tripDetails});
}

final class DriverShareCompleteShareTripState extends DriverShareTripState {}

final class DriverShareTravelTimeUpdatedState extends DriverShareTripState {}
