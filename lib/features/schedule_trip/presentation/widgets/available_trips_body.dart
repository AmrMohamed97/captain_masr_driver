import '../../../../core/imports/imports.dart';

class AvailableTripsBody extends StatelessWidget {
  const AvailableTripsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
      child: Column(
        children: [
          //! Header
          CustomAppBar(
            title: AppStrings.availableTrips.tr(context),
          ),

          SizedBox(height: 26.rH(context)),

          //! Available Trips
          // Expanded(
          //   child: ListView.separated(
          //     padding: EdgeInsets.only(bottom: 16.rH(context)),
          //     itemCount: 3,
          //     separatorBuilder: (context, index) {
          //       return SizedBox(height: 4.rH(context));
          //     },
          //     itemBuilder: (context, index) {
          //       final TripModel model = TripModel(
          //         date: "Tue, 6 April | 7:30 PM",
          //         driverImage: Assets.imagesTestProfile2,
          //         driverName: "Ramy Karam",
          //         rating: 3.8,
          //         cost: 100,
          //         carImage: Assets.imagesTestCar1,
          //         carModel: "Nissan Sunny",
          //         carNumber: "Blue - 2315 م ى رو",
          //         startPoint: "Elnasr street, Elmaadi, Cairo",
          //         endPoint: "Elbatrawy street,  Nasr City , Cairo",
          //         seats: 2,
          //       );
          //       return TripCard(
          //         model: model,
          //         tripTitle: AppStrings.scheduleTrip.tr(context),
          //         bottomWidget: Padding(
          //           padding: EdgeInsets.only(top: 16.rH(context)),
          //           child: CustomButton(
          //             onPressed: () {
          //               navigate(
          //                 context,
          //                 const TripDetailsView(
          //                   isScheduled: true,
          //                 ),
          //               );
          //             },
          //             title: AppStrings.viewDetails.tr(context),
          //             traillingIcon: Icon(
          //               Icons.arrow_forward_ios_rounded,
          //               color: AppColors.white,
          //               size: 16.rH(context),
          //             ),
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
