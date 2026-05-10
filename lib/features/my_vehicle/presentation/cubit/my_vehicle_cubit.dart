import 'package:image_picker/image_picker.dart';

import '../../../../core/imports/imports.dart';
import '../../../base/data/models/pagination_model.dart';
import '../../data/models/driver_vehicle_model.dart';
import '../../data/models/vehicle_brand_model.dart';
import '../../data/models/vehicle_category_model.dart';
import '../../data/models/vehicle_color_model.dart';
import '../../data/models/vehicle_model_model.dart';
import '../../data/models/vehicle_type_model.dart';
import '../../data/repo/vehicle_repo.dart';

part 'my_vehicle_state.dart';

class MyVehicleCubit extends Cubit<MyVehicleState> {
  MyVehicleCubit() : super(MyVehicleInitial());

  //! Edit Vehicle
  Future<void> editVehicle() async {
    emit(EditVehicleLoadingState());
    final result = await sl<VehicleRepo>().updateDriverVehicle(
      vehicleCategoryId: selectedVehicleCategoryId,
      vehicleTypeId: selectedVehicleType?.id,
      vehicleBrandId: selectedVehicleBrand?.id,
      vehicleModelId: selectedVehicleModel?.id,
      vehicleColorId: selectedVehicleColor?.id,
      plateNumber: plateNumberController.text,
      vehicleLicense: await uploadImageToApi(vehicleLicenseImage),
      vehicleLicensEexpiry: vehicleLicenseImageExpiry != null
          ? vehicleLicenseImageExpiry!.toString().split(" ")[0]
          : null,
    );
    result.fold(
      (error) => emit(EditVehicleErrorState(error: error)),
      (message) => emit(EditVehicleESuccessState(message: message)),
    );
  }

  //! Get Driver Vehicle
  DriverVehicleModel? driverVehicleModel;
  Future<void> getDriverVehicle() async {
    emit(GetDriverVehicleLoadingState());
    final result = await sl<VehicleRepo>().getDriverVehicle();
    result.fold(
      (error) => emit(GetDriverVehicleErrorState(error: error)),
      (model) {
        driverVehicleModel = model;
        emit(GetDriverVehicleSuccess());
      },
    );
  }

  //! Get Vehicles Categories
  List<VehicleCategoryModel> vehicleCategories = [];
  Future<void> getVehicleCategories() async {
    emit(EditGetVehicleCategoriesLoadingState());
    final result = await sl<VehicleRepo>().getVehicleCategories();
    result.fold(
      (error) => emit(GetVehicleCategoriesErrorState(error: error)),
      (list) {
        vehicleCategories = list;
        emit(GetVehicleCategoriesSuccessState());
      },
    );
  }

  //! Pagination
  init({
    required int index,
    required int? id,
  }) {
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          state is! GetVehicleDetailsLoadingState) {
        if ((pagination?.lastPage ?? 0) > page) {
          switch (index) {
            case 1:
              getVehcileTypes(id: id!);
              break;
            case 2:
              getVehcileBrands(id: id!);
            case 3:
              getVehcileModels(id: id!);
            case 4:
              getVehcileColors();
            default:
          }
        }
      }
    });
  }

  ScrollController scrollController = ScrollController();
  PaginationModel? pagination;
  int page = 0;

  //! Get Vehicle Types
  List<VehicleTypeModel> vehicleTypes = [];
  Future<void> getVehcileTypes({required int id}) async {
    emit(GetVehicleDetailsLoadingState());
    final result = await sl<VehicleRepo>().getVehcileTypes(
      page: page + 1,
      vehicleCategoryId: id,
    );
    result.fold(
      (error) => emit(GetVehicleDetailsErrorState(error: error)),
      (model) {
        vehicleTypes += model.data as List<VehicleTypeModel>;
        pagination = model.pagination;
        page += 1;
        emit(GetVehicleDetailsSuccessState());
      },
    );
  }

  //! Get Vehicle Brands
  List<VehicleBrandModel> vehicleBrands = [];
  Future<void> getVehcileBrands({required int id}) async {
    emit(GetVehicleDetailsLoadingState());
    final result = await sl<VehicleRepo>().getVehcileBrands(
      page: page + 1,
      vehicleTypeId: id,
    );
    result.fold(
      (error) => emit(GetVehicleDetailsErrorState(error: error)),
      (model) {
        vehicleBrands += model.data as List<VehicleBrandModel>;
        pagination = model.pagination;
        page += 1;
        emit(GetVehicleDetailsSuccessState());
      },
    );
  }

  //! Get Vehicle Models
  List<VehicleModelModel> vehicleModels = [];
  Future<void> getVehcileModels({required int id}) async {
    emit(GetVehicleDetailsLoadingState());
    final result = await sl<VehicleRepo>().getVehcileModels(
      page: page + 1,
      vehicleBrandId: id,
    );
    result.fold(
      (error) => emit(GetVehicleDetailsErrorState(error: error)),
      (model) {
        vehicleModels += model.data as List<VehicleModelModel>;
        pagination = model.pagination;
        page += 1;
        emit(GetVehicleDetailsSuccessState());
      },
    );
  }

  //! Get Vehicle Colors
  List<VehicleColorModel> vehicleColors = [];
  Future<void> getVehcileColors() async {
    emit(GetVehicleDetailsLoadingState());
    final result = await sl<VehicleRepo>().getVehcileColor(
      page: page + 1,
    );
    result.fold(
      (error) => emit(GetVehicleDetailsErrorState(error: error)),
      (model) {
        vehicleColors += model.data as List<VehicleColorModel>;
        pagination = model.pagination;
        page += 1;
        emit(GetVehicleDetailsSuccessState());
      },
    );
  }

  //! Form
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int? selectedVehicleCategoryId;
  VehicleTypeModel? selectedVehicleType;
  VehicleBrandModel? selectedVehicleBrand;
  VehicleModelModel? selectedVehicleModel;
  VehicleColorModel? selectedVehicleColor;
  TextEditingController plateNumberController = TextEditingController();
  DateTime? vehicleLicenseImageExpiry;
  String? vehicleLicenseImageUrl;
  XFile? vehicleLicenseImage;

  selectItem() {
    emit(MyVehicleSelectItem());
  }

  bool showValidation = false;

  validationToggle(bool value) {
    showValidation = value;
    emit(MyVehicleSelectItem());
  }

  initEdit(DriverVehicleModel model) async {
    selectedVehicleCategoryId = model.vehicleCategory?.id;
    selectedVehicleType = model.vehicleType;
    selectedVehicleBrand = model.vehicleBrand;
    selectedVehicleModel = model.vehicleModel;
    selectedVehicleColor = model.vehicleColor;
    plateNumberController.text = model.plateNumber ?? "";
    vehicleLicenseImageUrl = model.vehicleLicenseImage;
    vehicleLicenseImageExpiry = model.vehicleLicenseExpiry != null
        ? DateTime.parse(model.vehicleLicenseExpiry!)
        : null;
    await getVehicleCategories();
  }
}
