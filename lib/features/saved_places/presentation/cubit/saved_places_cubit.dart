import '../../../../core/imports/imports.dart';
import '../../data/models/saved_place_model.dart';
import '../../data/repo/saved_places_repo.dart';

part 'saved_places_state.dart';

class SavedPlacesCubit extends Cubit<SavedPlacesState> {
  SavedPlacesCubit() : super(SavedPlacesInitial());

  //! Get Saved Locations
  List<SavedPlaceModel> savedLocations = [];

  Future<void> getSavedLocations() async {
    emit(GetSavedLocationLoadingState());
    final result = await sl<SavedPlacesRepo>().getSavedLocations();
    result.fold(
      (error) => emit(GetSavedLocationErrorState(error: error)),
      (list) {
        savedLocations = list;
        emit(GetSavedLocationSuccessState());
      },
    );
  }

  //! Save Location
  double? lat, long;
  Future<void> saveLocation() async {
    emit(SaveLocationLoadingState());
    final result = await sl<SavedPlacesRepo>().saveLocation(
      type: placeNameController.text,
      address: placeLocationController.text,
      lat: lat.toString(),
      long: long.toString(),
      iconType: selectedIconIndex != null ? (selectedIconIndex! + 1) : null,
    );
    result.fold(
      (error) => emit(SaveLocationErrorState(error: error)),
      (message) => emit(SaveLocationSuccessState(message: message)),
    );
  }

  //! Edit Location
  initEdit(SavedPlaceModel? model) {
    if (model != null) {
      placeNameController.text = model.type ?? "";
      placeLocationController.text = model.address ?? "";
      lat = double.parse(model.lat ?? "0");
      long = double.parse(model.long ?? "0");
      selectedIconIndex =
          model.iconType != null ? ((int.parse(model.iconType!)) - 1) : null;
    }
  }

  Future<void> editLocation({required int id}) async {
    emit(SaveLocationLoadingState());
    final result = await sl<SavedPlacesRepo>().editLocation(
      id: id,
      type: placeNameController.text,
      address: placeLocationController.text,
      lat: lat.toString(),
      long: long.toString(),
      iconType: selectedIconIndex != null ? (selectedIconIndex! + 1) : null,
    );
    result.fold(
      (error) => emit(SaveLocationErrorState(error: error)),
      (message) => emit(SaveLocationSuccessState(message: message)),
    );
  }

  //! Delete Location
  Future<void> deleteLocation(int index) async {
    emit(DeleteLocationLoadingState());
    final result = await sl<SavedPlacesRepo>().deleteSavedLocation(
      locationId: savedLocations[index].id ?? 0,
    );
    result.fold(
      (error) => emit(DeleteLocationErrorState(error: error)),
      (message) {
        savedLocations.removeAt(index);
        emit(DeleteLocationSuccessState(message: message));
      },
    );
  }

  bool canChoose = false;

  //! Form
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController placeNameController = TextEditingController();
  TextEditingController placeLocationController = TextEditingController();

  //! Icons
  int? selectedIconIndex;

  List<String> svgIcons = [
    Assets.imagesHomeActive,
    Assets.imagesSchool,
    Assets.imagesWork,
    Assets.imagesAirplane,
    Assets.imagesCafe,
  ];

  selectIcon(int index) {
    selectedIconIndex = index;
    emit(SavedPlacesSelectIconState());
  }
}
