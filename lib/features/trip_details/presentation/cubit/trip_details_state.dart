part of 'trip_details_cubit.dart';

@immutable
sealed class TripDetailsState {}

final class TripDetailsInitial extends TripDetailsState {}

final class BookingChangeSeatsNumState extends TripDetailsState {}

final class BookingTripPickState extends TripDetailsState {}

final class BookingGoingAndReturningToggleState extends TripDetailsState {}

final class BookingTripCheckPromoCodeState extends TripDetailsState {}

final class BookingDetailsSelectRiderState extends TripDetailsState {}

final class TripDetailsLoadingState extends TripDetailsState {}

final class TripDetailsErrorState extends TripDetailsState {
  final String error;

  TripDetailsErrorState({required this.error});
}

final class TripDetailsSuccessState extends TripDetailsState {}
