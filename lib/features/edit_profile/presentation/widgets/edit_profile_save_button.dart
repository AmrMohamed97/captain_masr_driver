import '../../../../core/imports/imports.dart';

class EditProfileSaveButton extends StatelessWidget {
  const EditProfileSaveButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      builder: (context, state) {
        final cubit = context.read<EditProfileCubit>();
        return CustomButton(
          enabled: cubit.image != null ||
              context.read<GlobalCubit>().userModel?.username !=
                  cubit.nameController.text ||
              context.read<GlobalCubit>().userModel?.gender !=
                  cubit.genderValue,
          onPressed: () {
            FocusScope.of(context).unfocus();
            context.read<EditProfileCubit>().userEditProfile();
          },
          title: AppStrings.saveChanges.tr(context),
        );
      },
    );
  }
}
