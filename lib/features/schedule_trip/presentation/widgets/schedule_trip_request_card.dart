import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_cached_network_image.dart';
import '../../../rider_trip/data/models/trip_details_model.dart';

class ScheduleTripRequestCard extends StatelessWidget {
  const ScheduleTripRequestCard({
    super.key,
    required this.model,
    this.accepted = false,
    required this.onAccept,
    required this.onDecline,
    required this.onCancel,
  });

  final TripDetailsModel model;
  final bool accepted;
  final VoidCallback onAccept, onDecline, onCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        bottom: 1.rH(context),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2.rH(context)),
            blurRadius: 11,
            color: AppColors.grey.withOpacity(.14),
          ),
        ],
      ),
      child: Column(
        children: [
          //! Trip Title
          SizedBox(
            width: double.infinity,
            height: 46.rH(context),
            child: Center(
              child: Text(
                AppStrings.scheduleTrip.tr(context),
                style: Styles.semibold16Primary(context).copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          //! Content
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 21.rH(context)),

                //! User Details & Cost
                Row(
                  children: [
                    //! User Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: model.riderImage != null
                          ? CustomCachedNetworkImage(
                              imageUrl: model.riderImage,
                              h: 46.rH(context),
                              w: 46.rH(context),
                              fit: BoxFit.cover,
                            )
                          : SvgPicture.asset(
                              Assets.imagesPersonSvg,
                              height: 46.rH(context),
                              width: 46.rH(context),
                              fit: BoxFit.cover,
                              color: AppColors.grey,
                            ),
                    ),

                    SizedBox(width: 9.rW(context)),

                    //! Name & Rating
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 4.rH(context),
                        children: [
                          //! Name
                          Text(
                            model.riderName ?? "",
                            style: Styles.semibold16Primary(context).copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                          //! Going & Gathering
                          // Row(
                          //   children: [
                          //     Container(
                          //       padding: EdgeInsets.all(3.rH(context)),
                          //       decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(4),
                          //         color: context.read<GlobalCubit>().isDarkMode
                          //             ? AppColors.grey3.withOpacity(.15)
                          //             : AppColors.grey3,
                          //       ),
                          //       child: CustomSvgPicture(
                          //         svg: Assets.imagesRefresh,
                          //         height: 15.rH(context),
                          //       ),
                          //     ),
                          //     SizedBox(width: 8.rW(context)),
                          //     Text(
                          //       AppStrings.goingAndReturning.tr(context),
                          //       style: Styles.medium12(context).copyWith(
                          //         color: AppColors.greyText,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),

                    // SizedBox(width: 9.rW(context)),

                    //! Cost
                    // Text(
                    //   "530 ${AppStrings.egp.tr(context)}",
                    //   style: Styles.semibold20Primary(context).copyWith(
                    //     color: AppColors.red,
                    //   ),
                    // ),
                  ],
                ),

                //! Divider
                Padding(
                  padding: EdgeInsets.only(
                    top: 4.rH(context),
                    bottom: 12.rH(context),
                  ),
                  child: Divider(
                    color: AppColors.greyText.withOpacity(.5),
                  ),
                ),

                //! Start & End Point
                StartAndEndPoint(
                  startValue: model.pickupAddress ?? "",
                  endValue: model.dropoffAddress ?? "",
                  startTitle: AppStrings.startPoint.tr(context),
                ),

                //! Divider
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 12.rH(context),
                  ),
                  child: Divider(
                    color: AppColors.greyText.withOpacity(.5),
                  ),
                ),

                //! Rider Wanted Days
                if (model.days != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8.rH(context),
                    children: [
                      Text(
                        AppStrings.riderWantedDays.tr(context),
                        style: Styles.medium14(context).copyWith(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      SizedBox(
                        height: 40.rH(context),
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          itemCount: model.days?.length ?? 0,
                          separatorBuilder: (context, index) {
                            return SizedBox(width: 12.rW(context));
                          },
                          itemBuilder: (context, index) {
                            final DateTime date = DateFormat('yyyy-MM-dd')
                                .parse(model.days![index]);
                            return _buildDayCard(context, date);
                          },
                        ),
                      ),
                    ],
                  ),

                SizedBox(height: 18.5.rH(context)),

                //! Seats Needed
                Row(
                  children: [
                    Text(
                      AppStrings.seatsNeeded.tr(context),
                      style: Styles.regular14(context).copyWith(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 32,
                      padding: EdgeInsets.symmetric(horizontal: 10.rW(context)),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          CustomSvgPicture(
                            svg: Assets.imagesSeat,
                            height: 20.rH(context),
                          ),
                          Container(
                            height: 20.rH(context),
                            width: 1,
                            margin: EdgeInsets.symmetric(
                              horizontal: 10.rW(context),
                            ),
                            color: AppColors.white,
                          ),
                          Text(
                            model.seatsAvailable ??
                                model.seatsNeeded?.toString() ??
                                model.seatsIds?.length.toString() ??
                                "??",
                            style: Styles.regular14(context).copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.rH(context)),

                //! Buttons
                if (!accepted)
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          onPressed: onDecline,
                          title: AppStrings.decline.tr(context),
                          height: 41.rH(context),
                          color: AppColors.transparent,
                          borderColor: AppColors.primary,
                          textColor: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: 22.rW(context)),
                      Expanded(
                        child: CustomButton(
                          onPressed: onAccept,
                          title: AppStrings.accept.tr(context),
                          height: 41.rH(context),
                        ),
                      ),
                    ],
                  ),

                //! Cancel Booking Button
                if (accepted)
                  CustomButton(
                    onPressed: onCancel,
                    title: AppStrings.cancelBooking.tr(context),
                    color: AppColors.transparent,
                    height: 41.rH(context),
                    borderColor: AppColors.red,
                    textColor: AppColors.red,
                  ),

                SizedBox(height: 15.rH(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCard(BuildContext context, DateTime date) {
    return Container(
      width: 31.rW(context),
      height: 40.rH(context),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(.15),
        border: Border.all(
          color: AppColors.primary,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 14.rH(context),
            child: FittedBox(
              child: Text(
                date.day.toString(),
                style: Styles.semibold18Primary(context).copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
          ),
          SizedBox(height: 2.rH(context)),
          SizedBox(
            height: 12.rH(context),
            child: FittedBox(
              child: Text(
                DateFormat('EEE').format(date),
                style: Styles.semibold18Primary(context).copyWith(
                  color: AppColors.greyText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
