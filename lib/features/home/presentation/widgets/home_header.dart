import '../../../../core/imports/imports.dart';
import '../../../notifications/presentation/views/notifications_view.dart';
import '../cubit/home_cubit.dart';
import 'home_sliders.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Stack(
          children: [
            //! Background
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              height: state is SlidersLoadingState ||
                      (context.read<HomeCubit>().sliders?.isNotEmpty ?? false)
                  ? 228.rH(context)
                  : 130.rH(context),
              decoration:   BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
            //! Content
            Padding(
              padding: EdgeInsets.only(
                top: 53.rH(context),
                left: 16.rW(context),
                right: 16.rW(context),
              ),
              child: Column(
                children: [
                  //! Header
                  Row(
                    children: [
                      //! Drawer
                      if (context.read<GlobalCubit>().isDriver)
                        GestureDetector(
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                          },
                          child: Container(
                            width: 38.rH(context),
                            height: 38.rH(context),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(.90),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: Transform.flip(
                                flipX: context.read<GlobalCubit>().language ==
                                    "ar",
                                child: CustomSvgPicture(
                                  svg: Assets.imagesDrawer,
                                  height: 22.rH(context),
                                ),
                              ),
                            ),
                          ),
                        ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.rW(context),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //! Title
                              BlocBuilder<GlobalCubit, GlobalState>(
                                builder: (context, state) {
                                  return context
                                              .read<GlobalCubit>()
                                              .userModel
                                              ?.username !=
                                          null
                                      ? Text(
                                          AppStrings.helloNAME
                                              .tr(context)
                                              .replaceAll(
                                                "NAME",
                                                context
                                                        .read<GlobalCubit>()
                                                        .userModel
                                                        ?.username ??
                                                    "",
                                              ),
                                          style:
                                              Styles.bold20(context).copyWith(
                                            color: AppColors.white,
                                          ),
                                        )
                                      : Container();
                                },
                              ),
                              SizedBox(height: 7.rH(context)),
                              //! Subtitle
                              BlocBuilder<HomeCubit, HomeState>(
                                builder: (context, state) {
                                  return Text(
                                    context
                                        .read<HomeCubit>()
                                        .checkTimeOfDay()
                                        .tr(context),
                                    style: Styles.regular14(context).copyWith(
                                      color: AppColors.white,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      //! Notifications
                      GestureDetector(
                        onTap: () {
                          navBarNavigate(
                            context: context,
                            widget: const NotificationsView(),
                          );
                        },
                        child: Container(
                          width: 38.rH(context),
                          height: 38.rH(context),
                          decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(.90),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Badge(
                              isLabelVisible: false,
                              smallSize: 8.rH(context),
                              largeSize: 8.rH(context),
                              child: CustomSvgPicture(
                                svg: Assets.imagesNotifications,
                                height: 22.rH(context),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 39.rH(context)),

                  //! Slider
                  const HomeSliders(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
