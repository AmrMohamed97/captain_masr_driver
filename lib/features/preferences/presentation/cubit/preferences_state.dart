part of 'preferences_cubit.dart';

@immutable
sealed class PreferencesState {}

final class PreferencesInitial extends PreferencesState {}

final class PreferenceSwitchToggleState extends PreferencesState {}

final class SavePreferencesLoadingState extends PreferencesState {}

final class SavePreferencesErrorState extends PreferencesState {
  final String error;

  SavePreferencesErrorState({required this.error});
}

final class SavePreferencesSuccessState extends PreferencesState {
  final String message;

  SavePreferencesSuccessState({required this.message});
}

final class GetPreferencesLoadingState extends PreferencesState {}

final class GetPreferencesErrorState extends PreferencesState {}

final class GetPreferencesSuccessState extends PreferencesState {}
