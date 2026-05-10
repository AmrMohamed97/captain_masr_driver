import '../../../../core/imports/imports.dart';
import '../../../rider_trip/data/models/trip_details_model.dart';
import '../../../trips/data/repo/trips_repo.dart';
import '../../data/models/driver_today_summary_model.dart';
import '../../data/repo/home_repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required bool isDriver,
  }) : super(HomeInitial()) {
    init(isDriver);
  }

  Future<void> init(bool isDriver) async {
    await getSliders();
    if (isDriver) {
      // await getDriverTodaySummary();
      await getDriverTripTypes();
      await getDriverPreferences();
    }
    getRecentTrips(isDriver: isDriver);
  }

  //! Slider
  List<String>? sliders;

  Future<void> getSliders() async {
    emit(SlidersLoadingState());
    final result = await sl<HomeRepo>().getSliders();
    result.fold(
      (error) => emit(HomeErrorState(error: error)),
      (list) {
        sliders = list;
        emit(HomeSuccessState());
      },
    );
  }

  //! Get Recent Trips
  List<TripDetailsModel> recentTrips = [];

  Future<void> getRecentTrips({required bool isDriver}) async {
    emit(GetRecentTripsLoadingState());
    final result = await sl<TripsRepo>().getCompletedTrips(
      page: 1,
      isRider: !isDriver,
      limit: 2,
    );
    result.fold(
      (error) => emit(HomeErrorState(error: error)),
      (model) {
        recentTrips = model.data as List<TripDetailsModel>;
        emit(HomeSuccessState());
      },
    );
  }

  //! Driver Today Summary
  // DriverTodaySummaryModel? driverTodaySummary;

  // Future<void> getDriverTodaySummary() async {
  //   emit(DriverTodaySummaryLoadingState());
  //   final result = await sl<HomeRepo>().driverTodaySummary();
  //   result.fold(
  //     (error) => emit(HomeErrorState(error: error)),
  //     (model) {
  //       driverTodaySummary = model;
  //       emit(HomeSuccessState());
  //     },
  //   );
  // }

  //! Driver Trip Types
  List<int> driverTripTypes = [];
  Future<void> getDriverTripTypes() async {
    emit(HomeLoadingState());
    final result = await sl<HomeRepo>().driverTripTypes();
    result.fold((error) => emit(HomeErrorState(error: error)), (list) {
      driverTripTypes = list;
      emit(HomeSuccessState());
    });
  }

  //! Get Driver Preferences
  Future<void> getDriverPreferences() async {
    emit(HomeLoadingState());
    final result = await sl<HomeRepo>().getDriverPreferences();
    result.fold(
      (error) => emit(HomeErrorState()),
      (model) {
        classicRides = model.classicRide;
        shareRides = model.shareTrip;
        groupRides = model.groupTrip;
        deliveryRides = model.delivery;
      },
    );
  }

  //! Save Driver Preferences
  Future<void> saveDriverPreferences() async {
    await sl<HomeRepo>().saveDriverPreferences(
      classicRide: classicRides,
      shareTrip: shareRides,
      groupTrip: groupRides,
      delivery: deliveryRides,
    );
  }

  //! Splash
  int splashIndex = 0;

  void splashOnChange(int index) {
    splashIndex = index;
    emit(SplashOnChangeState());
  }

  String checkTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return AppStrings.goodMorning;
    } else if (hour >= 12 && hour < 18) {
      return AppStrings.goodAfternoon;
    } else {
      return AppStrings.goodEvening;
    }
  }

  //! Driver Preferences
  bool classicRides = false;
  bool shareRides = false;
  bool groupRides = false;
  bool deliveryRides = false;

  bool checkPreferencesActive(index) {
    switch (index) {
      case 0:
        return classicRides;
      case 1:
        return shareRides;
      case 2:
        return groupRides;
      case 3:
        return deliveryRides;
      default:
        return false;
    }
  }

  void preferencesToggle(int index) {
    switch (index) {
      case 0:
        classicRides = !classicRides;
        break;
      case 1:
        shareRides = !shareRides;
        break;
      case 2:
        groupRides = !groupRides;
        break;
      case 3:
        deliveryRides = !deliveryRides;
        break;
      default:
    }
    emit(HomePreferencesToggleState());
    saveDriverPreferences();
  }
}
