import 'package:intl/intl.dart';

import '../../../../core/imports/imports.dart';
import '../../../rider_trip/data/models/trip_details_model.dart';
import '../../data/repo/trip_details_repo.dart';

part 'trip_details_state.dart';

class TripDetailsCubit extends Cubit<TripDetailsState> {
  TripDetailsCubit() : super(TripDetailsInitial());

  //! Trip Details
  TripDetailsModel? tripDetails;
  void getTripDetails({
    required int tripId,
    required bool isRider,
  }) {
    if (isCompleted) {
      getCompletedTripDetails(
        tripId: tripId,
        isRider: isRider,
      );
    }
  }

  //! Get Completed Trip Details
  Future<void> getCompletedTripDetails({
    required int tripId,
    required bool isRider,
  }) async {
    emit(TripDetailsLoadingState());
    final result = await sl<TripDetailsRepo>().completedTripDetails(
      tripId: tripId,
      isRider: isRider,
    );
    result.fold(
      (error) => emit(TripDetailsErrorState(error: error)),
      (model) {
        tripDetails = model;
        emit(TripDetailsSuccessState());
      },
    );
  }

  bool isAccepted = false;
  bool isCompleted = false;
  bool isClassic = false;
  bool isGroup = false;
  bool isShare = false;
  bool isDelivery = false;
  bool isScheduled = false;

  //! Promo Code
  TextEditingController promoCodeController = TextEditingController();
  bool promoCodeApplied = false;
  checkPromoCode() {
    if (promoCodeController.text.isNotEmpty) {
      promoCodeApplied = true;
    } else {
      promoCodeApplied = false;
    }
    emit(BookingTripCheckPromoCodeState());
  }

  //! Going & Returning
  bool goingAndReturning = false;

  goingAndReturningToggle() {
    goingAndReturning = !goingAndReturning;
    emit(BookingGoingAndReturningToggleState());
  }

  //! Booking Seats Number
  int seatsNum = 1;

  changeSeatsNum(int value) {
    if (value == 0) {
      if (seatsNum > 1) {
        seatsNum--;
      }
    } else {
      if (seatsNum < 4) {
        seatsNum++;
      }
    }
    emit(BookingChangeSeatsNumState());
  }

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now().add(const Duration(days: 6));
  List<DateTime> daysFromTo = [];
  List<DateTime> selectedDaysFromTo = [];

  selectDay(int index) {
    selectedDaysFromTo.contains(daysFromTo[index])
        ? selectedDaysFromTo.remove(daysFromTo[index])
        : selectedDaysFromTo.add(daysFromTo[index]);
    emit(BookingTripPickState());
  }

  dynamic formateDate(DateTime? date) {
    if (date != null) {
      return "${date.year}-${date.month}-${date.day}";
    }
    return;
  }

  getDays() {
    int index = 0;
    while (!fromDate.add(Duration(days: index)).isAfter(toDate)) {
      daysFromTo.add(fromDate.add(Duration(days: index)));
      index = index + 1;
    }
    emit(BookingTripPickState());
  }

  //! Riders
  List<String> riders = [
    Assets.imagesTestProfile1,
    Assets.imagesTestProfile2,
    Assets.imagesTestProfileImage,
  ];

  int selectedRider = 0;

  selectRider(int index) {
    selectedRider = index;
    emit(BookingDetailsSelectRiderState());
  }

  //! Format Date
  String formatTripDate({String? locale}) {
    if (tripDetails!.createdAt == null) {
      return "??";
    }
    final DateTime dateTime = DateTime.parse(tripDetails!.createdAt!);
    return DateFormat('EEE, dd, MMMM', locale).format(dateTime);
  }

  //! Format Time
  String formatTripTime({String? locale}) {
    if (tripDetails!.createdAt == null) {
      return "??";
    }

    final DateTime dateTime = DateTime.parse(tripDetails!.createdAt!);
    return DateFormat.jm(locale).format(dateTime);
  }
}
