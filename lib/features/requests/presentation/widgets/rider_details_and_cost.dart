import 'package:flutter_svg/svg.dart';

import '../../../../core/imports/imports.dart';
import '../../../rider_trip/data/models/trip_details_model.dart';

class RiderDetailsAndCost extends StatelessWidget {
  const RiderDetailsAndCost({
    super.key,
    required this.model,
  });

  final TripDetailsModel model;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //! Image
        if (model.riderImage != null)
          SizedBox(
            height: 40.rH(context),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                model.riderImage ?? "",
                errorBuilder: (context, error, stackTrace) => SvgPicture.asset(
                  Assets.imagesPersonSvg,
                  height: 40.rH(context),
                  color: AppColors.grey,
                ),
              ),
            ),
          ),
        SizedBox(width: 9.rW(context)),
        //! Name & Prefernces
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.riderName ?? "",
                style: Styles.semibold14Primary(context).copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              //! Delivery Type
              if (model.tripType == "delivery")
                Row(
                  children: [
                    CustomSvgPicture(
                      svg: model.deliverType == "sending"
                          ? Assets.imagesSending
                          : Assets.imagesRecieving,
                      height: 16.rH(context),
                    ),
                    SizedBox(width: 8.rW(context)),
                    Text(
                      model.deliverType == "sending"
                          ? AppStrings.sending.tr(context)
                          : AppStrings.receiving.tr(context),
                      style: Styles.regular12(context).copyWith(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
              //! Preferences
              if (model.tripType != "delivery")
                Wrap(
                  direction: Axis.horizontal,
                  children: List.generate(
                    4,
                    (index) {
                      return (model.preferences?.coolRide != true &&
                                  index == 0) ||
                              (model.preferences?.quietRide != true &&
                                  index == 1) ||
                              (model.preferences?.smokingFriendly != true &&
                                  index == 2) ||
                              (model.preferences?.petsFree != true &&
                                  index == 3)
                          ? const SizedBox.shrink()
                          : Container(
                              width: 22.rW(context),
                              height: 22.rH(context),
                              margin: EdgeInsetsDirectional.only(
                                end: 5.rW(context),
                                top: 4.rH(context),
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.grey3.withOpacity(.25),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Center(
                                child: SizedBox(
                                  height: 16.rH(context),
                                  width: 16.rW(context),
                                  child: CustomSvgPicture(
                                    svg: (switch (index) {
                                      0 => Assets.imagesAirConditioner,
                                      1 => Assets.imagesMusic,
                                      2 => Assets.imagesSmoking,
                                      3 => Assets.imagesPets,
                                      _ => "",
                                    }),
                                  ),
                                ),
                              ),
                            );
                    },
                  ),
                ),
            ],
          ),
        ),
        //! Cost
        Text(
          "${model.price ?? "??"} ${AppStrings.egp.tr(context)}",
          style: Styles.semibold20Primary(context).copyWith(
            color: AppColors.red,
          ),
        ),
      ],
    );
  }
}
