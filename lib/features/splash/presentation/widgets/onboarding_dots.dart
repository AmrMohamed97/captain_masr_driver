import '../../../../core/imports/imports.dart';

class OnboardingDots extends StatelessWidget {
  const OnboardingDots({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final cubit = context.read<OnboardingCubit>();
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width:
                    index == cubit.pageIndex ? 25.rH(context) : 6.rH(context),
                height: 6.rH(context),
                margin: EdgeInsets.symmetric(horizontal: 1.rW(context)),
                decoration: BoxDecoration(
                  color: index == cubit.pageIndex
                      ? AppColors.primary
                      : AppColors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
