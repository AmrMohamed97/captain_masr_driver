import '../../../../core/imports/imports.dart';

class DriverVerifyAccountBody extends StatelessWidget {
  const DriverVerifyAccountBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.rW(context)),
      child: Column(
        children: [
          //! Header
          const CustomAppBar(),

          SizedBox(height: 76.rH(context)),

          //! Title
          Text(
            AppStrings.verifyYourAccount.tr(context),
            style: Styles.bold24primary(context),
          ),

          SizedBox(height: 76.rH(context)),

          //! Image
          CustomSvgPicture(
            svg: Assets.imagesDriverVerifyAccount,
            height: 240.rH(context),
          ),

          SizedBox(height: 60.rH(context)),

          //! Subtitle
          Text(
            AppStrings
                .yourInformationIsUnderReviewYoullBeNotifiedOnceYourAccountIsApproved
                .tr(context),
            style: Styles.medium14Primary(context).copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 73.rH(context)),

          //! Loading
          const CustomLoadingIndicator(),
        ],
      ),
    );
  }
}
