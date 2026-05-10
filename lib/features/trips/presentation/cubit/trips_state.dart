part of 'trips_cubit.dart';

@immutable
sealed class TripsState {}

final class TripsInitial extends TripsState {}

final class TripsSelectTapBarState extends TripsState {}

final class TripsLoadingState extends TripsState {}

final class TripsErrorState extends TripsState {
  final String error;

  TripsErrorState({required this.error});
}

final class TripsSuccessState extends TripsState {
  final String? message;

  TripsSuccessState({this.message});
}

final class TripsCancelTripLoadingState extends TripsState {}
