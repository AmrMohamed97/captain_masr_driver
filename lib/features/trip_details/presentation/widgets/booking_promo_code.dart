import '../../../../core/imports/imports.dart';

class BookingPromoCode extends StatelessWidget {
  const BookingPromoCode({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripDetailsCubit, TripDetailsState>(
      builder: (context, state) {
        final cubit = context.read<TripDetailsCubit>();
        return Column(
          children: [
            //! Promo Code
            CustomTextField(
              controller: cubit.promoCodeController,
              borderColor: AppColors.grey.withOpacity(.5),
              hintText: AppStrings.promoCode.tr(context),
              fillColor: AppColors.transparent,
              contentPadding: EdgeInsets.symmetric(
                vertical: 12.rH(context),
                horizontal: 16.rW(context),
              ),
              prefixIcon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomSvgPicture(
                    svg: Assets.imagesTicket,
                    height: 22.rH(context),
                    color: cubit.promoCodeApplied
                        ? AppColors.primary
                        : AppColors.greyText,
                  ),
                ],
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (cubit.promoCodeApplied)
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
                      if (cubit.promoCodeApplied) {
                        cubit.promoCodeController.clear();
                      }
                      cubit.checkPromoCode();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.rW(context),
                        vertical: 12.rH(context),
                      ),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadiusDirectional.only(
                          topEnd: Radius.circular(8),
                          bottomEnd: Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            cubit.promoCodeApplied
                                ? AppStrings.undo.tr(context)
                                : AppStrings.apply.tr(context),
                            style: Styles.semibold16Primary(context).copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (cubit.promoCodeApplied)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: EdgeInsets.only(top: 12.rH(context)),
                  child: Text(
                    AppStrings.promoCodeAppliedYouHaveGotVALUEDiscount
                        .tr(context)
                        .replaceAll("VALUE", "10"),
                    style: Styles.regular12(context).copyWith(
                      color: AppColors.green,
                    ),
                    overflow: TextOverflow.clip,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
