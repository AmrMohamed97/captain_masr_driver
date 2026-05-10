part of 'edit_profile_cubit.dart';

@immutable
sealed class EditProfileState {}

final class EditProfileInitial extends EditProfileState {}

final class EditProfileFormOnChangeState extends EditProfileState {}

final class EditProfilePickImageState extends EditProfileState {}

final class EditProfileLoadingState extends EditProfileState {}

final class EditProfileErrorState extends EditProfileState {
  final String error;

  EditProfileErrorState({required this.error});
}

final class EditProfileSuccessState extends EditProfileState {
  final String message;

  EditProfileSuccessState({required this.message});
}

final class DeleteAccountLoadingState extends EditProfileState {}

final class DeleteAccountErrorState extends EditProfileState {
  final String error;

  DeleteAccountErrorState({required this.error});
}

final class DeleteAccountSuccessState extends EditProfileState {
  final String message;

  DeleteAccountSuccessState({required this.message});
}

final class UpdatePhoneLoadingState extends EditProfileState {}

final class UpdatePhoneErrorState extends EditProfileState {
  final String error;

  UpdatePhoneErrorState({required this.error});
}

final class UpdatePhoneSuccessState extends EditProfileState {
  final String message;

  UpdatePhoneSuccessState({required this.message});
}

final class UpdateEmailLoadingState extends EditProfileState {}

final class UpdateEmailErrorState extends EditProfileState {
  final String error;

  UpdateEmailErrorState({required this.error});
}

final class UpdateEmailSuccessState extends EditProfileState {
  final String message;

  UpdateEmailSuccessState({required this.message});
}

final class VerifyEmailSuccessState extends EditProfileState {
  final String message;

  VerifyEmailSuccessState({required this.message});
}
