part of 'rating_cubit.dart';

@immutable
sealed class RatingState {}

final class RatingInitial extends RatingState {}

final class RateOnChange extends RatingState {}

final class RatingLoadingState extends RatingState {}

final class RatingErrorState extends RatingState {
  final String error;

  RatingErrorState({required this.error});
}

final class RatingSuccessState extends RatingState {
  final String message;

  RatingSuccessState({required this.message});
}
