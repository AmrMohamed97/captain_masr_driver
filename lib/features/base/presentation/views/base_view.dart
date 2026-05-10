import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../../../core/imports/imports.dart';
import '../../../home/presentation/views/home_view.dart';
import '../../../profile/presentation/views/profile_view.dart';
import '../../../trips/presentation/views/trips_view.dart';
import '../../../wallet/presentation/views/wallet_view.dart';

class BaseView extends StatelessWidget {
  const BaseView({super.key});

  List<Widget> screens() {
    return [
      const HomeView(),
      const TripsView(),
      const WalletView(),
      const ProfileView(),
    ];
  }

  List<PersistentBottomNavBarItem> items(context) => [
        PersistentBottomNavBarItem(
          icon: const CustomSvgPicture(svg: Assets.imagesHomeActive),
          inactiveIcon: const CustomSvgPicture(svg: Assets.imagesHomeInactive),
          title: AppStrings.home.tr(context),
          textStyle: Styles.bold12primary(context),
          activeColorPrimary: AppColors.primary,
        ),
        PersistentBottomNavBarItem(
          icon: const CustomSvgPicture(svg: Assets.imagesTripsActive),
          inactiveIcon: const CustomSvgPicture(svg: Assets.imagesTripsInactive),
          title: AppStrings.trips.tr(context),
          textStyle: Styles.bold12primary(context),
          activeColorPrimary: AppColors.primary,
        ),
        PersistentBottomNavBarItem(
          icon: const CustomSvgPicture(svg: Assets.imagesWalletActive),
          inactiveIcon:
              const CustomSvgPicture(svg: Assets.imagesWalletInactive),
          title: AppStrings.wallet.tr(context),
          textStyle: Styles.bold12primary(context),
          activeColorPrimary: AppColors.primary,
        ),
        PersistentBottomNavBarItem(
          icon: const CustomSvgPicture(svg: Assets.imagesProfileActive),
          inactiveIcon:
              const CustomSvgPicture(svg: Assets.imagesProfileInactive),
          title: AppStrings.profile.tr(context),
          textStyle: Styles.bold12primary(context),
          activeColorPrimary: AppColors.primary,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: context.read<GlobalCubit>().navBarController,
      screens: screens(),
      items: items(context),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: false,
      stateManagement: false,
      hideNavigationBarWhenKeyboardAppears: true,
      padding: EdgeInsets.only(
        top: 15.rH(context),
        bottom: 26.rH(context),
      ),
      backgroundColor: Theme.of(context).cardColor,
      isVisible: true,
      confineToSafeArea: true,
      navBarHeight: 82.rH(context),
      decoration: NavBarDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -2.rH(context)),
            color: AppColors.black.withOpacity(.10),
            blurRadius: 7,
          ),
        ],
      ),
    );
  }
}
