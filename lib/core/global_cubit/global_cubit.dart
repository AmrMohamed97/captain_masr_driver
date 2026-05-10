import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../features/home/data/models/driver_today_summary_model.dart';
import '../../features/home/data/repo/home_repo.dart';
import '../../features/login/data/models/user_model.dart';
import '../../features/login/data/repo/login_repo.dart';
import '../../features/saved_places/data/models/saved_place_model.dart';
import '../imports/imports.dart';

part 'global_state.dart';

class GlobalCubit extends Cubit<GlobalState> {
  GlobalCubit() : super(GlobalInitial());

  Future<void> init() async {
    getFlow();
    await updateUserData();
    if (isDriver) {
      await checkDriverOnlineStatus();
    }
    getCurrentLocation();
    loadMapStyleJson();
  }

  //! User
  UserModel? userModel;

  Future<void> getUserData() async {
    final String? user = sl<Cache>().getStringData(AppConstants.user);
    if (user != null) {
      userModel = UserModel.fromJson(jsonDecode(user));
    } else {
      userModel = null;
    }
    emit(GetUserDataState());
  }

  Future<void> updateUserData() async {
    emit(UpdateUserDataLoadingState());
    if (sl<Cache>().getStringData(AppConstants.token) != null) {
      final result = await sl<LoginRepo>().getUserProfile(isRider: isRider);
      result.fold(
        (error) => emit(UpdateUserDataErrorState(error: error)),
        (model) {
          userModel = model;
          sl<Cache>().setData(AppConstants.user, jsonEncode(model.toJson()));
          emit(UpdateUserDataSuccessState());
        },
      );
    } else {
      getUserData();
    }
  }

  bool isRider = false;
  bool isDriver = false;

  void getFlow() {
    isRider =
        sl<Cache>().getStringData(AppConstants.role) == AppConstants.rider;
    isDriver =
        sl<Cache>().getStringData(AppConstants.role) == AppConstants.driver;

    emit(SelectRoleState());
  }

  void selectRole(String role) {
    switch (role) {
      case AppConstants.rider:
        isRider = true;
        isDriver = false;
        sl<Cache>().setData(AppConstants.role, AppConstants.rider);
        break;
      case AppConstants.driver:
        isDriver = true;
        isRider = false;
        sl<Cache>().setData(AppConstants.role, AppConstants.driver);
        break;
      default:
    }
    emit(SelectRoleState());
  }

  //! Language
  String language = sl<Cache>().getLanguage();

  void languageToggle() {
    switch (language) {
      case "en":
        language = "ar";
        sl<Cache>().setData(AppConstants.language, language);
        break;
      case "ar":
        language = "en";
        sl<Cache>().setData(AppConstants.language, language);
        break;
      default:
    }
    emit(LanguageToggleState());
  }

  //! Nav Bar
  PersistentTabController navBarController = PersistentTabController();

  //! Drawer
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  //! Dark Mode
  bool isDarkMode = sl<Cache>().getBoolData(AppConstants.darkMode) ?? false;

  void darkModeToggle() {
    isDarkMode = !isDarkMode;
    sl<Cache>().setData(AppConstants.darkMode, isDarkMode);
    emit(DarkModeToggleState());
  }

  //! Map Dark Style
  String? mapDarkStyle;

  Future<void> loadMapStyleJson() async {
    final jsonString =
        await rootBundle.loadString('assets/json/dark_map_style.json');
    mapDarkStyle = await compute(parseMapStyle, jsonString);
  }

  //! Phone Link Launcher
  Future<void> phoneLinkLauncher(String number) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: number);
    if (!await launchUrl(phoneUri)) {
      throw "Could not launch $phoneUri";
    }
  }

  //! Driver Online
  bool driverOnline = false;

  Future<void> checkDriverOnlineStatus() async {
    if (isDriver && userModel?.id != null) {
      try {
        final db = FirebaseDatabase.instance.ref(
          "driver_locations/${userModel!.id}/status",
        );

        final snapshot = await db.get();
        if (snapshot.exists) {
          final status = snapshot.value.toString();
          driverOnline = status == "online";
          emit(DriverOnlineToggleState());

          // If the driver closed the app while online, resume background stream
          if (driverOnline) {
            startUpdatingDriverLocation();
          }
        } else {
          driverOnline = false;
          emit(DriverOnlineToggleState());
        }
      } catch (e) {
        if (!kReleaseMode) log("Check Driver Online Status Error: $e");
        driverOnline = false;
        emit(DriverOnlineToggleState());
      }
    }
  }

  void driverOnlineToggle() {
    driverOnline = !driverOnline;
    emit(DriverOnlineToggleState());
    if (driverOnline) {
      startUpdatingDriverLocation();
    } else {
      _locationSubscription?.cancel();
      stopUpdatingDriverLocation();
    }
  }

  //! User Location
  LatLng? userLocation;
  String? userLocationName;
  Timer? locationTimer;
  StreamSubscription<LocationData>? _locationSubscription;

  Future<void> setRiderLoction(SavedPlaceModel model) async {
    if (model.lat != null && model.long != null) {
      try {
        userLocation =
            LatLng(double.parse(model.lat!), double.parse(model.long!));
        userLocationName = model.type;
        emit(UpdateUserLocationState());
      } catch (e) {
        log("Set Location Error: $e");
      }
    }
  }

  Future<bool> getCurrentLocation() async {
    final Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    LocationData? locationData;
    try {
      // 1. Attempt High Accuracy (GPS) for real devices outdoors
      await location.changeSettings(accuracy: LocationAccuracy.high);
      locationData = await location.getLocation().timeout(
            const Duration(seconds: 4),
          );
    } catch (_) {
      try {
        // 2. If GPS lock fails (e.g. indoors), FORCE device to return Network/Cell location
        await location.changeSettings(accuracy: LocationAccuracy.low);
        locationData = await location.getLocation().timeout(
              const Duration(seconds: 4),
            );
      } catch (e) {
        if (!kReleaseMode) log("Completely failed to force location: $e");
      }
    }

    if (locationData != null &&
        locationData.latitude != null &&
        locationData.longitude != null) {
      userLocation = LatLng(locationData.latitude!, locationData.longitude!);

      try {
        final List<geocoding.Placemark> placemarks =
            await geocoding.placemarkFromCoordinates(
                userLocation!.latitude, userLocation!.longitude);

        if (placemarks.isNotEmpty) {
          final geocoding.Placemark place = placemarks[0];
          userLocationName =
              '${place.street}, ${place.locality}, ${place.subLocality}, ${place.country}';
        }
      } catch (e) {
        if (!kReleaseMode) log("Geocoding failed: $e");
      }
    }

    // Restore high accuracy for subsequent stream listeners if needed
    await location.changeSettings(accuracy: LocationAccuracy.high);

    emit(UpdateUserLocationState());
    return true;
  }

  Future<void> updateDriverLocation() async {
    try {
      if (userModel?.id != null && userLocation != null) {
        final db = FirebaseDatabase.instance.ref(
          "driver_locations/${userModel!.id}",
        );

        await db.set({
          "latitude": userLocation!.latitude,
          "longitude": userLocation!.longitude,
          "status": "online",
        });
      }
    } catch (e) {
      log("Update Driver Location Error: $e");
    }
  }

  DateTime? _lastLocationUpdateTime;
  DateTime? _lastUiUpdateTime;
  LatLng? _lastEmittedLocation;

  //! Start updating driver location
  void startUpdatingDriverLocation() async {
    _lastLocationUpdateTime = null;
    _lastUiUpdateTime = null;
    _lastEmittedLocation = null;
    locationTimer?.cancel();
    _locationSubscription?.cancel();

    // We MUST check and request permissions first before starting native streams
    final bool hasPermission = await getCurrentLocation();
    if (!hasPermission) return;

    final Location location = Location();
    await location.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 10000, // 10 seconds
      distanceFilter: 20, // 20 meters
    );

    await updateDriverLocation();

    // Stream updates
    _locationSubscription = location.onLocationChanged.listen((locationData) {
      if (locationData.latitude != null && locationData.longitude != null) {
        userLocation = LatLng(locationData.latitude!, locationData.longitude!);

        final now = DateTime.now();

        // التحقق من أن السائق تحرك مسافة كافية (لإلغاء تحديثات الـ GPS الوهمية أثناء الوقوف)
        final bool hasMovedSignificantly = _lastEmittedLocation == null ||
            (userLocation!.latitude - _lastEmittedLocation!.latitude).abs() >
                0.00005 ||
            (userLocation!.longitude - _lastEmittedLocation!.longitude).abs() >
                0.00005;

        // إذا كان يتحرك أو سرعته تعني أنه يقود
        if (hasMovedSignificantly ||
            (locationData.speed != null && locationData.speed! > 1.0)) {
          // (السطر المنقذ للأداء) تحديث الواجهة والخريطة مرة كل مسافة أو ثانيتين لتقليل ثقل التطبيق
          // if (_lastUiUpdateTime == null || now.difference(_lastUiUpdateTime!).inMilliseconds >= 10000) {
          _lastEmittedLocation = userLocation;
          emit(UpdateUserLocationState());
          _lastUiUpdateTime = now;
          // }

          // تحديث قاعدة البيانات Firebase حسب ما حددناه مسبقاً (10 ثواني)
          if (_lastLocationUpdateTime == null ||
              now.difference(_lastLocationUpdateTime!).inSeconds >= 10) {
            updateDriverLocation();
            _lastLocationUpdateTime = now;
          }
        }
      }
    });

    // Fallback timer for stationary updates if needed (every 5 minutes)
    // Fallback timer for stationary updates if needed (every 5 minutes)
    locationTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      if (driverOnline) {
        if (userLocation != null) {
          // هنا نرسل الموقع المحفوظ مسبقاً للسيرفر فقط لنثبت أننا متصلون (بدون تشغيل الـ GPS)
          updateDriverLocation();
        } else {
          getCurrentLocation();
          updateDriverLocation();
        }
      }
    });
  }

  //! Stop updating driver location
  void stopUpdatingDriverLocation() {
    if (userModel?.id != null) {
      final db = FirebaseDatabase.instance.ref(
        "driver_locations/${userModel!.id}",
      );

      db.set({
        "latitude": userLocation?.latitude,
        "longitude": userLocation?.longitude,
        "status": "offline",
      });
    }
    locationTimer?.cancel();
    _locationSubscription?.cancel();
  }

  // Driver trips number
  DriverTodaySummaryModel? driverTodaySummary;

  Future<void> getDriverTodaySummary() async {
    if (isDriver) {
      emit(DriverTodaySummaryLoadingState());
      final result = await sl<HomeRepo>().driverTodaySummary();
      result.fold(
        (error) => emit(DriverTodaySummaryErrorState(error: error)),
        (model) {
          driverTodaySummary = model;
          emit(DriverTodaySummarySuccessState());
        },
      );
    }
  }
}

String parseMapStyle(String jsonString) {
  return jsonString;
}
