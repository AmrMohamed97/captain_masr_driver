import '../../../../core/imports/imports.dart';
import '../../data/repo/rating_repo.dart';

part 'rating_state.dart';

class RatingCubit extends Cubit<RatingState> {
  RatingCubit() : super(RatingInitial());

  //! Rider Rate Trip
  Future<void> riderRateTrip({required int tripId,String? type}) async {
    emit(RatingLoadingState());
    final result = await sl<RatingRepo>().riderRateTrip(
      tripId: tripId,
      carValues: !isDelivery ? carRateValues : null,
      driverValues: !isDelivery ? driverRateValues : null,
      deliveryValues: isDelivery ? deliveryRateValues : null,
      tip: double.tryParse(tipsController.text) ?? 0,
      overallRating: rating ?? 0.0,
      note: noteController.text,
      type: type
    );
    result.fold(
      (error) => emit(RatingErrorState(error: error)),
      (message) => emit(RatingSuccessState(message: message)),
    );
  }

  TextEditingController noteController = TextEditingController();
  bool isDelivery = false;

  //! Car Rate
  List<String> carRateTitles = [
    AppStrings.clean,
    AppStrings.comfy,
    AppStrings.spacious,
  ];

  List<bool> carRateValues = [false, false, false];

  carRateOnChange(int index) {
    carRateValues[index] = !carRateValues[index];
    emit(RateOnChange());
  }

  //! Driver Rate
  List<String> driverRateTitles = [
    AppStrings.onTime,
    AppStrings.helpful,
    AppStrings.polite,
  ];

  List<bool> driverRateValues = [false, false, false];

  driverRateOnChange(int index) {
    driverRateValues[index] = !driverRateValues[index];
    emit(RateOnChange());
  }

  //! Deilvery Rate
  List<String> deliveryRateTitles = [
    AppStrings.onTime,
    AppStrings.fast,
    AppStrings.polite,
    AppStrings.packageInGoodCondition,
  ];

  List<bool> deliveryRateValues = [false, false, false, false];

  deliveryRateOnChange(int index) {
    deliveryRateValues[index] = !deliveryRateValues[index];
    emit(RateOnChange());
  }

  //! Tips
  bool tipValue = false;
  TextEditingController tipsController = TextEditingController();

  tipToggle() {
    tipValue = !tipValue;
    if (!tipValue) {
      tipsController.clear();
    }
    emit(RateOnChange());
  }

  //! Overall Rating
  double? rating = 1;

  ratingOnChange(double value) {
    rating = value;
    emit(RateOnChange());
  }
}
