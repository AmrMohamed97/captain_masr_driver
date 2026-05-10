part of 'find_driver_cubit.dart';

@immutable
sealed class FindDriverState {}

final class FindDriverInitial extends FindDriverState {}

final class BottomContainerExpandedToggleState extends FindDriverState {}

final class RecieveRequestState extends FindDriverState {}

final class FindDriverCancelTripLoadingState extends FindDriverState {}

final class FindDriverCancelTripErrorState extends FindDriverState {
  final String error;

  FindDriverCancelTripErrorState({required this.error});
}

final class FindDriverCancelTripSuccessState extends FindDriverState {
  final String message;

  FindDriverCancelTripSuccessState({required this.message});
}

final class RecieveDriverRequestState extends FindDriverState {}

final class AcceptDriverLoadingState extends FindDriverState {}

final class AcceptDriverErrorState extends FindDriverState {
  final String error;

  AcceptDriverErrorState({required this.error});
}

final class AcceptDriverSuccessState extends FindDriverState {
  final String message;
  final int driverId;

  AcceptDriverSuccessState({
    required this.message,
    required this.driverId,
  });
}
