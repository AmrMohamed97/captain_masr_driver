import '../../../../core/imports/imports.dart';
import '../../data/models/onboarding_model.dart';

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final cubit = context.read<OnboardingCubit>();
        return Column(
          children: [
            //! Image
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Image.asset(
                OnboardingModel.onboardingList[cubit.pageIndex].image,
                key: ValueKey(cubit.pageIndex),
                width: double.infinity,
              ),
            ),

            SizedBox(height: 32.rH(context)),

            //! Title
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Text(
                OnboardingModel.onboardingList[cubit.pageIndex].title
                    .tr(context),
                style: Styles.bold27primary(context),
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 16.rH(context)),

            //! Subtitle
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.rW(context),
                ),
                child: Text(
                  OnboardingModel.onboardingList[cubit.pageIndex].subtitle
                      .tr(context),
                  style: Styles.medium14(context).copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
