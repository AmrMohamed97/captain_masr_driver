import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_bottom_dragable_container.dart';
import '../../../../core/widgets/custom_shimmer.dart';
import '../../../preferences/presentation/widgets/preferences_alert_dialog.dart';
import '../../../promo_code/data/models/promo_code_model.dart';
import '../../../schedule_trip/presentation/widgets/schedule_trip_form.dart';
import '../../../wallet/presentation/views/payment_methods_view.dart';
import '../../data/models/rider_share_trip_data_model.dart';
import '../cubit/start_trip_cubit/start_trip_cubit.dart';
import '../views/available_share_trips.dart';
import 'select_luggages_number_container.dart';
import 'start_ride_promo_code_alert_dialog.dart';
import 'start_trip_choose_start_and_end_locations.dart';
import 'start_trip_on_my_way_container.dart';

class StartTripBottomSection extends StatelessWidget {
  const StartTripBottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartTripCubit, StartTripState>(
      builder: (context, state) {
        final cubit = context.read<StartTripCubit>();
        return CustomBottomDragableContainer(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                //! Drag Handler
                Center(
                  child: Container(
                    width: 74.rW(context),
                    height: 4.rH(context),
                    margin: EdgeInsets.symmetric(
                      vertical: 11.rH(context),
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                    ),
                  ),
                ),
                //! First Container
                if (cubit.details != null)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.rW(context),
                      vertical: 17.rH(context),
                    ),
                    margin: EdgeInsets.only(bottom: 10.rH(context)),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        //! Title
                        Text(
                          AppStrings.tripDetails.tr(context),
                          style: Styles.semibold16Primary(context).copyWith(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        SizedBox(height: 18.rH(context)),
                        //! Distance & Duration
                        DistanceAndDuration(
                          distance: "~${cubit.details?.distanceKm ?? "??"}",
                          duration: "~${cubit.details?.timeMinutes ?? "??"}",
                        ),
                        SizedBox(height: 18.rH(context)),
                        //! Estimated Cost
                        Row(
                          children: [
                            CustomSvgPicture(
                              svg: Assets.imagesCashPaper,
                              height: 19.rH(context),
                            ),
                            SizedBox(width: 6.rW(context)),
                            Text(
                              AppStrings.estimatedCost.tr(context),
                              style: Styles.regular14(context).copyWith(
                                color: AppColors.greyText,
                              ),
                            ),
                            const Spacer(),
                            if (!cubit.isShareRide)
                              Text(
                                "${cubit.promoCodeModel != null ? (cubit.discountPrice ?? (cubit.details?.price ?? "??")) : (cubit.details?.price ?? "??")} ${AppStrings.egp.tr(context)}",
                                style:
                                    Styles.semibold16Primary(context).copyWith(
                                  color: AppColors.red,
                                ),
                              ),
                            if (cubit.isShareRide)
                              Text(
                                cubit.details?.totalPrice.toString() ?? '',
                                style:
                                    Styles.semibold16Primary(context).copyWith(
                                  color: AppColors.red,
                                ),
                              ),
                            // Text(
                            //   "${cubit.promoCodeModel != null ? ((cubit.details?.totalPrice ?? cubit.discountPrice ?? "??")) : (cubit.details?.totalPrice ?? cubit.details?.price ?? "??")} ${AppStrings.egp.tr(context)}",
                            //   style: Styles.semibold16Primary(context).copyWith(
                            //     color: AppColors.red,
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),

                //! Second Container
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: 20.rH(context),
                    horizontal: 16.rW(context),
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: cubit.driverOnMyWay
                      ? const StartTripOnMyWayContainer()
                      : SizedBox(
                          height: 480.rH(context),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                //! Title
                                if (cubit.details == null)
                                  Text(
                                    AppStrings.tripDetails.tr(context),
                                    style: Styles.semibold16Primary(context)
                                        .copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color,
                                    ),
                                  ),

                                SizedBox(height: 16.rH(context)),

                                //! Vehicle Categories
                                if (!cubit.isDelivery)
                                  SizedBox(
                                    height: cubit.vehicleCategories.isEmpty
                                        ? 40.rH(context)
                                        : 74.rH(context),
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      children: List.generate(
                                        cubit.vehicleCategories.isNotEmpty
                                            ? cubit.vehicleCategories.length
                                            : 4,
                                        (index) => Padding(
                                          padding: EdgeInsetsDirectional.only(
                                            start:
                                                index != 0 ? 10.rW(context) : 0,
                                          ),
                                          child: cubit.vehicleCategories.isEmpty
                                              ? CustomShimmer(
                                                  w: 67.rW(context),
                                                  h: 40.rH(context),
                                                  borderRadius: 6,
                                                )
                                              : Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () => cubit
                                                          .chooseVhecileCategory(
                                                              index),
                                                      child: AnimatedContainer(
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    300),
                                                        width: 67.rW(context),
                                                        height: 50.rH(context),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal:
                                                              8.rW(context),
                                                          vertical:
                                                              8.rH(context),
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .cardColor,
                                                          border: Border.all(
                                                            color: cubit
                                                                        .vehicleCategories[
                                                                            index]
                                                                        .id ==
                                                                    cubit
                                                                        .selectedVehicleCategoryId
                                                                ? AppColors
                                                                    .primary
                                                                : AppColors
                                                                    .transparent,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              offset: Offset(
                                                                  0,
                                                                  2.rH(
                                                                      context)),
                                                              blurRadius: 7,
                                                              color: Theme.of(
                                                                      context)
                                                                  .shadowColor,
                                                            ),
                                                          ],
                                                        ),
                                                        child: cubit
                                                                    .vehicleCategories[
                                                                        index]
                                                                    .logo
                                                                    ?.contains(
                                                                        ".svg") ??
                                                                false
                                                            ? SvgPicture
                                                                .network(
                                                                cubit
                                                                        .vehicleCategories[
                                                                            index]
                                                                        .logo ??
                                                                    "",
                                                                errorBuilder: (context,
                                                                        error,
                                                                        stackTrace) =>
                                                                    const Icon(
                                                                  Icons.error,
                                                                  color:
                                                                      AppColors
                                                                          .grey,
                                                                ),
                                                              )
                                                            : Image.network(
                                                                cubit
                                                                        .vehicleCategories[
                                                                            index]
                                                                        .logo ??
                                                                    "",
                                                                errorBuilder: (context,
                                                                        error,
                                                                        stackTrace) =>
                                                                    const Icon(
                                                                  Icons.error,
                                                                  color:
                                                                      AppColors
                                                                          .grey,
                                                                ),
                                                              ),
                                                      ),
                                                    ),
                                                    Text(
                                                      cubit
                                                              .vehicleCategories[
                                                                  index]
                                                              .name ??
                                                          "",
                                                      style: Styles.regular12(
                                                              context)
                                                          .copyWith(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge
                                                            ?.color,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),

                                SizedBox(height: 16.rH(context)),

                                //! Start & End Location
                                const StartTripChooseStartAndEndLocations(),

                                SizedBox(height: 16.rH(context)),

                                //! Female, Baby Carriage and Luggages Switches
                                if (!cubit.isDelivery &&
                                    !cubit.driverOnMyWay &&
                                    !cubit.isShareRide)
                                  Column(
                                    children: [
                                      //! Female
                                      CustomSwitchListTile(
                                        svg: Assets.imagesFemale,
                                        title: AppStrings.female.tr(context),
                                        value: cubit.isFemale,
                                        onChanged: (value) =>
                                            cubit.isFemaleToggle(value),
                                      ),

                                      SizedBox(height: 16.rH(context)),

                                      //! Baby Carriage
                                      CustomSwitchListTile(
                                        svg: Assets.imagesBabyCarriage,
                                        title:
                                            AppStrings.babyCarriage.tr(context),
                                        value: cubit.hasBabyCarriage,
                                        onChanged: (value) =>
                                            cubit.hasBabyCarriageToggle(value),
                                      ),

                                      SizedBox(height: 16.rH(context)),

                                      //! Luggages
                                      CustomSwitchListTile(
                                        svg: Assets.imagesLuggages,
                                        title: AppStrings.luggages.tr(context),
                                        value: cubit.hasLuggages,
                                        onChanged: (value) =>
                                            cubit.hasLuggagesToggle(value),
                                      ),

                                      AnimatedCrossFade(
                                        firstChild:
                                            SelectLuggagesNumberContainer(
                                          smallValue: cubit.smallLuggaes,
                                          mediumValue: cubit.mediumLuggaes,
                                          largeValue: cubit.largeLuggaes,
                                          increaseOnTap: (index) =>
                                              cubit.changeLuggagesNumber(
                                                  index: index, increase: true),
                                          decreaseOnTap: (index) =>
                                              cubit.changeLuggagesNumber(
                                                  index: index,
                                                  increase: false),
                                        ),
                                        secondChild: Container(),
                                        crossFadeState: cubit.hasLuggages
                                            ? CrossFadeState.showFirst
                                            : CrossFadeState.showSecond,
                                        duration:
                                            const Duration(milliseconds: 200),
                                      ),

                                      SizedBox(height: 16.rH(context)),
                                    ],
                                  ),

                                //! Seats Number
                                if ((cubit.isShareRide ||
                                        cubit.driverOnMyWay) &&
                                    cubit.seats.isNotEmpty &&
                                    cubit.selectedVehicleCategoryId == 2)
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: 16.rH(context)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppStrings.selectSeatsYouWant
                                              .tr(context),
                                          style: Styles.regular14(context)
                                              .copyWith(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.color,
                                          ),
                                        ),
                                        SizedBox(height: 8.rH(context)),
                                        Row(
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    AppStrings.availableSeatsNUM
                                                        .tr(context)
                                                        .replaceAll(
                                                          "NUM",
                                                          "${cubit.seats.length}",
                                                        ),
                                                    style: Styles.bold12primary(
                                                            context)
                                                        .copyWith(
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ),
                                                Image.asset(
                                                  Assets.imagesCarSeats,
                                                  height: 120.rH(context),
                                                  width: 120.rW(context),
                                                  fit: BoxFit.contain,
                                                  color: null,
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: Column(
                                                children: List.generate(
                                                  cubit.seats.length,
                                                  (index) => Padding(
                                                    padding: EdgeInsets.only(
                                                      bottom: 8.rH(context),
                                                    ),
                                                    child: GestureDetector(
                                                      onTap: () => cubit
                                                          .selectSeat(index),
                                                      child: Row(
                                                        children: [
                                                          CustomCheckBox(
                                                            value: cubit
                                                                .selectedSeatsIds
                                                                .contains(cubit
                                                                    .seats[
                                                                        index]
                                                                    .id),
                                                            onTap: () => cubit
                                                                .selectSeat(
                                                                    index),
                                                          ),
                                                          SizedBox(
                                                              width: 8
                                                                  .rW(context)),
                                                          Text(
                                                            "(${index + 1}) ${cubit.seats[index].name ?? "??"}",
                                                            style: Styles
                                                                    .regular14(
                                                                        context)
                                                                .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyLarge
                                                                  ?.color,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                //! Prefernces
                                if (!cubit.isDelivery)
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: 16.rH(context)),
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              const PreferencesAlertDialog(
                                            canEdit: true,
                                            getPreferences: true,
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          CustomSvgPicture(
                                            svg: Assets.imagesPreferences,
                                            height: 24.rH(context),
                                          ),
                                          SizedBox(width: 6.rW(context)),
                                          Text(
                                            AppStrings.preferences.tr(context),
                                            style: Styles.regular14(context)
                                                .copyWith(
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                //! Promo Code
                                if (cubit.details != null)
                                  GestureDetector(
                                    onTap: () {
                                      if (cubit.promoCodeModel == null) {
                                        showModalBottomSheet(
                                          context: context,
                                          showDragHandle: true,
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          builder: (context) =>
                                              const StartRidePromoCodeAlertDialog(),
                                        ).then((value) {
                                          cubit.promoCodeController.text =
                                              (value as PromoCodeModel?)
                                                      ?.name ??
                                                  "";
                                          cubit.applyPromoCode(value);
                                        });
                                      }
                                    },
                                    child: Stack(
                                      children: [
                                        CustomTextField(
                                          enabled: false,
                                          controller: cubit.promoCodeController,
                                          borderColor:
                                              AppColors.grey.withOpacity(.5),
                                          hintText:
                                              AppStrings.promoCode.tr(context),
                                          fillColor: AppColors.transparent,
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 12.rH(context),
                                            horizontal: 16.rW(context),
                                          ),
                                          prefixIcon: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CustomSvgPicture(
                                                svg: Assets.imagesTicket,
                                                height: 22.rH(context),
                                                color:
                                                    cubit.promoCodeModel != null
                                                        ? AppColors.primary
                                                        : AppColors.greyText,
                                              ),
                                            ],
                                          ),
                                        ),
                                        PositionedDirectional(
                                          end: 0,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (cubit.promoCodeModel != null)
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 16.rW(context),
                                                  ),
                                                  child: CustomSvgPicture(
                                                    svg: Assets.imagesDone,
                                                    height: 22.rH(context),
                                                  ),
                                                ),
                                              GestureDetector(
                                                onTap: () {
                                                  if (cubit.promoCodeModel !=
                                                      null) {
                                                    cubit.promoCodeController
                                                        .clear();
                                                    cubit.applyPromoCode(null);
                                                  } else {
                                                    showModalBottomSheet(
                                                      context: context,
                                                      showDragHandle: true,
                                                      backgroundColor: Theme.of(
                                                              context)
                                                          .scaffoldBackgroundColor,
                                                      builder: (context) =>
                                                          const StartRidePromoCodeAlertDialog(),
                                                    ).then((value) {
                                                      cubit.promoCodeController
                                                              .text =
                                                          (value as PromoCodeModel?)
                                                                  ?.name ??
                                                              "";
                                                      cubit.applyPromoCode(
                                                          value);
                                                    });
                                                  }
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 16.rW(context),
                                                    vertical: 12.rH(context),
                                                  ),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: AppColors.primary,
                                                    borderRadius:
                                                        BorderRadiusDirectional
                                                            .only(
                                                      topEnd:
                                                          Radius.circular(8),
                                                      bottomEnd:
                                                          Radius.circular(8),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        cubit.promoCodeModel !=
                                                                null
                                                            ? AppStrings.undo
                                                                .tr(context)
                                                            : AppStrings.apply
                                                                .tr(context),
                                                        style: Styles
                                                                .semibold16Primary(
                                                                    context)
                                                            .copyWith(
                                                          color:
                                                              AppColors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                if (cubit.promoCodeModel != null)
                                  Align(
                                    alignment: AlignmentDirectional.centerStart,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(top: 8.rH(context)),
                                      child: Text(
                                        AppStrings
                                            .promoCodeAppliedYouHaveGotVALUEDiscount
                                            .tr(context)
                                            .replaceAll("VALUE",
                                                "${cubit.promoCodeModel!.percentage?.toString() ?? "0"}%"),
                                        style:
                                            Styles.regular12(context).copyWith(
                                          color: AppColors.green,
                                        ),
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ),

                                SizedBox(height: 16.rH(context)),

                                //! Confirm Button
                                CustomButton(
                                  enabled: cubit.startLocation != null &&
                                      cubit.endLocation != null &&
                                      (cubit.selectedVehicleCategoryId !=
                                              null ||
                                          cubit.deliveryDetailsModel
                                                  ?.vehicleCategoryId !=
                                              null),
                                  onPressed: () {
                                    cubit.details != null
                                        ? navigate(
                                            context,
                                            const PaymentMethodsView(
                                              returnPayment: true,
                                              findDriver: true,
                                            ),
                                            then: (value) {
                                              if (value != null &&
                                                  value is List) {
                                                cubit.mainPaymentMethodId =
                                                    value[0];
                                                cubit.subPaymentMethodId =
                                                    value[1];
                                                if (cubit.isDelivery) {
                                                  cubit.requestDeliveryTrip();
                                                } else if (cubit.isShareRide) {
                                                  navigate(
                                                    context,
                                                    AvailableShareTripsView(
                                                      model:
                                                          RiderShareTripDataModel(
                                                        seatsCount: cubit
                                                            .selectedSeatsIds
                                                            .length,
                                                        seatsIds: cubit
                                                            .selectedSeatsIds,
                                                        mainPaymentMethodId:
                                                            cubit.mainPaymentMethodId ??
                                                                0,
                                                        subPaymentMethodId: cubit
                                                            .subPaymentMethodId,
                                                        pickupAddress: cubit
                                                                .startLocation
                                                                ?.address ??
                                                            "",
                                                        pickupLatitude: cubit
                                                                .startLocation
                                                                ?.lat ??
                                                            0,
                                                        pickupLongitude: cubit
                                                                .startLocation
                                                                ?.lon ??
                                                            0,
                                                        dropoffAddress: cubit
                                                                .endLocation
                                                                ?.address ??
                                                            "",
                                                        dropoffLatitude: cubit
                                                                .endLocation
                                                                ?.lat ??
                                                            0,
                                                        dropoffLongitude: cubit
                                                                .endLocation
                                                                ?.lon ??
                                                            0,
                                                        vehicleCategoryId: cubit
                                                                .selectedVehicleCategoryId ??
                                                            2,
                                                        date: DateFormat(
                                                                "yyyy-MM-dd")
                                                            .format(
                                                                DateTime.now()),
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  cubit.requestClassicTrip();
                                                }
                                              }
                                            },
                                          )
                                        : cubit.calculateEstimated();
                                  },
                                  title: cubit.details != null
                                      ? AppStrings.choosePayment.tr(context)
                                      : AppStrings.confirm.tr(context),
                                ),
                                SizedBox(height: 25.rH(context)),
                              ],
                            ),
                          ),
                        ),
                ),

                SizedBox(height: 16.rH(context)),
              ],
            ),
          ),
        );
      },
    );
  }
}
