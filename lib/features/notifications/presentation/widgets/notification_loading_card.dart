import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_shimmer.dart';

class NotificationLoadingCard extends StatelessWidget {
  const NotificationLoadingCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 12.rH(context),
        horizontal: 16.rW(context),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.greyText.withOpacity(.20),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomShimmer(
            h: 32.rH(context),
            w: 32.rW(context),
            borderRadius: 50,
          ),

          SizedBox(width: 12.rH(context)),

          //! Title & Message
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomShimmer(
                  h: 14.rH(context),
                  w: double.infinity,
                  borderRadius: 8,
                ),
                SizedBox(height: 8.rH(context)),
                Padding(
                  padding: EdgeInsetsDirectional.only(end: 80.rW(context)),
                  child: CustomShimmer(
                    h: 14.rH(context),
                    w: double.infinity,
                    borderRadius: 8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
