import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/countries.dart';

import '../../../../core/imports/imports.dart';
import '../../../otp/data/repo/otp_repo.dart';
import '../../../profile/data/repo/profile_repo.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit({
    String? name,
    String? email,
    String? mobile,
    String? gender,
    String? idNumber,
  }) : super(EditProfileInitial()) {
    nameController.text = name ?? "";
    emailController.text = email ?? "";
    mobileController.text = mobile ?? "";
    genderValue = gender ?? "male";
    idNumberController.text = idNumber ?? "";
  }

  //! Edit Profile
  Future<void> userEditProfile() async {
    emit(EditProfileLoadingState());
    final result = await sl<ProfileRepo>().userEditProfile(
      username: nameController.text,
      profilePicture: await uploadImageToApi(image),
    );
    result.fold(
      (error) => emit(EditProfileErrorState(error: error)),
      (message) => emit(EditProfileSuccessState(message: message)),
    );
  }

  //! Update Phone
  Future<void> updatePhone() async {
    emit(UpdatePhoneLoadingState());
    final result = await sl<ProfileRepo>().updatePhone(
      countryCode: selectedCountry?.dialCode ?? "20",
      country: selectedCountry?.code ?? "EG",
      phone: mobileController.text,
    );
    result.fold(
      (error) => emit(UpdatePhoneErrorState(error: error)),
      (message) => emit(UpdatePhoneSuccessState(message: message)),
    );
  }

  //! Update Email
  Future<void> updateEmail() async {
    emit(UpdateEmailLoadingState());
    final result = await sl<ProfileRepo>().updateEmail(
      email: emailController.text,
    );
    result.fold(
      (error) => emit(UpdateEmailErrorState(error: error)),
      (message) => emit(UpdateEmailSuccessState(message: message)),
    );
  }

  //! Verify Email
  Future<void> verifyEmail({required bool isRider}) async {
    emit(EditProfileLoadingState());
    final result = await sl<OtpRepo>().emailResendOtp(
      email: emailController.text,
      isRider: isRider,
    );
    result.fold(
      (error) => emit(EditProfileErrorState(error: error)),
      (message) => emit(VerifyEmailSuccessState(message: message)),
    );
  }

  //! Delete Account
  Future<void> deleteAccount() async {
    emit(DeleteAccountLoadingState());
    final result = await sl<ProfileRepo>().deleteAccount();
    result.fold(
      (error) => emit(DeleteAccountErrorState(error: error)),
      (message) async {
        sl<Cache>().removeKey(AppConstants.token);
        sl<Cache>().removeKey(AppConstants.user);
        emit(DeleteAccountSuccessState(message: message));
      },
    );
  }

  //! Form
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  String? gender;
  String? genderValue;
  TextEditingController idNumberController = TextEditingController();
  Country? selectedCountry;

  //! Image
  XFile? image;

  pickImage(XFile? xfile) async {
    image = xfile;
    emit(EditProfilePickImageState());
  }

  formOnChange() {
    emit(EditProfileFormOnChangeState());
  }
}
