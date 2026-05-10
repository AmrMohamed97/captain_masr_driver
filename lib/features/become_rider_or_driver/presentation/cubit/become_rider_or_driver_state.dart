part of 'become_rider_or_driver_cubit.dart';

@immutable
sealed class BecomeRiderOrDriverState {}

final class BecomeRiderOrDriverInitial extends BecomeRiderOrDriverState {}

final class BecomeRiderOrDriverLoadingState extends BecomeRiderOrDriverState {}

final class BecomeRiderOrDriverSuccessState extends BecomeRiderOrDriverState {}

final class BecomeRiderOrDriverErrorState extends BecomeRiderOrDriverState {
  final String error;

  BecomeRiderOrDriverErrorState({required this.error});
}

final class BecomeRiderSuccessState extends BecomeRiderOrDriverState {
  final String message;
  BecomeRiderSuccessState({required this.message});
}

final class BecomeDriverSuccessState extends BecomeRiderOrDriverState {
  final String message;
  BecomeDriverSuccessState({required this.message});
}
