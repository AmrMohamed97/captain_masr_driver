part of 'choose_location_cubit.dart';

@immutable
sealed class ChooseLocationState {}

final class ChooseLocationInitial extends ChooseLocationState {}

final class ChooseStartAndEndLocationState extends ChooseLocationState {}

final class GetSuggestionsLoadingState extends ChooseLocationState {}

final class GetSuggestionsErrorState extends ChooseLocationState {}

final class GetSuggestionsSuccessState extends ChooseLocationState {}

final class StopState extends ChooseLocationState {}

final class ChooseLocationsClearState extends ChooseLocationState {}

final class ChooseLocationSelectIndexState extends ChooseLocationState {}

final class SelectLocationState extends ChooseLocationState {}

final class ChooseLocationGetCurrentLocationLoadingState
    extends ChooseLocationState {}

final class ChooseLocationGetCurrentLocationSuccessState
    extends ChooseLocationState {}

final class GetCurrentAddressLoadingState extends ChooseLocationState {}

final class GetCurrentAddressSuccessState extends ChooseLocationState {}

final class GetSavedLocationsLoadingState extends ChooseLocationState {}

final class ChooseLocationErrorState extends ChooseLocationState {
  final String error;
  ChooseLocationErrorState({required this.error});
}

final class ChooseLocationSuccessState extends ChooseLocationState {}
