import 'dart:convert';

import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart';

import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/imports/imports.dart';
import '../../../saved_places/data/models/saved_place_model.dart';
import '../../../saved_places/data/repo/saved_places_repo.dart';
import '../../data/models/selected_location_model.dart';

part 'choose_location_state.dart';

enum SelectionMode { pickup, destination }

class ChooseLocationCubit extends Cubit<ChooseLocationState> {
  ChooseLocationCubit({
    required this.isRider,
    required this.selectionMode,
  }) : super(ChooseLocationInitial()) {
    selectedIndex = selectionMode == SelectionMode.pickup ? 0 : 1;
  }

  bool isRider;
  final SelectionMode selectionMode;

  //! Get Saved Locations
  List<SavedPlaceModel> savedLocations = [];
  Future<void> getSavedLocations() async {
    if (!isRider) {
      return;
    }
    emit(GetSavedLocationsLoadingState());
    final result = await sl<SavedPlacesRepo>().getSavedLocations();
    result.fold((error) => emit(ChooseLocationErrorState(error: error)), (
      list,
    ) {
      savedLocations = list;
      emit(ChooseLocationSuccessState());
    });
  }

  bool isActive = true;
  @override
  Future<void> close() {
    isActive = false;
    return super.close();
  }

  int selectedIndex = 0;

  selectIndexToggle(int index) {
    selectedIndex = index;
    emit(ChooseLocationSelectIndexState());
  }

  TextEditingController startLocationController = TextEditingController();
  TextEditingController endLocationController = TextEditingController();

  SelectedLocationModel? selectedStartLocation;
  SelectedLocationModel? selectedEndLocation;

  List suggestions = [];

  clearSuggestions() {
    suggestions.clear();
    emit(ChooseLocationsClearState());
  }

  void getSuggestions(String input) async {
    if (!isActive) return;
    emit(GetSuggestionsLoadingState());

    if (input.isEmpty) {
      suggestions = [];
      if (!isActive) return;
      emit(GetSuggestionsSuccessState());
      return;
    }

    try {
      final response = await sl<DioConsumer>().get(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json',
        queryParameters: {
          'input': input,
          'types': 'geocode',
          'key': "AIzaSyCuOWpUhowE4hXXmyFi0P_2wlCBQu6cFt4",
        },
      );

      if (response.data['status'] == 'OK') {
        suggestions = response.data['predictions'];
        if (!isActive) return;
        emit(GetSuggestionsSuccessState());
      } else {
        suggestions = [];
        if (!isActive) return;
        emit(GetSuggestionsErrorState());
      }
    } catch (e) {
      suggestions = [];
      if (!isActive) return;
      emit(GetSuggestionsErrorState());
    }
  }

  String? addressName;
  getCurrentAddress({required double lat, required double long}) async {
    address = null;
    emit(GetCurrentAddressLoadingState());
    final List<geocoding.Placemark> placemarks =
        await geocoding.placemarkFromCoordinates(lat, long);

    final geocoding.Placemark place = placemarks[0];

    addressName =
        '${place.street}, ${place.locality}, ${place.subLocality}, ${place.country}';
    emit(GetCurrentAddressSuccessState());
  }

  Future<Map<String, dynamic>> fetchPlaceDetails({
    required String placeId,
    required String description,
  }) async {
    const apiKey = AppConstants.mapApiKey;
    try {
      final response = await sl<DioConsumer>().get(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey',
      );
      final json = jsonDecode(response.toString());
      if (json['status'] == 'OK') {
        final location = json['result']['geometry']['location'];
        selectLocation(
          model: SelectedLocationModel(
            address: description,
            lat: location['lat'],
            lon: location['lng'],
          ),
        );
        return {'lat': location['lat'], 'lng': location['lng']};
      } else {
        return {'lat': 0.0, 'lng': 0.0};
      }
    } catch (e) {
      return {'lat': 0.0, 'lng': 0.0};
    }
  }

  //! Stops
  List<int> stops = [];
  List<TextEditingController> stopsControllers = [];
  List<SelectedLocationModel> stopsSelectedLocations = [];

  addStop() {
    stops.add((stops.isNotEmpty ? stops.last : 0) + 1);
    stopsControllers.add(TextEditingController());
    stopsSelectedLocations.add(
      SelectedLocationModel(address: null, lat: null, lon: null),
    );
    emit(StopState());
  }

  removeStop(int index) {
    stops.removeAt(index);
    stopsControllers.removeAt(index);
    stopsSelectedLocations.removeAt(index);
    emit(StopState());
  }

  //! Recent Locations
  List<SelectedLocationModel> recentLocations = [];

  void getRecentLocations() {
    final String? stringJson = sl<Cache>().getStringData(
      AppConstants.recentLocations,
    );
    if (stringJson != null) {
      recentLocations =
          (jsonDecode(stringJson)[AppConstants.recentLocations] as List?)
                  ?.map((e) => SelectedLocationModel.fromJson(e))
                  .toList() ??
              [];
      emit(ChooseLocationSuccessState());
    }
  }

  selectLocation({required SelectedLocationModel model}) {
    suggestions.clear();
    if (selectedIndex == 0) {
      selectedStartLocation = model;
      startLocationController.text =
          model.address ?? "${model.lat ?? 0}, ${model.lon ?? 0}";
    } else if (selectedIndex == 1) {
      selectedEndLocation = model;
      endLocationController.text =
          model.address ?? "${model.lat ?? 0}, ${model.lon ?? 0}";
    } else {
      stopsSelectedLocations[selectedIndex - 2] = model;
      stopsControllers[selectedIndex - 2].text =
          model.address ?? "${model.lat ?? 0}, ${model.lon ?? 0}";
    }
    emit(SelectLocationState());
  }

  double? latitude;
  double? longitude;
  String? address;

  //! Get Current Location
  Future<void> getCurrentLocation() async {
    if (!isActive) return;
    emit(ChooseLocationGetCurrentLocationLoadingState());

    // Get the device's current location using the location package
    final Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return; // location service not enabled
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return; // permission not granted
      }
    }

    // Get the current location
    final LocationData locationData = await location.getLocation();

    latitude = locationData.latitude;
    longitude = locationData.longitude;

    if (!isActive) return;
    emit(ChooseLocationGetCurrentLocationSuccessState());
  }

  passLocations({
    required SelectedLocationModel? startLocation,
    required SelectedLocationModel? endLocation,
    required List<SelectedLocationModel> stopsLocations,
  }) {
    if (startLocation != null) {
      selectedStartLocation = startLocation;
      startLocationController.text = startLocation.address ??
          "${startLocation.lat ?? 0}, ${startLocation.lon ?? 0}";
    }
    if (endLocation != null) {
      selectedEndLocation = endLocation;
      endLocationController.text = endLocation.address ??
          "${endLocation.lat ?? 0}, ${endLocation.lon ?? 0}";
    }
    if (stopsLocations.isNotEmpty) {
      for (var i in stopsLocations) {
        stops.add((stops.isNotEmpty ? stops.last : 0) + 1);
        stopsControllers.add(
          TextEditingController(
            text: i.address ?? "${i.lat ?? 0}, ${i.lon ?? 0}",
          ),
        );
        stopsSelectedLocations.add(i);
      }
    }
  }
}
