part of 'start_trip_cubit.dart';

@immutable
sealed class StartTripState {}

final class StartTripInitial extends StartTripState {}

final class GetCurrentLocationLoadingState extends StartTripState {}

final class GetCurrentLocationSuccessState extends StartTripState {}

final class StartTripIsFemaleToggleState extends StartTripState {}

final class GetStartTripTripDetailsState extends StartTripState {}

final class StartTripCheckPromoCodeState extends StartTripState {}

final class StartTripSelectLocationsState extends StartTripState {}

final class StartTripBottomContainerExpandedToggleState
    extends StartTripState {}

final class StartTripChangeSeatsNumberState extends StartTripState {}

final class CalculateEstimatedErrorState extends StartTripState {
  final String error;

  CalculateEstimatedErrorState({required this.error});
}

final class CalculateEstimatedSuccessState extends StartTripState {}

final class RiderRequestTripErrorState extends StartTripState {
  final String error;

  RiderRequestTripErrorState({required this.error});
}

final class RiderRequestTripSuccessState extends StartTripState {}

final class StartTripToggleState extends StartTripState {}

final class StartTripLoadingState extends StartTripState {}

final class StartTripErrorState extends StartTripState {
  final String error;

  StartTripErrorState({required this.error});
}

final class StartTripSuccessState extends StartTripState {}

final class DriverPostShareTripSuccessState extends StartTripState {
  final String message;
  final int tripId;

  DriverPostShareTripSuccessState({
    required this.message,
    required this.tripId,
  });
}

final class RiderSearchShareTripsSuccessState extends StartTripState {
  final AvailableShareTripsModel model;

  RiderSearchShareTripsSuccessState({required this.model});
}
