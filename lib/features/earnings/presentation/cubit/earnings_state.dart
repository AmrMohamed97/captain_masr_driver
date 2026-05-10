part of 'earnings_cubit.dart';

@immutable
sealed class EarningsState {}

final class EarningsInitial extends EarningsState {}

final class ShiftDateState extends EarningsState {}

final class FilterTypeToggle extends EarningsState {}

final class EarningsLoadingState extends EarningsState {}

final class EarningsErrorState extends EarningsState {
  final String error;

  EarningsErrorState({required this.error});
}

final class EarningsSuccessState extends EarningsState {}
