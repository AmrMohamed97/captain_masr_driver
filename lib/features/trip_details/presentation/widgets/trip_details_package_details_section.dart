import '../../../../core/imports/imports.dart';
import '../../../rider_trip/data/models/trip_details_model.dart';
import '../views/cashed_images.dart';

class TripDetailsPackageDetailsSection extends StatelessWidget {
  const TripDetailsPackageDetailsSection({
    super.key,
    required this.model,
  });

  final TripDetailsModel model;

  @override
  Widget build(BuildContext context) {
    return CustomTable(
      title: AppStrings.packageDetails.tr(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //! Package Details
          Row(
            children: [
              //! Type Of Shipment
              if (model.deliverItem != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.typeOfShipment.tr(context),
                      style: Styles.medium14(context).copyWith(
                        color: AppColors.greyText,
                      ),
                    ),
                    SizedBox(height: 8.rH(context)),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomSvgPicture(
                          svg: Assets.imagesPackage,
                          height: 19.rH(context),
                        ),
                        SizedBox(width: 12.rW(context)),
                        //type of shipment value
                        Text(
                          model.deliverItem ?? "??",
                          style: Styles.medium14(context).copyWith(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              if (model.deliverItemSize != null && model.deliverItem != null)
                Expanded(
                  child: Center(
                    child: Container(
                      width: 1,
                      height: 34.rH(context),
                      color: AppColors.greyText.withOpacity(.5),
                    ),
                  ),
                ),
              //! Size Of Shipment
              if (model.deliverItemSize != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.sizeOfShipment.tr(context),
                      style: Styles.medium14(context).copyWith(
                        color: AppColors.greyText,
                      ),
                    ),
                    SizedBox(height: 8.rH(context)),
                    //size of shipment value
                    Text(
                      model.deliverItemSize ?? "??",
                      style: Styles.medium14(context).copyWith(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          //! Additional Note
          if (model.notes != null && model.notes != "" && model.notes != " ")
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.rH(context)),
                Text(
                  AppStrings.additionNotes.tr(context),
                  style: Styles.medium14(context).copyWith(
                    color: AppColors.greyText,
                  ),
                ),
                SizedBox(height: 10.rH(context)),
                CustomSelectContainer(
                  value: model.notes,
                  onTap: () {},
                  borderColor: AppColors.transparent,
                  fillColor: Theme.of(context).cardColor,
                  icon: Container(),
                ),
              ],
            ),

          //! Images
          if (model.deliveryImage != null || model.deliveryImageDriver != null)
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 24.rH(context)),
              padding: EdgeInsets.symmetric(
                horizontal: 21.5.rW(context),
                vertical: 21.rH(context),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      //! Image
                      CachedImage(
                        showImageOnTap: true,
                        radius: 4,
                        url: model.deliveryImage ?? "",
                        // index == 0
                        //     ? model.deliverItem
                        //     : model.deliveryImageDriver,
                        width: 139.rW(context),
                        height: 113.rH(context),
                        fit: BoxFit.cover,
                        // borderRadius: 5,
                      ),
                      SizedBox(height: 8.rH(context)),
                      //! Title
                      Text(
                        AppStrings.sendersPhoto.tr(context),
                        style: Styles.regular14(context).copyWith(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      //! Image
                      CachedImage(
                        showImageOnTap: true,
                        radius: 4,
                        url: model.deliveryImageDriver ?? "",
                        width: 139.rW(context),
                        height: 113.rH(context),
                        fit: BoxFit.cover,
                        // borderRadius: 5,
                      ),
                      SizedBox(height: 8.rH(context)),
                      //! Title
                      Text(
                        AppStrings.couriersPhoto.tr(context),
                        style: Styles.regular14(context).copyWith(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          SizedBox(height: 24.rH(context)),
        ],
      ),
    );
  }
}
