import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/partial_star.dart';
import '../../../rider_trip/data/models/share_trip_model.dart';

class AvaibleShareTripCard extends StatefulWidget {
  const AvaibleShareTripCard({
    super.key,
    required this.model,
    this.sendRequestOnTap,
    required this.length,
  });

  final ShareTripModel model;
  final Function(List<int> selectedSeats)? sendRequestOnTap;
  final int length;

  @override
  State<AvaibleShareTripCard> createState() => _AvaibleShareTripCardState();
}

class _AvaibleShareTripCardState extends State<AvaibleShareTripCard> {
  List<int> selectedSeats = [];

  ShareTripModel get model => widget.model;
  Function(List<int>)? get sendRequestOnTap => widget.sendRequestOnTap;

  String formatLocalTime(String time, String language) {
    final DateTime parsedTime = DateFormat("HH:mm").parse(time);
    String formattedTime;
    formattedTime = DateFormat.jm(language).format(parsedTime);
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.rH(context)),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2.rH(context)),
            blurRadius: 11,
            color: AppColors.black.withOpacity(.14),
          ),
        ],
      ),
      child: Column(
        children: [
          //! Type & Date
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 12.rH(context),
              horizontal: 16.rW(context),
            ),
            child: Text(
              model.type == "round_trip"
                  ? AppStrings.scheduleTrip.tr(context)
                  : AppStrings.onMyWay.tr(context),
              style: Styles.semibold16Primary(context).copyWith(
                color: AppColors.white,
              ),
            ),
          ),
          //! Content
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(
              bottom: 1.rH(context),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 17.rH(context),
              horizontal: 16.rW(context),
            ),
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
                //! User Details & Arrive In
                Row(
                  children: [
                    //! User Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        model.driver?.profilePicture ?? "",
                        height: 46.rH(context),
                        width: 46.rH(context),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            SvgPicture.asset(
                          Assets.imagesPersonSvg,
                          color: AppColors.grey,
                          height: 46.rH(context),
                        ),
                      ),
                    ),

                    SizedBox(width: 9.rW(context)),

                    //! Name & Rating
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //! Name
                          Text(
                            model.driver?.username ?? "",
                            style: Styles.semibold16Primary(context).copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                          SizedBox(height: 2.rH(context)),
                          //! Rating
                          Row(
                            children: [
                              SinglePartialStar(
                                value: model.driver?.rating?.toDouble() ?? 0.0,
                                starSize: 18.rH(context),
                              ),
                              SizedBox(width: 7.rW(context)),
                              Text(
                                "${model.driver?.rating?.toStringAsFixed(3) ?? 0.0}",
                                style: Styles.regular14(context).copyWith(
                                  color: AppColors.greyText,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 9.rW(context)),

                    //! Arrive In
                    if (model.type != "round_trip")
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.arrivesIn.tr(context),
                            style: Styles.regular12(context).copyWith(
                              color: AppColors.greyText,
                            ),
                          ),
                          SizedBox(height: 2.rH(context)),
                          Row(
                            children: [
                              Text(
                                "5 ${AppStrings.min.tr(context)}",
                                style: Styles.medium12(context).copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color,
                                ),
                              ),
                              Container(
                                height: 14.rH(context),
                                width: 1,
                                margin: EdgeInsets.symmetric(
                                  horizontal: 4.rW(context),
                                ),
                                color: AppColors.greyText,
                              ),
                              Text(
                                "3.4 ${AppStrings.km.tr(context)}",
                                style: Styles.medium12(context).copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),

                //! Divider
                CustomDivider(space: 16.rH(context)),

                //! Car Details
                Row(
                  children: [
                    //! Car Image
                    Image.asset(
                      Assets.imagesTestCar1,
                      height: 27.rH(context),
                    ),
                    SizedBox(width: 11.rW(context)),
                    //! Car Model
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //! Car Model
                          Text(
                            model.vehicleBrand ?? "",
                            style: Styles.semibold12(context).copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                          Text(
                            "${model.vehicleColor ?? ""} - ${model.vehiclePlats ?? ""}",
                            style: Styles.regular14(context).copyWith(
                              color: AppColors.greyText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    //! Cost
                    // Text(
                    //   "${model.price ?? "??"} ${AppStrings.egp.tr(context)}",
                    //   style: Styles.semibold20Primary(context).copyWith(
                    //     color: AppColors.red,
                    //   ),
                    // ),
                  ],
                ),

                SizedBox(height: 16.rH(context)),

                //! Start & End Point
                StartAndEndPoint(
                  startValue: model.pickupAddress ?? "??",
                  endValue: model.dropoffAddress ?? "??",
                  startTitle: AppStrings.startPoint.tr(context),
                ),

                //! Date From - Date To
                if (model.type == "round_trip")
                  Padding(
                    padding: EdgeInsets.only(top: 16.rH(context)),
                    child: Row(
                      spacing: 10.rW(context),
                      children: [
                        //! Icon
                        SvgPicture.asset(
                          Assets.imagesCalender,
                          color: AppColors.primary,
                        ),
                        //! Date From
                        Text(
                          model.dateFrom ?? "???",
                          style: Styles.regular14(context).copyWith(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        Text(
                          AppStrings.to.tr(context),
                          style: Styles.regular14(context).copyWith(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        //! Date To
                        Text(
                          model.dateTo ?? "???",
                          style: Styles.regular14(context).copyWith(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ],
                    ),
                  ),

                //! Time
                if (model.type == "round_trip" && model.time != null)
                  Padding(
                    padding: EdgeInsets.only(top: 8.rH(context)),
                    child: Row(
                      spacing: 10.rW(context),
                      children: [
                        //! Icon
                        SvgPicture.asset(
                          Assets.imagesTime,
                          color: AppColors.primary,
                        ),
                        //! Time
                        Text(
                          formatLocalTime(
                            model.time!,
                            context.read<GlobalCubit>().language,
                          ),
                          style: Styles.regular14(context).copyWith(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ],
                    ),
                  ),

                //! Available Seats
                if (model.availableSeets.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 16.rH(context)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //! Icon
                        SvgPicture.asset(
                          Assets.imagesSeat,
                          color: AppColors.primary,
                          height: 20.rH(context),
                        ),
                        SizedBox(width: 10.rW(context)),
                        //! Names
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${AppStrings.availableSeats.tr(context)}:",
                                style: Styles.regular14(context).copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4.rH(context)),
                              Wrap(
                                spacing: 8.rW(context),
                                runSpacing: 8.rH(context),
                                children: model.availableSeets.map((seat) {
                                  final isSelected =
                                      selectedSeats.contains(seat.id);
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (isSelected) {
                                          selectedSeats.remove(seat.id);
                                        } else {
                                          if (seat.id != null) {
                                            if (selectedSeats.length <
                                                widget.length) {
                                              selectedSeats.add(seat.id!);
                                            }
                                          }
                                        }
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.primary
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: AppColors.primary,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        seat.name ?? "",
                                        style:
                                            Styles.regular14(context).copyWith(
                                          color: isSelected
                                              ? Colors.white
                                              : Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.color,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: 25.rH(context)),

                //! Action Buttons
                if (model.requestStatus == "pending")
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(.2),
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.hourglass_empty_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppStrings.yourRequestHasBeenSent.tr(context),
                          style: Styles.semibold16Primary(context)
                              .copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                  )
                else if (model.requestStatus == "accepted")
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.green.withOpacity(.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.green.withOpacity(.2),
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.green,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppStrings.driverAcceptedYourRequest.tr(context),
                          style: Styles.semibold16Primary(context)
                              .copyWith(color: AppColors.green),
                        ),
                      ],
                    ),
                  )
                else if (model.requestStatus == 'cancelled' ||
                    model.requestStatus == 'canceled' ||
                    model.requestStatus == 'canclled' ||
                    model.requestStatus == 'cancled' ||
                    model.requestStatus == 'rejected' ||
                    model.requestStatus == 'refused')
                  Column(
                    children: [
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.red.withOpacity(.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.red.withOpacity(.2),
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.cancel_outlined,
                              color: AppColors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              (model.requestStatus == 'cancelled' ||
                                      model.requestStatus == 'canceled' ||
                                      model.requestStatus == 'canclled' ||
                                      model.requestStatus == 'cancled')
                                  ? AppStrings.driverCancelledTrip.tr(context)
                                  : AppStrings.driverRejectedYourRequest
                                      .tr(context),
                              style: Styles.semibold16Primary(context)
                                  .copyWith(color: AppColors.red),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.rH(context)),
                      CustomButton(
                        enabled: model.availableSeets.isEmpty ||
                            selectedSeats.length == widget.length,
                        onPressed: () => sendRequestOnTap?.call(selectedSeats),
                        title: AppStrings.resendRequest.tr(context),
                      ),
                    ],
                  )
                else
                  CustomButton(
                    enabled: model.availableSeets.isEmpty ||
                        selectedSeats.length == widget.length,
                    onPressed: () => sendRequestOnTap?.call(selectedSeats),
                    title: AppStrings.sendRequest.tr(context),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
