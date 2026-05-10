import '../../../../core/imports/imports.dart';

class RateTipSection extends StatelessWidget {
  const RateTipSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RatingCubit, RatingState>(
      builder: (context, state) {
        final cubit = context.read<RatingCubit>();
        return Column(
          children: [
            GestureDetector(
              onTap: () => cubit.tipToggle(),
              child: Row(
                children: [
                  Icon(
                    cubit.tipValue
                        ? Icons.check_box_outlined
                        : Icons.check_box_outline_blank_rounded,
                    color:
                        cubit.tipValue ? AppColors.primary : AppColors.greyText,
                  ),
                  SizedBox(width: 8.rW(context)),
                  Expanded(
                    child: Text(
                      AppStrings.wouldYouLikeToTipYourDriver.tr(context),
                      style: Styles.medium16Primary(context).copyWith(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.rH(context)),
            AnimatedCrossFade(
              firstChild: AuthTextField(
                controller: cubit.tipsController,
                keyboardType: TextInputType.number,
                title: AppStrings.tips.tr(context),
                hintText: AppStrings.tips.tr(context),
                suffixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.egp.tr(context),
                      style: Styles.medium14Primary(context),
                    ),
                  ],
                ),
              ),
              secondChild: Container(),
              crossFadeState: cubit.tipValue
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 300),
            ),
          ],
        );
      },
    );
  }
}
