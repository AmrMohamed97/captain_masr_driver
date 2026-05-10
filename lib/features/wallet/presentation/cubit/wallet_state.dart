part of 'wallet_cubit.dart';

@immutable
sealed class WalletState {}

final class WalletInitial extends WalletState {}

final class SelectPaymentMethodState extends WalletState {}

final class WalletLoadingState extends WalletState {}

final class WalletErrorState extends WalletState {
  final String error;

  WalletErrorState({required this.error});
}

final class WalletSuccessState extends WalletState {
  final String? message;

  WalletSuccessState({this.message});
}

final class SetDefaultPaymentLoadingState extends WalletState {}

final class SetDefaultPaymentSuccessState extends WalletState {
  final String message;

  SetDefaultPaymentSuccessState({required this.message});
}
