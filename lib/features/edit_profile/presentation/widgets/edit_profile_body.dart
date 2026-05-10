import '../../../../core/imports/imports.dart';
import 'edit_profile_form.dart';
import 'edit_profile_save_button.dart';

class EditProfileBody extends StatelessWidget {
  const EditProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
      child: Column(
        children: [
          //! Header
          CustomAppBar(
            title: AppStrings.editProfile.tr(context),
          ),

          SizedBox(height: 26.rH(context)),

          //! Form
          const EditProfileForm(),

          SizedBox(height: 16.rH(context)),

          //! Save Changes Button
          const EditProfileSaveButton(),

          SizedBox(height: 32.rH(context)),
        ],
      ),
    );
  }
}
