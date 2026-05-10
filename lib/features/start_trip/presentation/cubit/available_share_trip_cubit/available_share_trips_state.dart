part of 'available_share_trips_cubit.dart';

@immutable
sealed class AvailableShareTripsState {}

final class AvailableShareTripsInitial extends AvailableShareTripsState {}

final class AvailableShareTripsLoadingState extends AvailableShareTripsState {}

final class GetAvailableShareTripsLoadingState
    extends AvailableShareTripsState {}

final class GetAvailableShareTripsSuccessState
    extends AvailableShareTripsState {}

final class AvailableShareTripsErrorState extends AvailableShareTripsState {
  final String error;

  AvailableShareTripsErrorState({required this.error});
}

final class AvailableShareTripsSuccessState extends AvailableShareTripsState {
  final String message;

  AvailableShareTripsSuccessState({required this.message});
}

final class DriverAcceptTrip extends AvailableShareTripsState {
  final int tripId;

  DriverAcceptTrip({required this.tripId});
}
