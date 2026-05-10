import '../../../../core/imports/imports.dart';
import '../views/choose_role_view.dart';

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final cubit = context.read<OnboardingCubit>();
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
          child: Row(
            children: [
              Image.asset(
                Assets.imagesLogo,
                color: AppColors.primary,
                height: 46.rH(context),
              ),
              const Spacer(),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: cubit.pageIndex != 2 ? 1 : 0,
                child: GestureDetector(
                  onTap: cubit.pageIndex != 2
                      ? () {
                          sl<Cache>()
                              .setData(AppConstants.onBoardingVisited, true);
                          navigateReplacement(context, const ChooseRoleView());
                        }
                      : null,
                  child: Text(
                    AppStrings.skip,
                    style: Styles.medium16Primary(context),
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
