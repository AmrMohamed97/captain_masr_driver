import 'package:image_picker/image_picker.dart';

class DeliveryDetailsModel {
  int vehicleCategoryId, deliveryItemId, deliveryItemSizeId;
  String deliveryType, paymentType;
  String? note;
  XFile? image;

  DeliveryDetailsModel({
    required this.deliveryType,
    required this.vehicleCategoryId,
    required this.deliveryItemId,
    required this.deliveryItemSizeId,
    required this.paymentType,
    required this.note,
    required this.image,
  });
}
