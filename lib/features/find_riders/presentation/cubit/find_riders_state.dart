part of 'find_riders_cubit.dart';

@immutable
sealed class FindRidersState {}

final class FindRidersInitial extends FindRidersState {}
final class RealTimeErrorState extends FindRidersState {}

final class FindRidersGetCurrentLocationLoadingState extends FindRidersState {}

final class FindRidersGetCurrentLocationSuccessState extends FindRidersState {}

final class RiderRequestsCountChangedState extends FindRidersState {}

final class RiderRequestRecievedState extends FindRidersState {}

final class RiderRemovedRecievedState extends FindRidersState {}

final class AcceptRequestLoadingState extends FindRidersState {}

final class AcceptRequestErrorState extends FindRidersState {
  final String error;

  AcceptRequestErrorState({required this.error});
}

final class AcceptRequestSuccessState extends FindRidersState {
  final String message;

  AcceptRequestSuccessState({required this.message});
}

final class RequestAcceptedState extends FindRidersState {
  final int tripId;
  final String? tripType;

  RequestAcceptedState({
    required this.tripId,
    required this.tripType,
  });
}
