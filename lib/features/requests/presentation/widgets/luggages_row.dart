import '../../../../core/imports/imports.dart';
import '../../../rider_trip/data/models/trip_details_model.dart';

class LuggagesRow extends StatelessWidget {
  const LuggagesRow({
    super.key,
    required this.tripDetails,
  });

  final TripDetailsModel tripDetails;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.rH(context)),
      child: Row(
        children: [
          CustomSvgPicture(
            svg: Assets.imagesLuggages,
            height: 22.rH(context),
          ),
          SizedBox(width: 10.rW(context)),
          Text(
            AppStrings.luggages.tr(context),
            style: Styles.medium14(context).copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          SizedBox(width: 18.rW(context)),
          Expanded(
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.end,
              runSpacing: 8.rH(context),
              spacing: 13.rW(context),
              children: List.generate(
                3,
                (index) {
                  return (tripDetails.smallCount == 0 && index == 0) ||
                          (tripDetails.mediumCount == 0 && index == 1) ||
                          (tripDetails.largeCount == 0 && index == 2)
                      ? Container()
                      : Container(
                          height: 32.rH(context),
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.rW(context),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                (switch (index) {
                                  0 => AppStrings.small.tr(context),
                                  1 => AppStrings.medium.tr(context),
                                  2 => AppStrings.large.tr(context),
                                  _ => "",
                                }),
                                style: Styles.regular14(context).copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color,
                                ),
                              ),
                              Container(
                                height: 16.rH(context),
                                width: 1.rW(context),
                                margin: EdgeInsets.symmetric(
                                  horizontal: 8.rW(context),
                                ),
                                color: AppColors.white,
                              ),
                              Text(
                                (switch (index) {
                                  0 => tripDetails.smallCount.toString(),
                                  1 => tripDetails.mediumCount.toString(),
                                  2 => tripDetails.largeCount.toString(),
                                  _ => "",
                                }),
                                style: Styles.regular14(context).copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color,
                                ),
                              ),
                            ],
                          ),
                        );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
