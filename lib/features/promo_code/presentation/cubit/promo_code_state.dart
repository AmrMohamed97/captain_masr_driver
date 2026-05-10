part of 'promo_code_cubit.dart';

@immutable
sealed class PromoCodeState {}

final class PromoCodeInitial extends PromoCodeState {}

final class PromoCodesLoadingState extends PromoCodeState {}

final class PromoCodesErrorState extends PromoCodeState {
  final String error;

  PromoCodesErrorState({required this.error});
}

final class PromoCodesSuccessState extends PromoCodeState {}
