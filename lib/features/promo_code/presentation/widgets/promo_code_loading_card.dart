import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_dashed_container.dart';
import '../../../../core/widgets/custom_shimmer.dart';

class PromoCodeLoadingCard extends StatelessWidget {
  const PromoCodeLoadingCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //! Content
        CustomDashedContainer(
          color: AppColors.transparent,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: 16.rH(context),
              horizontal: 48.rW(context),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //! Title
                CustomShimmer(
                  h: 14.rH(context),
                  w: double.infinity,
                ),

                SizedBox(height: 8.rH(context)),

                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomShimmer(
                        h: 14.rH(context),
                        w: 150.rW(context),
                      ),
                      SizedBox(height: 8.rH(context)),
                      CustomShimmer(
                        h: 14.rH(context),
                        w: 100.rW(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        //! Substract Parts
        PositionedDirectional(
          start: -25.rH(context),
          top: 0,
          bottom: 0,
          child: Center(
            child: CustomDashedContainer(
              color: AppColors.transparent,
              radius: 40,
              child: Container(
                width: 40.rH(context),
                height: 40.rH(context),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
        ),
        PositionedDirectional(
          end: -25.rH(context),
          top: 0,
          bottom: 0,
          child: Center(
            child: CustomDashedContainer(
              color: AppColors.transparent,
              radius: 40,
              child: Container(
                width: 40.rH(context),
                height: 40.rH(context),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
