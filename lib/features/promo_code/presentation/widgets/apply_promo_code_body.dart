import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_dashed_container.dart';

class ApplyPromoCodeBody extends StatelessWidget {
  const ApplyPromoCodeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //! Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
          child: CustomAppBar(
            title: AppStrings.promoCode.tr(context),
          ),
        ),

        SizedBox(height: 11.rH(context)),

        //! Body
        Expanded(
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: [
                //! Backgrounds
                PositionedDirectional(
                  start: -250.rW(context),
                  child: Container(
                    width: 524.rW(context),
                    height: 524.rH(context),
                    decoration: BoxDecoration(
                      color: context.read<GlobalCubit>().isDarkMode
                          ? AppColors.grey.withOpacity(.04)
                          : const Color(0xff077FC3).withOpacity(.05),
                      borderRadius: BorderRadius.circular(500),
                    ),
                  ),
                ),
                PositionedDirectional(
                  top: 93.rH(context),
                  start: -100.rW(context),
                  child: Container(
                    width: 658.rW(context),
                    height: 633.rH(context),
                    decoration: BoxDecoration(
                      color: context.read<GlobalCubit>().isDarkMode
                          ? AppColors.grey.withOpacity(.04)
                          : const Color(0xff0E3F6D).withOpacity(.07),
                      borderRadius: BorderRadius.circular(500),
                    ),
                  ),
                ),
                //! Content
                Positioned(
                  top: 53.rH(context),
                  left: 16.rW(context),
                  right: 16.rW(context),
                  child: Column(
                    children: [
                      //! Title
                      Text(
                        AppStrings.yourDiscountIsReady.tr(context),
                        style: Styles.bold22white(context).copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 7.rH(context)),
                      //! Image
                      CustomSvgPicture(
                        svg: Assets.imagesCongratulationSvg,
                        height: 294.rH(context),
                      ),
                      SizedBox(height: 17.rH(context)),
                      //! Subtitle
                      Text(
                        AppStrings.discountWillBeAppliedAutomaticallyAtCheckout
                            .tr(context),
                        style: Styles.medium16Primary(context),
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 39.rH(context)),
                      //! Promo Code
                      CustomDashedContainer(
                        radius: 10,
                        color: AppColors.primary,
                        child: Container(
                          width: double.infinity,
                          height: 54.rH(context),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.rW(context),
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              CustomSvgPicture(
                                svg: Assets.imagesTicket,
                                height: 22.rH(context),
                              ),
                              SizedBox(width: 10.rW(context)),
                              Text(
                                "Maak59",
                                style: Styles.bold14primary(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.rH(context)),
                      //! Hint
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomSvgPicture(
                            svg: Assets.imagesDone,
                            height: 20.rH(context),
                          ),
                          SizedBox(width: 10.rW(context)),
                          Expanded(
                            child: Text(
                              AppStrings.promoCodeAppliedYouHaveGotVALUEDiscount
                                  .tr(context)
                                  .replaceAll("VALUE", "10%"),
                              style: Styles.medium14(context).copyWith(
                                color: AppColors.green,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.rH(context)),
                      //! Confirm Button
                      CustomButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        title: AppStrings.confirm.tr(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
