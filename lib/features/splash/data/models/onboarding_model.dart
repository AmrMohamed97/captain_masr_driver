import '../../../../core/imports/imports.dart';

class OnboardingModel {
  final String title, subtitle, image;

  OnboardingModel({
    required this.title,
    required this.subtitle,
    required this.image,
  });

  static List<OnboardingModel> onboardingList = [
    OnboardingModel(
      title: AppStrings.onboardingTitle1,
      subtitle: AppStrings.onboardingSubtitle1,
      image: Assets.imagesOnboarding1,
    ),
    OnboardingModel(
      title: AppStrings.onboardingTitle2,
      subtitle: AppStrings.onboardingSubtitle2,
      image: Assets.imagesOnboarding2,
    ),
    OnboardingModel(
      title: AppStrings.onboardingTitle3,
      subtitle: AppStrings.onboardingSubtitle3,
      image: Assets.imagesOnboarding3,
    ),
  ];
}
