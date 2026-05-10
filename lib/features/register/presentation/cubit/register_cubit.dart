import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/countries.dart';

import '../../../../core/imports/imports.dart';
import '../../../my_vehicle/data/models/vehicle_brand_model.dart';
import '../../../my_vehicle/data/models/vehicle_category_model.dart';
import '../../../my_vehicle/data/models/vehicle_color_model.dart';
import '../../../my_vehicle/data/models/vehicle_model_model.dart';
import '../../../my_vehicle/data/models/vehicle_type_model.dart';
import '../../../my_vehicle/data/repo/vehicle_repo.dart';
import '../../data/repo/register_repo.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  //! User Register
  Future<void> userRegister() async {
    emit(RegisterLoadingState());
    final result = await sl<RegisterRepo>().userRegister(
      username: usernameController.text,
      email: emailController.text,
      countryCode: selectedCountry?.dialCode ?? "20",
      country: selectedCountry?.code ?? "EG",
      phone: phoneController.text,
      gender: genderValue!,
      password: passwordController.text,
      passwordConfirmation: confirmPasswordController.text,
    );
    result.fold(
      (error) => emit(RegisterErrorState(error: error)),
      (message) {
        emit(RegisterSuccessState(message: message));
      },
    );
  }

  //! Driver Register
  Future<void> driverRegister() async {
    emit(RegisterLoadingState());
    final result = await sl<RegisterRepo>().driverRegister(
      profilePicture: await uploadImageToApi(profileImage),
      username: usernameController.text,
      email: emailController.text,
      password: passwordController.text,
      gender: genderValue!,
      idNumber: idNumberController.text,
      countryCode: selectedCountry?.dialCode ?? "20",
      country: selectedCountry?.code ?? "EG",
      phone: phoneController.text,
      vehicleCategoryId: selectedVehicleCategoryId!,
      vehicleTypeId: selectedVehicleType?.id ?? 0,
      vehicleBrandId: selectedVehicleBrand?.id ?? 0,
      vehicleModelId: selectedVehicleModel?.id ?? 0,
      vehicleColorId: selectedVehicleColor?.id ?? 0,
      plateNumber: plateNumberController.text,
      nationalId: await uploadImageToApi(nationalIdImage) as MultipartFile,
      nationalIdExpiry: nationalIdExpiry.toString().split(" ")[0],
      driverLicense:
          await uploadImageToApi(driverLicenseImage) as MultipartFile,
      driverLicenseExpiry: driverLicenseImageExpiry.toString().split(" ")[0],
      vehicleLicense:
          await uploadImageToApi(vehicleLicenseImage) as MultipartFile,
      vehicleLicenseExpiry: vehicleLicenseImageExpiry.toString().split(" ")[0],
    );
    result.fold(
      (error) => emit(RegisterErrorState(error: error)),
      (message) => emit(RegisterSuccessState(message: message)),
    );
  }

  //! Get Vehicles Categories
  List<VehicleCategoryModel> vehicleCategories = [];
  Future<void> getVehicleCategories() async {
    emit(GetVehicleCategoriesLoadingState());
    final result = await sl<VehicleRepo>().getVehicleCategories();
    result.fold(
      (error) => emit(GetVehicleCategoriesErrorState(error: error)),
      (list) {
        vehicleCategories = list;
        emit(GetVehicleCategoriesSuccessState());
      },
    );
  }

  //! Page View
  PageController pageController = PageController(initialPage: 0);
  int pageIndex = 0;

  changePage(int index) {
    pageController.jumpToPage(index);
    pageIndex = index;
    emit(RegisterChangePageState());
    vehicleCategories.isEmpty ? getVehicleCategories() : null;
  }

  //! First Form
  GlobalKey<FormState> firstFormKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String? gender, genderValue;
  TextEditingController idNumberController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  Country? selectedCountry;
  bool showValidation = false;
  XFile? profileImage;

  pickImage() async {
    emit(RegisterPickImageState());
  }

  validationToggle(bool value) {
    showValidation = value;
    emit(RegisterValidationToggleState());
  }

  //! Second Form
  GlobalKey<FormState> secondFormKey = GlobalKey<FormState>();
  int? selectedVehicleCategoryId;
  VehicleTypeModel? selectedVehicleType;
  VehicleBrandModel? selectedVehicleBrand;
  VehicleModelModel? selectedVehicleModel;
  VehicleColorModel? selectedVehicleColor;
  TextEditingController plateNumberController = TextEditingController();

  selectItem() {
    emit(RegisterSelectItemState());
  }

  //! Third Form
  DateTime? nationalIdExpiry;
  DateTime? driverLicenseImageExpiry;
  DateTime? vehicleLicenseImageExpiry;
  XFile? nationalIdImage;
  XFile? driverLicenseImage;
  XFile? vehicleLicenseImage;

  //! Obscure Password
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  obscurePasswordToggle() {
    obscurePassword = !obscurePassword;
    emit(RegisterObscurePasswordToggleState());
  }

  obscureConfirmPasswordToggle() {
    obscureConfirmPassword = !obscureConfirmPassword;
    emit(RegisterObscurePasswordToggleState());
  }
}
