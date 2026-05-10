import 'package:intl/intl.dart';

import '../../../../core/imports/imports.dart';
import '../../data/models/driver_summary_model.dart';
import '../../data/repo/earnings_repo.dart';

part 'earnings_state.dart';

class EarningsCubit extends Cubit<EarningsState> {
  EarningsCubit() : super(EarningsInitial()) {
    initializeCurrentWeek().then((value) {
      getDriverSummary();
    });
  }

  //! Get Driver Summary
  DriverSummaryModel? driverSummaryModel;
  Future<void> getDriverSummary() async {
    emit(EarningsLoadingState());

    Map<String, dynamic>? queryParameters;

    final now = DateTime.now();

    if (selectedDay != null || selectedMonth != null) {
      if (selectedDay != null) {
        queryParameters = {
          "date": DateFormat("yyyy-MM-dd").format(selectedDay!),
        };
      }
      if (selectedMonth != null) {
        final firstDay = DateTime(int.parse(year), selectedMonth!.month, 1);
        final lastDay = DateTime(int.parse(year), selectedMonth!.month + 1, 0);
        queryParameters = {
          "date_from": DateFormat("yyyy-MM-dd").format(firstDay),
          "date_to": DateFormat("yyyy-MM-dd").format(lastDay),
        };
      }
    } else {
      switch (filterType) {
        case "Daily":
          queryParameters = {
            "date": DateFormat("yyyy-MM-dd").format(selectedDay ?? now),
          };
          break;

        case "Weekly":
          final start = currentWeekStart;
          final end = currentWeekEnd;
          queryParameters = {
            "date_from": DateFormat("yyyy-MM-dd").format(start),
            "date_to": DateFormat("yyyy-MM-dd").format(end),
          };
          break;

        case "Monthly":
          final selectedMonthIndex =
              months.indexWhere((e) => e == month) + 1; // 1-based
          final firstDay = DateTime(int.parse(year), selectedMonthIndex, 1);
          final lastDay = DateTime(int.parse(year), selectedMonthIndex + 1, 0);
          queryParameters = {
            "date_from": DateFormat("yyyy-MM-dd").format(firstDay),
            "date_to": DateFormat("yyyy-MM-dd").format(lastDay),
          };
          break;

        case "Yearly":
          final firstDay = DateTime(int.parse(year), 1, 1);
          final lastDay = DateTime(int.parse(year), 12, 31);
          queryParameters = {
            "date_from": DateFormat("yyyy-MM-dd").format(firstDay),
            "date_to": DateFormat("yyyy-MM-dd").format(lastDay),
          };
          break;

        case "All":
        default:
          queryParameters = {
            "date": null,
            "date_from": null,
            "date_to": null,
          };
          break;
      }
    }

    final result = await sl<EarningsRepo>().getDriverSummary(
      queryParameters: queryParameters,
    );

    result.fold(
      (error) => emit(EarningsErrorState(error: error)),
      (model) {
        driverSummaryModel = model;
        emit(EarningsSuccessState());
      },
    );
  }

  DateTime? selectedDay;
  DateTime? selectedMonth;
  DateTime? selectedYear;

  FilterTypes selectedFilterType = FilterTypes.daily;
  changeSelectedFilterType(FilterTypes type) {
    selectedFilterType = type;
    emit(EarningsInitial());
  }

  String? selectedFilterYear = DateTime.now().year.toString();
  DateTime? fullFilterYear = DateTime(DateTime.now().year);
  uploadPublishDate(DateTime? value) {
    fullFilterYear = value;
    selectedFilterYear = value!.year.toString().split(" ")[0];
    emit(EarningsInitial());
  }

  late DateTime currentWeekStart;
  late DateTime currentWeekEnd;
  String year = "";
  String month = "";
  String weekRangeText = "";

  Future<void> initializeCurrentWeek() async {
    final DateTime now = DateTime.now();
    currentWeekStart = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday + 1));
    currentWeekEnd = currentWeekStart.add(const Duration(days: 6));
    year = currentWeekEnd.year.toString();
    _updateWeekRangeText();
  }

  void _updateWeekRangeText() {
    final DateTime endOfWeek = currentWeekStart.add(const Duration(days: 6));
    weekRangeText =
        "${formatDate(currentWeekStart)} - ${formatDate(endOfWeek)}";
    currentWeekEnd = currentWeekStart.add(const Duration(days: 6));
    // transactionByWeek();
  }

  void shiftWeek(bool forward) {
    resetSelectedCalender();
    switch (filterType) {
      case "Weekly":
        if (forward) {
          currentWeekStart = currentWeekStart.add(const Duration(days: 7));
        } else {
          currentWeekStart = currentWeekStart.subtract(const Duration(days: 7));
        }
        _updateWeekRangeText();

        break;
      case "Monthly":
        final int monthIndex = months.indexWhere((e) => e == month);
        if (forward) {
          if (monthIndex < 11) {
            month = months[monthIndex + 1];
          } else {
            month = months[0];
            year = (int.parse(year) + 1).toString();
          }
        } else {
          if (monthIndex > 0) {
            month = months[monthIndex - 1];
          } else {
            month = months[11];
            year = (int.parse(year) - 1).toString();
          }
        }
        break;
      case "Yearly":
        if (forward) {
          year = (int.parse(year) + 1).toString();
          // transactionByMonth();
        } else {
          year = (int.parse(year) - 1).toString();
          // transactionByMonth();
        }
        break;
      default:
    }
    changeScrollPostion();
    emit(ShiftDateState());
  }

  String formatDate(DateTime date) {
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }

  //! Filter Type
  String filterType = "All";

  filterTypeToggle(String value) {
    filterType = value;
    switch (filterType) {
      case "All":
        filterType = "All";
      case "Weekly":
        initializeCurrentWeek();
        changeScrollPostion();
      case "Monthly":
        month = months[DateTime.now().month - 1];
        year = DateTime.now().year.toString();
        changeScrollPostion();
        break;
      default:
        changeScrollPostion();
    }

    resetSelectedCalender();
    emit(FilterTypeToggle());
  }

  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  selectDay(DateTime value) {
    if (value == selectedDay) {
      selectedDay = null;
    } else {
      selectedDay = value;
    }
    emit(FilterTypeToggle());
  }

  selectMonth(DateTime value) {
    if (selectedMonth == value) {
      selectedMonth = null;
    } else {
      selectedMonth = value;
    }
    emit(FilterTypeToggle());
  }

  selectYear(DateTime value) {
    if (selectedYear == value) {
      selectedYear = null;
    } else {
      selectedYear = value;
    }
    emit(FilterTypeToggle());
  }

  bool? canGoForward() {
    switch (filterType) {
      case "Weekly":
        if (currentWeekEnd.year == DateTime.now().year &&
            currentWeekEnd.month == DateTime.now().month &&
            currentWeekEnd.day >= DateTime.now().day) {
          return false;
        }
      case "Monthly":
        if (((months.indexWhere((e) => e == month) + 1) ==
                DateTime.now().month) &&
            year == DateTime.now().year.toString()) {
          return false;
        }
        return true;
      case "Yearly":
        if (year == DateTime.now().year.toString()) {
          return false;
        }
        break;
      default:
    }
    return null;
  }

  ScrollController scrollController = ScrollController();

  changeScrollPostion() {
    Future.delayed(const Duration(milliseconds: 200), () {
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  resetSelectedCalender() {
    selectedDay = null;
    selectedMonth = null;
    selectedYear = null;
  }

  String formatMinutes(int minutes, {String? locale}) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    final hLabel = Intl.message(
      'H',
      name: 'hourLabel',
      locale: locale,
      desc: 'Hour abbreviation',
    );
    final mLabel = Intl.message(
      'M',
      name: 'minuteLabel',
      locale: locale,
      desc: 'Minute abbreviation',
    );

    if (hours > 0 && remainingMinutes > 0) {
      return '$hours $hLabel $remainingMinutes $mLabel';
    } else if (hours > 0) {
      return '$hours $hLabel';
    } else {
      return '$remainingMinutes $mLabel';
    }
  }
}

enum FilterTypes {
  daily,
  weekly,
  monthly,
  yearly,
}
