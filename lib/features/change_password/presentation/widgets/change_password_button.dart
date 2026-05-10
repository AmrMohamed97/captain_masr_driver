import '../../../../core/imports/imports.dart';

class ChangePasswordButton extends StatelessWidget {
  const ChangePasswordButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
      builder: (context, state) {
        final cubit = context.read<ChangePasswordCubit>();
        return CustomButton(
          onPressed: () {
            if (cubit.formKey.currentState!.validate()) {
              FocusScope.of(context).unfocus();
              cubit.changePassword();
            }
          },
          title: AppStrings.saveChanges.tr(context),
        );
      },
    );
  }
}
