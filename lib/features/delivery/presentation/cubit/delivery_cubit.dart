import 'package:image_picker/image_picker.dart';

import '../../../../core/imports/imports.dart';
import '../../../my_vehicle/data/models/vehicle_category_model.dart';
import '../../../my_vehicle/data/repo/vehicle_repo.dart';
import '../../data/models/delivery_item_model.dart';
import '../../data/models/delivery_size_model.dart';
import '../../data/repo/delivery_repo.dart';

part 'delivery_state.dart';

class DeliveryCubit extends Cubit<DeliveryState> {
  DeliveryCubit() : super(DeliveryInitial()) {
    getVehicleCategories();
  }

  //! Get Vehicle Categories
  List<VehicleCategoryModel> vehicleCategories = [];
  Future<void> getVehicleCategories() async {
    emit(DeliveryGetVehicleCategoriesLoadingState());
    final result = await sl<VehicleRepo>().getVehicleCategories();
    result.fold(
      (error) => emit(DeliveryErrorState(error: error)),
      (list) {
        vehicleCategories = list;
        if (vehicleCategories.isNotEmpty) {
          selectedVehicleCategoryId = vehicleCategories.first.id;
          Future.wait([
            getDeliveryItems(),
            getDeliveryItemsSizes(),
          ]);
        }
        emit(DeliverySuccessState());
      },
    );
  }

  //! Get Delivery Items
  List<DeliveryItemModel> deliveryItems = [];
  Future<void> getDeliveryItems() async {
    emit(GetDeliveryItemsLoadingState());
    final result = await sl<DeliveryRepo>().getDeliveryItems(
      vehicleCategoryId: selectedVehicleCategoryId ?? 0,
    );
    result.fold(
      (error) => emit(DeliveryErrorState(error: error)),
      (list) {
        deliveryItems = list;
        emit(GetDeliveryItemsLoadingState());
      },
    );
  }

  //! Get Delivery Items Sizes
  List<DeliverySizeModel> deliverySizes = [];
  Future<void> getDeliveryItemsSizes() async {
    emit(GetDeliveryItemsSizesLoadingState());
    final result = await sl<DeliveryRepo>().getDeliveryItemsSizes(
      vehicleCategoryId: selectedVehicleCategoryId ?? 0,
    );
    result.fold(
      (error) => emit(DeliveryErrorState(error: error)),
      (list) {
        deliverySizes = list;
        emit(GetDeliveryItemsSizesLoadingState());
      },
    );
  }

  //! Sending Or Receiving
  bool isSending = true;

  sendingOrReceivingToggle(int index) {
    isSending = index == 0;
    emit(SendingOrReceivingToggleState());
  }

  //! Form
  TextEditingController noteController = TextEditingController();
  int? selectedVehicleCategoryId,
      selectedItemId,
      selectedSizeId,
      selectedPaymentIndex;

  chooseVhecileCategory(int index) {
    selectedVehicleCategoryId = vehicleCategories[index].id;
    selectedItemId = null;
    selectedSizeId = null;
    deliveryItems.clear();
    deliverySizes.clear();
    Future.wait([
      getDeliveryItems(),
      getDeliveryItemsSizes(),
    ]);
    emit(PackageDetailsPickState());
  }

  chooseItemType(int index) {
    selectedItemId = deliveryItems[index].id;
    emit(PackageDetailsPickState());
  }

  chooseSize(int index) {
    selectedSizeId = deliverySizes[index].id;
    emit(PackageDetailsPickState());
  }

  choosePaymentType(int index) {
    selectedPaymentIndex = index;
    emit(PackageDetailsPickState());
  }

  bool isFormValidate() {
    if (selectedVehicleCategoryId != null &&
        selectedItemId != null &&
        selectedSizeId != null &&
        selectedPaymentIndex != null) {
      return true;
    } else {
      return false;
    }
  }

  //! Package Photo
  XFile? packagePhoto;
}
