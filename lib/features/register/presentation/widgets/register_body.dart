import '../../../../core/imports/imports.dart';
import '../cubit/register_cubit.dart';
import 'register_first_form.dart';
import 'register_page_indicator.dart';
import 'register_second_form.dart';
import 'register_third_form.dart';

class RegisterBody extends StatelessWidget {
  const RegisterBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        final cubit = context.read<RegisterCubit>();
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //! Header
              if (cubit.pageIndex == 0)
                AuthHeader(
                  title: AppStrings.createAccount.tr(context),
                  subtitle: context.read<GlobalCubit>().isRider
                      ? AppStrings.createYourAccountToRideTogether.tr(context)
                      : AppStrings.allYouNeedUIsVehicleAndDestination
                          .tr(context),
                  heightBetweenPopAndTitle: 0,
                ),
              if (cubit.pageIndex != 0)
                CustomAppBar(
                  title: cubit.pageIndex == 1
                      ? AppStrings.vehicleDetails.tr(context)
                      : AppStrings.licenseAndDocument.tr(context),
                  popOnTap: () {
                    if (cubit.pageIndex == 0) {
                      Navigator.pop(context);
                    } else {
                      cubit.changePage(cubit.pageIndex - 1);
                    }
                  },
                ),
              SizedBox(
                  height:
                      cubit.pageIndex == 0 ? 42.rH(context) : 77.rH(context)),
              //! Page Indicator
              if (context.read<GlobalCubit>().isDriver)
                const RegisterPageIndicators(),
              if (context.read<GlobalCubit>().isDriver)
                SizedBox(height: 32.rH(context)),
              //! Page View
              BlocBuilder<RegisterCubit, RegisterState>(
                builder: (context, state) {
                  final cubit = context.read<RegisterCubit>();
                  return Expanded(
                    child: PageView.builder(
                      controller: cubit.pageController,
                      itemCount: 3,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        switch (cubit.pageIndex) {
                          case 0:
                            return const RegisterFirstForm();
                          case 1:
                            return const RegisterSecondForm();
                          case 2:
                            return const RegisterThirdForm();
                          default:
                            return Container();
                        }
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
