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
        return Column(
          children: [
            //! Header
            AuthHeaderRed(
              showBackButton: cubit.pageIndex != 0,
              onBackTap: () {
                if (cubit.pageIndex == 0) {
                  Navigator.pop(context);
                } else {
                  cubit.changePage(cubit.pageIndex - 1);
                }
              },
            ),

            //! White Container
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
                  child: Column(
                    children: [
                      SizedBox(height: 24.rH(context)),
                      //! Title
                      Center(
                        child: Text(
                          cubit.pageIndex == 0
                              ? context.read<GlobalCubit>().isRider
                                  ? AppStrings.createAccount.tr(context)
                                  : context.read<GlobalCubit>().language == 'ar'
                                      ? 'البيانات الشخصية'
                                      : 'Personal Data'
                              : cubit.pageIndex == 1
                                  ? context.read<GlobalCubit>().language == 'ar'
                                      ? 'المستندات الشخصية'
                                      : 'Personal Documents'
                                  : context.read<GlobalCubit>().language == 'ar'
                                      ? 'بيانات المركبة'
                                      : 'Vehicle Data',
                          style: Styles.bold20(context).copyWith(
                            color: const Color(0xff800005),
                            fontSize: 22,
                          ),
                        ),
                      ),
                      SizedBox(height: 24.rH(context)),

                      //! Page Indicator
                      if (context.read<GlobalCubit>().isDriver)
                        const RegisterPageIndicators(),
                      if (context.read<GlobalCubit>().isDriver)
                        SizedBox(height: 32.rH(context)),

                      //! Page View
                      Expanded(
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
