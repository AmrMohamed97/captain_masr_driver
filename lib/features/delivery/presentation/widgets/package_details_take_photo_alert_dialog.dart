import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../../../core/imports/imports.dart';

class PackegeDetailsTakePhotoAlertDialog extends StatefulWidget {
  const PackegeDetailsTakePhotoAlertDialog({
    super.key,
    this.canSkip = true,
  });

  final bool canSkip;

  @override
  State<PackegeDetailsTakePhotoAlertDialog> createState() =>
      _PackegeDetailsTakePhotoAlertDialogState();
}

class _PackegeDetailsTakePhotoAlertDialogState
    extends State<PackegeDetailsTakePhotoAlertDialog> {
  ImagePicker imagePicker = ImagePicker();
  XFile? packagePhoto;

  Future takePhoto() async {
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.camera);
    packagePhoto = image;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      elevation: 0,
      content: Container(
        width: 344.rW(context),
        padding: EdgeInsets.symmetric(
          vertical: 19.rH(context),
          horizontal: 16.rW(context),
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //! Label
            Text(
              AppStrings.takeAPhoto.tr(context),
              style: Styles.semibold21Primary(context),
            ),

            SizedBox(height: 23.rH(context)),

            //! Photo
            if (packagePhoto == null)
              Image.asset(
                Assets.imagesTakeAPhotoPng,
                height: 202.rH(context),
              ),

            if (packagePhoto != null)
              Container(
                width: double.infinity,
                height: 202.rH(context),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Image.file(
                        File(packagePhoto!.path),
                        height: 202.rH(context),
                        fit: BoxFit.contain,
                      ),
                    ),
                    //! Remove Button
                    PositionedDirectional(
                      top: 16.rH(context),
                      end: 16.rW(context),
                      child: GestureDetector(
                        onTap: () {
                          packagePhoto = null;
                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: AppColors.grey.withOpacity(.25),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(height: 16.rH(context)),

            //! Title
            Text(
              AppStrings.snapQuickPhotoOfYourItem.tr(context),
              style: Styles.semibold18Primary(context).copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 11.rH(context)),

            //! Subtitle
            Text(
              AppStrings.itMakesPickupEasierAndSafer.tr(context),
              style: Styles.semibold14Primary(context).copyWith(
                color: AppColors.greyText,
              ),
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 40.rH(context)),

            //! Take It Button
            CustomButton(
              onPressed: () {
                if (packagePhoto == null) {
                  takePhoto();
                } else {
                  Navigator.pop(context, [true, packagePhoto]);
                }
              },
              title: packagePhoto != null
                  ? AppStrings.cOntinue.tr(context)
                  : AppStrings.takeIt.tr(context),
            ),

            SizedBox(height: 16.rH(context)),

            //! Skip Button
            if (widget.canSkip)
              GestureDetector(
                onTap: () {
                  Navigator.pop(context, [false, null]);
                },
                child: Text(
                  AppStrings.skip.tr(context),
                  style: Styles.semibold14Primary(context),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
