part of 'global_cubit.dart';

@immutable
sealed class GlobalState {}

final class GlobalInitial extends GlobalState {}

final class SelectRoleState extends GlobalState {}

final class LanguageToggleState extends GlobalState {}

final class DarkModeToggleState extends GlobalState {}

final class DriverOnlineToggleState extends GlobalState {}

final class GetUserDataState extends GlobalState {}

final class UpdateUserDataLoadingState extends GlobalState {}

final class UpdateUserDataErrorState extends GlobalState {
  final String error;

  UpdateUserDataErrorState({required this.error});
}

final class UpdateUserDataSuccessState extends GlobalState {}

final class UpdateUserLocationState extends GlobalState {}


//driver today summary states
final class DriverTodaySummaryLoadingState extends GlobalState {}
final class DriverTodaySummaryErrorState extends GlobalState {
  final String error;

  DriverTodaySummaryErrorState({required this.error});
}
final class DriverTodaySummarySuccessState extends GlobalState {}
