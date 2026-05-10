import '../../../../core/imports/imports.dart';
import '../../data/models/saved_place_model.dart';

class SavedPlaceCard extends StatelessWidget {
  const SavedPlaceCard({
    super.key,
    required this.model,
    required this.onTap,
    this.deleteOnTap,
    this.editOnTap,
  });

  final SavedPlaceModel model;
  final Function()? onTap, deleteOnTap, editOnTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 16.rW(context),
          vertical: 13.rH(context),
        ),
        margin: EdgeInsets.only(bottom: 16.rH(context)),
        decoration: BoxDecoration(
          color: context.read<GlobalCubit>().isDarkMode
              ? Theme.of(context).cardColor
              : AppColors.grey3,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            //! Title & Address
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //! Title
                  Row(
                    children: [
                      //! Icon
                      CustomSvgPicture(
                        svg: switch (model.iconType) {
                          "1" => Assets.imagesHomeActive,
                          "2" => Assets.imagesSchool,
                          "3" => Assets.imagesWork,
                          "4" => Assets.imagesAirplane,
                          "5" => Assets.imagesCafe,
                          _ => Assets.imagesPinLocation,
                        },
                        height: 16.rH(context),
                        width: 16.rW(context),
                      ),
                      SizedBox(width: 8.rW(context)),
                      //! Title
                      Text(
                        model.type ?? "",
                        style: Styles.medium14(context).copyWith(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ],
                  ),
                  //! Address
                  if (model.address != null)
                    Padding(
                      padding:
                          EdgeInsetsDirectional.only(start: 24.rW(context)),
                      child: Text(
                        model.address!,
                        style: Styles.regular11(context).copyWith(
                          color: AppColors.greyText,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(width: 8.rW(context)),

            //! Edit
            GestureDetector(
              onTap: editOnTap,
              child: CustomSvgPicture(
                svg: Assets.imagesEdit,
                color: AppColors.green,
                height: 18.rH(context),
              ),
            ),

            SizedBox(width: 8.rW(context)),

            //! Delete
            GestureDetector(
              onTap: deleteOnTap,
              child: CustomSvgPicture(
                svg: Assets.imagesDelete,
                height: 18.rH(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
