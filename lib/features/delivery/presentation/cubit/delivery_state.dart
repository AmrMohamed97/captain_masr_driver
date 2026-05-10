part of 'delivery_cubit.dart';

@immutable
sealed class DeliveryState {}

final class DeliveryInitial extends DeliveryState {}

final class SendingOrReceivingToggleState extends DeliveryState {}

final class PackageDetailsPickState extends DeliveryState {}

final class DeliveryErrorState extends DeliveryState {
  final String error;

  DeliveryErrorState({required this.error});
}

final class DeliverySuccessState extends DeliveryState {
  final String? message;

  DeliverySuccessState({this.message});
}

final class DeliveryGetVehicleCategoriesLoadingState extends DeliveryState {}

final class GetDeliveryItemsLoadingState extends DeliveryState {}

final class GetDeliveryItemsSizesLoadingState extends DeliveryState {}
