part of 'driver_trip_cubit.dart';

@immutable
sealed class DriverTripState {}

final class DriverTripInitial extends DriverTripState {}

final class DriverBottomContainerExpandedToggleState extends DriverTripState {}

final class DriverTripGetRouteLoadingState extends DriverTripState {}

final class DriverTripGetRouteSuccessState extends DriverTripState {}

final class DriverTimerState extends DriverTripState {
  final int counter;

  DriverTimerState({int? counter})
      : counter = counter ?? DateTime.now().millisecondsSinceEpoch;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DriverTimerState &&
          runtimeType == other.runtimeType &&
          counter == other.counter;

  @override
  int get hashCode => counter.hashCode;
}

final class DriverTripCompleteState extends DriverTripState {}

final class SelectTripCodeState extends DriverTripState {}

final class VerifyTripCodeState extends DriverTripState {}

final class SelectRiderState extends DriverTripState {}

final class OnMyWayRiderJoinRequestState extends DriverTripState {}

final class DriverTripLoadingState extends DriverTripState {}

final class DriverTripErrorState extends DriverTripState {
  final String error;

  DriverTripErrorState({required this.error});
}

final class DriverTripSuccessState extends DriverTripState {
  final String message;

  DriverTripSuccessState({required this.message});
}

final class DriverCancelTripSuccessState extends DriverTripState {
  final String message;

  DriverCancelTripSuccessState({required this.message});
}

final class DriverTripCancelledFromRiderState extends DriverTripState {}

final class DriverTripCompletedState extends DriverTripState {
  final CompleteTripResponseModel? completeTripResponseModel;
  final TripDetailsModel? tripDetails;
  DriverTripCompletedState({this.completeTripResponseModel, this.tripDetails});
}

final class NewRiderJoinState extends DriverTripState {
  final TripDetailsModel tripDetails;

  NewRiderJoinState({required this.tripDetails});
}

final class DriverCompleteShareTripState extends DriverTripState {}
