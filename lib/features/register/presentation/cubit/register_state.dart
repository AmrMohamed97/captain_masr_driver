part of 'register_cubit.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterObscurePasswordToggleState extends RegisterState {}

final class RegisterSelectItemState extends RegisterState {}

final class RegisterChangePageState extends RegisterState {}

final class RegisterValidationToggleState extends RegisterState {}

final class RegisterPickImageState extends RegisterState {}

final class RegisterLoadingState extends RegisterState {}

final class RegisterErrorState extends RegisterState {
  final String error;

  RegisterErrorState({required this.error});
}

final class RegisterSuccessState extends RegisterState {
  final String? message;

  RegisterSuccessState({required this.message});
}

final class GetVehicleDetailsErrorState extends RegisterState {
  final String message;

  GetVehicleDetailsErrorState({required this.message});
}

final class GetVehicleCategoriesLoadingState extends RegisterState {}

final class GetVehicleCategoriesSuccessState extends RegisterState {}

final class GetVehicleCategoriesErrorState extends RegisterState {
  final String error;

  GetVehicleCategoriesErrorState({required this.error});
}
