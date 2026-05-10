import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_shimmer.dart';

class StartRidePromoCodeAlertDialog extends StatefulWidget {
  const StartRidePromoCodeAlertDialog({
    super.key,
    this.tripTypeId,
  });

  final int? tripTypeId;

  @override
  State<StartRidePromoCodeAlertDialog> createState() =>
      _StartRidePromoCodeAlertDialogState();
}

class _StartRidePromoCodeAlertDialogState
    extends State<StartRidePromoCodeAlertDialog> {
  TextEditingController promoCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PromoCodeCubit()
        ..getPromoCodes(
          tripTypeId: widget.tripTypeId,
        ),
      child: BlocBuilder<PromoCodeCubit, PromoCodeState>(
        builder: (context, state) {
          final cubit = context.read<PromoCodeCubit>();
          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //! Title
                Text(
                  AppStrings.applyPromoCode.tr(context),
                  style: Styles.semibold21Primary(context),
                ),
                SizedBox(height: 18.rH(context)),
                //! Promo Codes
                if (state is PromoCodesLoadingState || cubit.promoCodes.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: state is PromoCodesLoadingState
                          ? 6
                          : cubit.promoCodes.length,
                      itemBuilder: (context, index) {
                        //! Loading Card
                        if (state is PromoCodesLoadingState) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: 8.rH(context),
                            ),
                            child: CustomShimmer(
                              w: double.infinity,
                              h: 48.rH(context),
                              borderRadius: 8,
                            ),
                          );
                        }

                        //! Promo Code Card
                        return GestureDetector(
                          onTap: () {
                            Navigator.pop(context, cubit.promoCodes[index]);
                          },
                          child: Container(
                            width: double.infinity,
                            height: 48.rH(context),
                            margin: EdgeInsets.only(bottom: 8.rH(context)),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.grey.withOpacity(.5),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.rW(context)),
                                    child: Text(
                                      "${cubit.promoCodes[index].name ?? ""}  ( - ${cubit.promoCodes[index].percentage ?? 0}% )",
                                      style: Styles.medium16Primary(context),
                                    ),
                                  ),
                                ),
                                Container(
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
                                        AppStrings.apply.tr(context),
                                        style: Styles.semibold16Primary(context)
                                            .copyWith(
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                //! No Promo Codes
                if (state is! PromoCodesLoadingState && cubit.promoCodes.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.rH(context)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomSvgPicture(
                          svg: Assets.imagesEmptyBox,
                          height: 120.rH(context),
                        ),
                        SizedBox(height: 16.rH(context)),
                        Text(
                          AppStrings.noPromoCodes.tr(context),
                          style: Styles.medium16Primary(context),
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: 18.rH(context)),
              ],
            ),
          );
        },
      ),
    );
  }
}
