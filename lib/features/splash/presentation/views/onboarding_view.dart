import '../../../../core/imports/imports.dart';
import '../widgets/onboarding_bottom_stepper.dart';
import '../widgets/onboarding_content.dart';
import '../widgets/onboarding_dots.dart';
import '../widgets/onboarding_header.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 49.rH(context)),

            //! Header
            const OnboardingHeader(),

            SizedBox(height: 110.rH(context)),

            //! Content
            const OnboardingContent(),

            SizedBox(height: 16.rH(context)),

            //! Dots
            const OnboardingDots(),

            const Spacer(),

            //! Bottom Stepper
            const OnboardingBottomStepper(),
          ],
        ),
      ),
    );
  }
}
