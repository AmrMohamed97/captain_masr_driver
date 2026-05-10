import '../../../../core/imports/imports.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingInitial());

  int pageIndex = 0;

  changePageIndex({int? index}) {
    if (index != null) {
      pageIndex = index;
    } else {
      pageIndex++;
    }
    emit(ChangeOnBoardingIndexState());
  }
}
