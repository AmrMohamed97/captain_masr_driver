import 'package:flutter/cupertino.dart';
// import 'package:flutter_svg/svg.dart';

import '../../../../core/imports/imports.dart';
import '../../../become_rider_or_driver/presentation/views/become_rider_or_driver_view.dart';
import '../../../learning/presentation/helper_page.dart';
import '../../../learning/presentation/learning_page.dart';
import '../../../preferences/presentation/views/preferences_view.dart';
import '../../../promo_code/presentation/views/promo_code_view.dart';
import '../../../saved_places/presentation/views/saved_places_view.dart';
import 'logout_alert_dialog.dart';
import 'profile_list_tile.dart';

class ProfileListTiles extends StatelessWidget {
  const ProfileListTiles({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalCubit, GlobalState>(
      builder: (context, state) {
        return Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              //! Driver Mode
              ProfileListTile(
                svg: Assets.imagesDriverMode,
                title: AppStrings.driverMode.tr(context),
                onTap: () {},
                trailingWidget: CupertinoSwitch(
                  value: false,
                  onChanged: (onChanged) {
                    navBarNavigate(
                      context: context,
                      widget: const BecomeRiderOrDriverView(),
                    );
                  },
                ),
              ),
              //! Preferences
              ProfileListTile(
                svg: Assets.imagesPreferences,
                title: AppStrings.preferences.tr(context),
                onTap: () {
                  navBarNavigate(
                    context: context,
                    widget: const PreferencesView(
                      isEdit: true,
                    ),
                  );
                },
              ),
              //! Saved Places
              ProfileListTile(
                svg: Assets.imagesSavedPlaces,
                title: AppStrings.savedPlaces.tr(context),
                onTap: () {
                  navBarNavigate(
                    context: context,
                    widget: const SavedPlacesView(),
                  );
                },
              ),
              //! Promo Code
              ProfileListTile(
                svg: Assets.imagesPromoCode,
                title: AppStrings.promoCode.tr(context),
                onTap: () {
                  navBarNavigate(
                    context: context,
                    widget: const PromoCodeView(),
                  );
                },
              ),
              //! Arabic
              ProfileListTile(
                svg: Assets.imagesLanguage,
                title: AppStrings.arabic.tr(context),
                onTap: () {},
                trailingWidget: CustomSwitch(
                  value: context.read<GlobalCubit>().language == "ar",
                  onChanged: (onChanged) {
                    context.read<GlobalCubit>().languageToggle();
                  },
                ),
              ),
              //! Dark Mode
              ProfileListTile(
                svg: Assets.imagesDarkModeNightMoonSvgrepoCom,
                title: AppStrings.darkMode.tr(context),
                onTap: () {},
                trailingWidget: CustomSwitch(
                  value: context.read<GlobalCubit>().isDarkMode,
                  onChanged: (onChanged) {
                    context.read<GlobalCubit>().darkModeToggle();
                  },
                ),
              ),

              //! Help
              // Row(
              //   children: [
              //     SvgPicture.asset(
              //       Assets.imagesHelp,
              //     ),
              //     SizedBox(width: 4.rW(context)),
              //     Text(
              //       AppStrings.help.tr(context),
              //       style: Styles.medium12(context).copyWith(
              //         color: AppColors.greyText,
              //       ),
              //     ),
              //   ],
              // ),
              ProfileListTile(
                svg: Assets.imagesHelp,
                title: AppStrings.help.tr(context),
                onTap: () {
                  navBarNavigate(
                    context: context,
                    widget: const HelperPage(),
                  );
                },
              ),
              // SizedBox(height: 24.rH(context)),
              //! Learning Center
              // Row(
              //   children: [
              //     SvgPicture.asset(
              //       Assets.imagesLearningCenter,
              //     ),
              //     SizedBox(width: 4.rW(context)),
              //     Text(
              //       AppStrings.learningCenter.tr(context),
              //       style: Styles.medium12(context).copyWith(
              //         color: AppColors.greyText,
              //       ),
              //     ),
              //   ],
              // ),
              ProfileListTile(
                svg: Assets.imagesLearningCenter,
                title: AppStrings.learningCenter.tr(context),
                onTap: () {
                  navBarNavigate(
                    context: context,
                    widget: const LearningPage(),
                  );
                },
              ),
              //! logout
              ProfileListTile(
                svg: Assets.imagesLogout,
                title: AppStrings.logout.tr(context),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => const LogoutAlertDialog(),
                  );
                },
                trailingWidget: Container(),
                flip: context.read<GlobalCubit>().language == "en",
              ),
              SizedBox(height: 16.rH(context)),
            ],
          ),
        );
      },
    );
  }
}
