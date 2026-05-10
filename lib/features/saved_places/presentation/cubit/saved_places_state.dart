part of 'saved_places_cubit.dart';

@immutable
sealed class SavedPlacesState {}

final class SavedPlacesInitial extends SavedPlacesState {}

final class SavedPlacesSelectIconState extends SavedPlacesState {}

final class SaveLocationLoadingState extends SavedPlacesState {}

final class SaveLocationErrorState extends SavedPlacesState {
  final String error;

  SaveLocationErrorState({required this.error});
}

final class SaveLocationSuccessState extends SavedPlacesState {
  final String message;

  SaveLocationSuccessState({required this.message});
}

final class GetSavedLocationLoadingState extends SavedPlacesState {}

final class GetSavedLocationErrorState extends SavedPlacesState {
  final String error;

  GetSavedLocationErrorState({required this.error});
}

final class GetSavedLocationSuccessState extends SavedPlacesState {}

final class DeleteLocationLoadingState extends SavedPlacesState {}

final class DeleteLocationErrorState extends SavedPlacesState {
  final String error;

  DeleteLocationErrorState({required this.error});
}

final class DeleteLocationSuccessState extends SavedPlacesState {
  final String message;

  DeleteLocationSuccessState({required this.message});
}
