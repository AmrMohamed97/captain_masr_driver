import 'dart:io';

import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../imports/imports.dart';

class CustomImageField extends StatelessWidget {
  const CustomImageField({
    super.key,
    required this.image,
    required this.onTap,
    this.title,
    this.hintText,
    this.prefixSvg,
    required this.deleteOnTap,
    this.validationText,
    this.imageUrl,
    this.editOnTap,
  });

  final XFile? image;
  final String? title, hintText, prefixSvg, validationText, imageUrl;
  final Function() onTap, deleteOnTap;
  final Function()? editOnTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: EdgeInsets.only(bottom: 8.rH(context)),
              child: Text(
                title!,
                style: Styles.regular14(context).copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
          if (image == null && imageUrl == null)
            GestureDetector(
              onTap: onTap,
              child: Container(
                width: double.infinity,
                height: 51.rH(context),
                padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
                decoration: BoxDecoration(
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: validationText != null
                        ? AppColors.red
                        : AppColors.transparent,
                  ),
                ),
                child: Row(
                  children: [
                    //! Prefiex
                    if (prefixSvg != null)
                      Padding(
                        padding:
                            EdgeInsetsDirectional.only(end: 10.rW(context)),
                        child: SvgPicture.asset(
                          prefixSvg!,
                          height: 18.rH(context),
                        ),
                      ),
                    //! Hint
                    Expanded(
                      child: Text(
                        hintText ?? title ?? "",
                        style: Styles.regular14(context).copyWith(
                          color: AppColors.greyText,
                        ),
                      ),
                    ),
                    //! Suffix
                    SvgPicture.asset(
                      Assets.imagesUpload,
                    ),
                  ],
                ),
              ),
            ),
          if (imageUrl != null && image == null)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.rW(context),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).inputDecorationTheme.fillColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        imageUrl!,
                        height: 200.rH(context),
                        errorBuilder: (context, error, stackTrace) => Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 16.rH(context),
                          ),
                          child: Container(
                            height: 200.rH(context),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.grey.withOpacity(.10),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.error,
                              color: AppColors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    top: 24.rH(context),
                    end: 16.rW(context),
                    child: GestureDetector(
                      onTap: editOnTap,
                      child: CircleAvatar(
                        radius: 14.rH(context),
                        backgroundColor: AppColors.primary.withOpacity(.25),
                        child: Center(
                          child: Icon(
                            Icons.edit,
                            color: AppColors.primary,
                            size: 14.rH(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (image != null)
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).inputDecorationTheme.fillColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        File(image!.path),
                        height: 200.rH(context),
                      ),
                    ),
                  ),

                  //! Delete Button
                  PositionedDirectional(
                    top: 12.rH(context),
                    end: 12.rW(context),
                    child: GestureDetector(
                      onTap: deleteOnTap,
                      child: Container(
                        width: 32.rH(context),
                        height: 32.rH(context),
                        decoration: BoxDecoration(
                          color: AppColors.black.withOpacity(.2),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.delete,
                            size: 18.rH(context),
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          //! Validation
          if (validationText != null)
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: 4.rW(context),
                top: 4.rH(context),
              ),
              child: Text(
                validationText!,
                style: Theme.of(context).inputDecorationTheme.errorStyle,
              ),
            ),
        ],
      ),
    );
  }
}
