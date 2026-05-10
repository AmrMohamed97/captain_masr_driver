import 'package:image_picker/image_picker.dart';

import '../../../../core/imports/imports.dart';
import '../../../my_vehicle/data/models/vehicle_brand_model.dart';
import '../../../my_vehicle/data/models/vehicle_category_model.dart';
import '../../../my_vehicle/data/models/vehicle_color_model.dart';
import '../../../my_vehicle/data/models/vehicle_model_model.dart';
import '../../../my_vehicle/data/models/vehicle_type_model.dart';
import '../../../my_vehicle/data/repo/vehicle_repo.dart';
import '../../data/repo/become_rider_or_driver_repo.dart';

part 'become_rider_or_driver_state.dart';

class BecomeRiderOrDriverCubit extends Cubit<BecomeRiderOrDriverState> {
  BecomeRiderOrDriverCubit({
    required this.isConvertedBefore,
  }) : super(BecomeRiderOrDriverInitial()) {
    if (!isConvertedBefore) {
      getVehicleCategories();
    }
  }

  bool isConvertedBefore;

  //! Become Rider
  Future<void> becomeRider() async {
    emit(BecomeRiderOrDriverLoadingState());
    final result = await sl<BecomeRiderOrDriverRepo>().becomeRider();
    result.fold(
      (error) => emit(BecomeRiderOrDriverErrorState(error: error)),
      (message) => emit(BecomeRiderSuccessState(message: message)),
    );
  }

  //! Become Driver
  Future<void> becomeDriver() async {
    emit(BecomeRiderOrDriverLoadingState());
    final result = await sl<BecomeRiderOrDriverRepo>().becomeDriver(
      isConvertedBefore: isConvertedBefore,
      idNumber: idNumber.text,
      nationalId: await uploadImageToApi(nationalIdImage),
      nationalIdExpiry: nationalIdExpiry?.toString().split(" ")[0],
      vehicleTypeId: (selectedVehicleType?.id ?? 0).toString(),
      vehicleBrandId: (selectedVehicleBrand?.id ?? 0).toString(),
      vehicleModelId: (selectedVehicleModel?.id ?? 0).toString(),
      vehicleColorId: (selectedVehicleColor?.id ?? 0).toString(),
      vehicleLicense: await uploadImageToApi(vehicleLicenseImage),
      vehicleLicenseExpiry: vehicleLicenseImageExpiry?.toString().split(" ")[0],
      driverLicense: await uploadImageToApi(driverLicenseImage),
      driverLicenseExpiry: driverLicenseImageExpiry?.toString().split(" ")[0],
      vehicleCategoryId: (selectedVehicleCategoryId ?? 0).toString(),
      plateNumber: plateNumberController.text,
    );
    result.fold(
      (error) => emit(BecomeRiderOrDriverErrorState(error: error)),
      (message) => emit(BecomeDriverSuccessState(message: message)),
    );
  }

  //! Get Vehicles Categories
  List<VehicleCategoryModel> vehicleCategories = [];
  Future<void> getVehicleCategories() async {
    emit(BecomeRiderOrDriverLoadingState());
    final result = await sl<VehicleRepo>().getVehicleCategories();
    result.fold(
      (error) => emit(BecomeRiderOrDriverErrorState(error: error)),
      (list) {
        vehicleCategories = list;
        if (vehicleCategories.isNotEmpty) {
          selectedVehicleCategoryId = vehicleCategories.first.id;
        }
        emit(BecomeRiderOrDriverSuccessState());
      },
    );
  }

  //! Page
  int pageIndex = 0;
  PageController pageController = PageController();

  changePage(int index) {
    pageController.jumpToPage(index);
    pageIndex = index;
    emit(BecomeRiderOrDriverSuccessState());
  }

  bool showValidation = false;

  validationToggle(bool value) {
    showValidation = value;
    emit(BecomeRiderOrDriverSuccessState());
  }

  //! First Form
  GlobalKey<FormState> firstFormKey = GlobalKey<FormState>();
  int? selectedVehicleCategoryId;
  VehicleTypeModel? selectedVehicleType;
  VehicleBrandModel? selectedVehicleBrand;
  VehicleModelModel? selectedVehicleModel;
  VehicleColorModel? selectedVehicleColor;
  TextEditingController plateNumberController = TextEditingController();

  selectItem() {
    emit(BecomeRiderOrDriverSuccessState());
  }

  //! Second Form
  GlobalKey<FormState> secondFormKey = GlobalKey<FormState>();
  TextEditingController idNumber = TextEditingController();
  DateTime? nationalIdExpiry;
  DateTime? driverLicenseImageExpiry;
  DateTime? vehicleLicenseImageExpiry;
  XFile? nationalIdImage;
  XFile? driverLicenseImage;
  XFile? vehicleLicenseImage;

  pickImage() async {
    emit(BecomeRiderOrDriverSuccessState());
  }
}
