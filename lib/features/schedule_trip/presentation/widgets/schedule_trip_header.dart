import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_tab_bar.dart';

class ScheduleTripHeader extends StatelessWidget {
  const ScheduleTripHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleTripCubit, ScheduleTripState>(
      builder: (context, state) {
        final cubit = context.read<ScheduleTripCubit>();
        return Container(
          width: double.infinity,
          height: 180.rH(context),
          padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(34),
              bottomRight: Radius.circular(34),
            ),
          ),
          child: Column(
            children: [
              CustomAppBar(
                title: AppStrings.scheduled.tr(context),
                isLigth: true,
              ),
              const Spacer(),
              //! Tap Bar
              CustomTapBar(
                taps: [
                  AppStrings.onMyWay.tr(context),
                  AppStrings.school.tr(context),
                ],
                selectedTap: cubit.selectedTabBar,
                onTap: (value) => cubit.scheduleTabBarToggle(value),
                tabWidth: 145.rW(context),
              ),

              SizedBox(height: 18.rH(context)),
            ],
          ),
        );
      },
    );
  }
}
