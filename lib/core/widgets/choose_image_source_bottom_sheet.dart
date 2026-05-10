import 'package:image_picker/image_picker.dart';

import '../imports/imports.dart';

Future<XFile?> pickImageBottomSheet(BuildContext context) {
  final ImagePicker imagePicker = ImagePicker();
  return showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    showDragHandle: true,
    builder: (context) => Container(
      width: double.infinity,
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.symmetric(
        vertical: 24.rH(context),
        horizontal: 16.rW(context),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          customImageSource(
            context,
            title: AppStrings.takePhoto.tr(context),
            svg: Assets.imagesCamera,
            onTap: () async {
              final XFile? image =
                  await imagePicker.pickImage(source: ImageSource.camera);
              if (image != null) {
                Navigator.pop(context, image);
              }
            },
            color: AppColors.primary,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.rH(context)),
            child: const Divider(
              color: AppColors.greyText,
            ),
          ),
          customImageSource(
            context,
            title: AppStrings.pickPhotoFromGallery.tr(context),
            svg: Assets.imagesImage,
            onTap: () async {
              final XFile? image =
                  await imagePicker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                Navigator.pop(context, image);
              }
            },
          ),
        ],
      ),
    ),
  );
}

Widget customImageSource(
  BuildContext context, {
  required String title,
  required String svg,
  required Function() onTap,
  Color? color,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Row(
      children: [
        CustomSvgPicture(
          svg: svg,
          color: color,
          height: 24.rH(context),
        ),
        SizedBox(width: 8.rW(context)),
        Text(
          title,
          style: Styles.medium14(context).copyWith(
            color: AppColors.primary,
          ),
        ),
      ],
    ),
  );
}
