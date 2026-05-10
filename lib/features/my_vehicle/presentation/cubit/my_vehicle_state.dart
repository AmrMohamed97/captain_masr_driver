part of 'my_vehicle_cubit.dart';

@immutable
sealed class MyVehicleState {}

final class MyVehicleInitial extends MyVehicleState {}

final class GetVehicleDetailsLoadingState extends MyVehicleState {}

final class GetVehicleDetailsErrorState extends MyVehicleState {
  final String error;

  GetVehicleDetailsErrorState({required this.error});
}

final class GetVehicleDetailsSuccessState extends MyVehicleState {}

final class GetDriverVehicleLoadingState extends MyVehicleState {}

final class GetDriverVehicleErrorState extends MyVehicleState {
  final String error;

  GetDriverVehicleErrorState({required this.error});
}

final class GetDriverVehicleSuccess extends MyVehicleState {}

final class EditGetVehicleCategoriesLoadingState extends MyVehicleState {}

final class GetVehicleCategoriesErrorState extends MyVehicleState {
  final String error;

  GetVehicleCategoriesErrorState({required this.error});
}

final class GetVehicleCategoriesSuccessState extends MyVehicleState {}

final class MyVehicleSelectItem extends MyVehicleState {}

final class EditVehicleLoadingState extends MyVehicleState {}

final class EditVehicleErrorState extends MyVehicleState {
  final String error;

  EditVehicleErrorState({required this.error});
}

final class EditVehicleESuccessState extends MyVehicleState {
  final String message;

  EditVehicleESuccessState({required this.message});
}
