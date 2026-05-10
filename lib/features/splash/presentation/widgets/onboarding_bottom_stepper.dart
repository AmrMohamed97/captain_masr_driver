import '../../../../core/imports/imports.dart';
import '../views/choose_role_view.dart';

class OnboardingBottomStepper extends StatelessWidget {
  const OnboardingBottomStepper({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final cubit = context.read<OnboardingCubit>();
        return SizedBox(
          width: double.infinity,
          height: 120.rH(context),
          child: Stack(
            children: [
              //! Background
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  height: 60.rH(context),
                  color: AppColors.primary,
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    AnimatedPositionedDirectional(
                      duration: const Duration(milliseconds: 300),
                      start: cubit.pageIndex == 0
                          ? -155.rW(context)
                          : cubit.pageIndex == 1
                              ? -10.rW(context)
                              : 130.rW(context),
                      child: Image.asset(
                        Assets.imagesOnboardingCurveShape,
                        height: 110.rH(context),
                        fit: BoxFit.fitHeight,
                        width: 400.rW(context),
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                alignment: cubit.pageIndex == 0
                    ? AlignmentDirectional.centerStart
                    : cubit.pageIndex == 1
                        ? AlignmentDirectional.center
                        : AlignmentDirectional.centerEnd,
                child: GestureDetector(
                  onTap: () {
                    if (cubit.pageIndex != 2) {
                      cubit.changePageIndex();
                    } else {
                      sl<Cache>().setData(AppConstants.onBoardingVisited, true);
                      navigateReplacement(context, const ChooseRoleView());
                    }
                  },
                  child: Container(
                    width: 65.rH(context),
                    height: 65.rH(context),
                    margin: EdgeInsets.symmetric(
                      vertical: 12.rH(context),
                      horizontal: 16.rW(context),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 14,
                          spreadRadius: 9,
                          color: AppColors.white.withOpacity(.44),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.white,
                      ),
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
