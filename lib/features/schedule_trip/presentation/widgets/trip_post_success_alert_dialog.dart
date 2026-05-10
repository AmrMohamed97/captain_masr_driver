import '../../../../core/imports/imports.dart';

class TripPostSuccessAlertDialg extends StatefulWidget {
  const TripPostSuccessAlertDialg({
    super.key,
  });

  @override
  State<TripPostSuccessAlertDialg> createState() =>
      _TripPostSuccessAlertDialgState();
}

class _TripPostSuccessAlertDialgState extends State<TripPostSuccessAlertDialg> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      elevation: 0,
      content: Container(
        width: 344.rW(context),
        padding: EdgeInsets.symmetric(
          vertical: 24.rH(context),
          horizontal: 26.rW(context),
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //! Title
            Text(
              AppStrings.tripPost.tr(context),
              style: Styles.semibold21Primary(context),
            ),
            SizedBox(height: 16.rH(context)),
            //! Icon
            CustomSvgPicture(
              svg: Assets.imagesDone,
              height: 64.rH(context),
            ),
            SizedBox(height: 16.rH(context)),
            //! Subtitle
            Text(
              AppStrings.yourTripHasBeenPosted.tr(context),
              style: Styles.regular14(context).copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.rH(context)),
            Text(
              AppStrings.passengersLookingForSimilarTripsWillSeeIt.tr(context),
              style: Styles.medium14(context).copyWith(
                color: AppColors.greyText,
              ),
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
