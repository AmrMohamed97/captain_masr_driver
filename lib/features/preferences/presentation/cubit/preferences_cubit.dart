import '../../../../core/imports/imports.dart';
import '../../data/repo/preferences_repo.dart';

part 'preferences_state.dart';

class PreferencesCubit extends Cubit<PreferencesState> {
  PreferencesCubit() : super(PreferencesInitial());

  init(bool isGet) {
    if (isGet) {
      getPreferences();
    }
  }

  //! Get Preferences
  Future<void> getPreferences() async {
    emit(GetPreferencesLoadingState());
    final result = await sl<PreferencesRepo>().getPreferences();
    result.fold(
      (error) => emit(GetPreferencesErrorState()),
      (model) {
        airConditioner = model.coolRide;
        quiet = model.quietRide;
        smoking = model.smokingFriendly;
        pets = model.petsFree;
        emit(GetPreferencesSuccessState());
      },
    );
  }

  //! save Preference
  Future<void> savePreferences() async {
    emit(SavePreferencesLoadingState());
    final result = await sl<PreferencesRepo>().savePreferences(
      coolRide: airConditioner,
      quietRide: quiet,
      smokingFriendly: smoking,
      petsFree: pets,
    );
    result.fold(
      (error) => emit(SavePreferencesErrorState(error: error)),
      (message) => emit(SavePreferencesSuccessState(message: message)),
    );
  }

  //! Form
  bool airConditioner = false;
  bool quiet = false;
  bool smoking = false;
  bool pets = false;

  bool isEdit = false;
  bool isDialog = false;
  bool canEdit = true;

  switchToggle() {
    emit(PreferenceSwitchToggleState());
  }
}
