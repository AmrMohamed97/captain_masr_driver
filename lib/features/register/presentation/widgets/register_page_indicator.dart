import '../../../../core/imports/imports.dart';
import '../cubit/register_cubit.dart';

class RegisterPageIndicators extends StatelessWidget {
  const RegisterPageIndicators({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        final cubit = context.read<RegisterCubit>();
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 45.rW(context),
                height: 6.rH(context),
                margin: EdgeInsets.symmetric(horizontal: 4.rW(context)),
                decoration: BoxDecoration(
                  color: cubit.pageIndex >= index
                      ? AppColors.primary
                      : AppColors.grey2,
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
