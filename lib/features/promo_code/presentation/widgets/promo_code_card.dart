import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_dashed_container.dart';
import '../../data/models/promo_code_model.dart';

class PromoCodeCard extends StatelessWidget {
  const PromoCodeCard({
    super.key,
    required this.model,
  });

  final PromoCodeModel model;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //! Content
        CustomDashedContainer(
          color: AppColors.primary,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: 16.rH(context),
              horizontal: 48.rW(context),
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //! Title
                if (model.title != null)
                  Text(
                    model.title!,
                    style: Styles.medium16Primary(context).copyWith(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),

                if (model.title == null)
                  RichText(
                    maxLines: 2,
                    text: TextSpan(
                      style: Styles.medium16Primary(context).copyWith(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                      children: [
                        TextSpan(
                          text: AppStrings.enjoyNumOffYourNextRide
                              .tr(context)
                              .split("NUM")
                              .first,
                        ),
                        TextSpan(
                          text: "${model.percentage?.toString() ?? "0"}%",
                          style: Styles.medium16Primary(context).copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        TextSpan(
                          text: AppStrings.enjoyNumOffYourNextRide
                              .tr(context)
                              .split("NUM")
                              .last,
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: 8.rH(context)),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (model.description != null)
                      Expanded(
                        child: Padding(
                          padding:
                              EdgeInsetsDirectional.only(end: 15.rW(context)),
                          child: Text(
                            model.description!,
                            style: Styles.regular14(context).copyWith(
                              color: AppColors.greyText,
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ),
                    SizedBox(width: 15.rW(context)),
                    //! Code
                    if (model.name != null)
                      Container(
                        height: 33.rH(context),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.rW(context),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            model.name!,
                            style: Styles.semibold16Primary(context).copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                //! Expire At
                if (model.endDate != null)
                  Padding(
                    padding: EdgeInsets.only(top: 8.rH(context)),
                    child: Text(
                      "${AppStrings.expireAt.tr(context)}: ${model.endDate}",
                      style: Styles.regular12(context).copyWith(
                        color: AppColors.greyText,
                      ),
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
              color: AppColors.primary,
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
              color: AppColors.primary,
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
