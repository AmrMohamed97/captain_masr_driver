import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_shimmer.dart';
import '../views/payment_methods_view.dart';

class WalletCard extends StatelessWidget {
  const WalletCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, state) {
        final cubit = context.read<WalletCubit>();
        return SizedBox(
          width: double.infinity,
          height: 181.rH(context),
          child: Stack(
            children: [
              //! Background
              BlocBuilder<GlobalCubit, GlobalState>(
                builder: (context, state) {
                  return Transform.flip(
                    flipX: context.read<GlobalCubit>().language == "ar",
                    child: const CustomSvgPicture(
                      svg: Assets.imagesWalletCardBackground,
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                  );
                },
              ),
              //! Payment Methods Button
              Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: GestureDetector(
                  onTap: () {
                    context.read<GlobalCubit>().isRider
                        ? navBarNavigate(
                            context: context,
                            widget: const PaymentMethodsView(),
                          )
                        : null;
                  },
                  child: Container(
                    height: 45.rH(context),
                    width: 162.rW(context),
                    decoration: BoxDecoration(
                      // color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          context.read<GlobalCubit>().isRider
                              ? AppStrings.paymentMethods.tr(context)
                              : AppStrings.withdraw.tr(context),
                          style: Styles.semibold14Primary(context),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: AppColors.primary,
                          size: 16.rH(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //! Content
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.rW(context),
                  vertical: 25.rH(context),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomSvgPicture(
                      svg: Assets.imagesStarCoin,
                      height: 42.rH(context),
                    ),
                    SizedBox(width: 16.rW(context)),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //! Title
                        BlocBuilder<GlobalCubit, GlobalState>(
                          builder: (context, state) {
                            return Text(
                              context
                                      .read<GlobalCubit>()
                                      .userModel
                                      ?.defaultPaymentMethodName ??
                                  AppStrings.cash.tr(context),
                              style: Styles.semibold20Primary(context).copyWith(
                                color: AppColors.white,
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 2.rH(context)),
                        //! Subtitle
                        Text(
                          AppStrings.defaultPaymentMethod.tr(context),
                          style: Styles.regular14(context).copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //! Balance
              Align(
                alignment: AlignmentDirectional.bottomStart,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.rW(context),
                    vertical: 18.rH(context),
                  ),
                  child: SizedBox(
                    width: 135.rW(context),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //! Title
                        Text(
                          AppStrings.balance.tr(context),
                          style: Styles.medium14(context).copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(height: 8.rH(context)),
                        //! Value
                        FittedBox(
                          child: state is WalletLoadingState
                              ? CustomShimmer(
                                  h: 24.rH(context),
                                )
                              : Text(
                                  "${cubit.balance} ${AppStrings.egp.tr(context)}",
                                  style: Styles.bold26white(context),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
