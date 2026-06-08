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
          children: [
            _buildStepCircle(context, step: 1, isActive: cubit.pageIndex >= 0),
            _buildLine(context, isActive: cubit.pageIndex >= 1),
            _buildStepCircle(context, step: 2, isActive: cubit.pageIndex >= 1),
            _buildLine(context, isActive: cubit.pageIndex >= 2),
            _buildStepCircle(context, step: 3, isActive: cubit.pageIndex >= 2),
          ],
        );
      },
    );
  }

  Widget _buildStepCircle(BuildContext context, {required int step, required bool isActive}) {
    return Container(
      width: 44.rH(context),
      height: 44.rH(context),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.grey.shade400,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        step.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.rH(context),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLine(BuildContext context, {required bool isActive}) {
    return Container(
      width: 30.rW(context),
      height: 3.rH(context),
      color: isActive ? AppColors.primary : Colors.grey.shade400,
    );
  }
}
