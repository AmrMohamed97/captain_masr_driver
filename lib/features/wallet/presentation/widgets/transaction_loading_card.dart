import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_shimmer.dart';

class TransactionLoadingCard extends StatelessWidget {
  const TransactionLoadingCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 77.rH(context),
        margin: EdgeInsets.only(
          bottom: 14.rH(context),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 12.rH(context),
          horizontal: 8.rW(context),
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 2.rH(context)),
              color: AppColors.black.withOpacity(.05),
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          children: [
            //! User Image
            CustomShimmer(
              w: 50.rH(context),
              h: 50.rH(context),
              borderRadius: 50,
            ),

            SizedBox(width: 13.rW(context)),

            //! Date & Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //! Date
                  CustomShimmer(
                    h: 14.rH(context),
                    w: 150.rW(context),
                  ),
                  SizedBox(height: 8.rH(context)),
                  //! Name
                  CustomShimmer(
                    h: 14.rH(context),
                    w: 100.rW(context),
                  ),
                ],
              ),
            ),

            SizedBox(width: 8.rW(context)),

            //! Transfer Amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 22.rH(context)),
                //! Amount
                CustomShimmer(
                  h: 14.rH(context),
                  w: 80.rW(context),
                ),
              ],
            ),
          ],
        ));
  }
}
