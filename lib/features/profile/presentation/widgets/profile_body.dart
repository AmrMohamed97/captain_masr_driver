import '../../../../core/imports/imports.dart';
import '../../../edit_profile/presentation/views/edit_profile_view.dart';
import 'profile_list_tiles.dart';
import 'profile_user_details.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.rW(context)),
      child: Column(
        children: [
          //! Header
          CustomAppBar(
            title: AppStrings.profile.tr(context),
            popOnTap: () {
              context.read<GlobalCubit>().navBarController.jumpToTab(0);
            },
          ),

          SizedBox(height: 26.rH(context)),

          //! Profile Details
          const ProfileUserDetails(),

          //! Edit Profile
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButton(
                onPressed: () {
                  navBarNavigate(
                    context: context,
                    widget: const EditProfileView(),
                  );
                },
                title: AppStrings.editProfile.tr(context),
                icon: const CustomSvgPicture(
                  svg: Assets.imagesEdit,
                ),
                widgth: null,
              ),
            ],
          ),

          SizedBox(height: 16.rH(context)),
          //! List Tiles
          const ProfileListTiles(),
        ],
      ),
    );
  }
}
