part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class SplashOnChangeState extends HomeState {}

final class HomePreferencesToggleState extends HomeState {}

final class HomeLoadingState extends HomeState {}

final class HomeErrorState extends HomeState {
  final String? error;

  HomeErrorState({this.error});
}

final class HomeSuccessState extends HomeState {}

final class GetRecentTripsLoadingState extends HomeState {}

final class SlidersLoadingState extends HomeState {}

final class DriverTodaySummaryLoadingState extends HomeState {}
