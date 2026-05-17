import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_shimmer.dart';

class NotificationLoadingCard extends StatelessWidget {
  const NotificationLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 2.rW(context),
        vertical: 2.rH(context),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 14.rW(context),
        vertical: 14.rH(context),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xff1E1E1E)
            : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.greyText.withOpacity(0.15),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circle icon placeholder
          CustomShimmer(
            h: 46.rH(context),
            w: 46.rW(context),
            borderRadius: 50,
          ),

          SizedBox(width: 12.rW(context)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + time row
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: CustomShimmer(
                        h: 14.rH(context),
                        w: double.infinity,
                        borderRadius: 8,
                      ),
                    ),
                    SizedBox(width: 12.rW(context)),
                    Expanded(
                      flex: 1,
                      child: CustomShimmer(
                        h: 11.rH(context),
                        w: double.infinity,
                        borderRadius: 8,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8.rH(context)),

                // Body line 1
                CustomShimmer(
                  h: 12.rH(context),
                  w: double.infinity,
                  borderRadius: 8,
                ),

                SizedBox(height: 6.rH(context)),

                // Body line 2 (shorter)
                Padding(
                  padding: EdgeInsetsDirectional.only(end: 60.rW(context)),
                  child: CustomShimmer(
                    h: 12.rH(context),
                    w: double.infinity,
                    borderRadius: 8,
                  ),
                ),

                SizedBox(height: 10.rH(context)),

                // Badge placeholder
                CustomShimmer(
                  h: 20.rH(context),
                  w: 90.rW(context),
                  borderRadius: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
