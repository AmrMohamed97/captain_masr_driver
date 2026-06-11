import 'package:captain_masr_driver/features/find_riders/presentation/views/find_riders_view.dart';
import 'package:captain_masr_driver/features/home/presentation/cubit/home_cubit.dart';

import '../../../../core/imports/imports.dart';
import '../../data/models/services_model.dart';
import 'home_service_card.dart';

class HomeServices extends StatefulWidget {
  const HomeServices({super.key});

  static List services = [
    ServicesModel(
      title: AppStrings.saveAndShare,
      type: AppStrings.shareRide,
      image: Assets.imagesShareTripCard,
    ),
    ServicesModel(
      title: AppStrings.rideTogether,
      type: AppStrings.dailyRides,
      image: Assets.imagesGroupTripCard,
    ),
    ServicesModel(
      title: AppStrings.privateAndComfy,
      type: AppStrings.classicRide,
      image: Assets.imagesClassicTripCard,
    ),
    ServicesModel(
      title: AppStrings.fastAndReliable,
      type: AppStrings.delivery,
      image: Assets.imagesDeliveryPng,
    ),
    ServicesModel(
      title: AppStrings.fastAndReliable,
      type: AppStrings.race,
      image: Assets.imagesRacingTripCard,
    ),
  ];

  @override
  State<HomeServices> createState() => _HomeServicesState();
}

class _HomeServicesState extends State<HomeServices> {
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateCurrentIndex);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateCurrentIndex);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateCurrentIndex() {
    if (_scrollController.hasClients) {
      final double offset = _scrollController.offset;
      final double itemWidth = 136.rW(context) + 16.rW(context);
      final int newIndex = (offset / itemWidth).round();

      if (newIndex != _currentIndex) {
        setState(() {
          _currentIndex = newIndex;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<GlobalCubit, GlobalState>(
          builder: (context, state) {
            final globalCubit = context.read<GlobalCubit>();
            final isOnline = globalCubit.driverOnline;

            return Center(
              child: Container(
                width: 250.rW(context),
                height: 48.rH(context),
                padding: EdgeInsets.all(4.rW(context)),
                decoration: BoxDecoration(
                  color: globalCubit.isDarkMode
                      ? Theme.of(context).cardColor
                      : const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(24.rW(context)),
                ),
                child: Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    // Active (Online) Tab - Left
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (!isOnline) {
                            globalCubit.driverOnlineToggle();
                            if (globalCubit.driverOnline) {
                              navigate(
                                context,
                                FindRidersView(
                                  acceptedTripTypeIds: context
                                      .read<HomeCubit>()
                                      .driverTripTypes,
                                ),
                              );
                            }
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isOnline
                                ? AppColors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20.rW(context)),
                          ),
                          child: Text(
                            AppStrings.online.tr(context),
                            style: Styles.medium16Primary(context).copyWith(
                              color: isOnline
                                  ? AppColors.white
                                  : (globalCubit.isDarkMode
                                      ? AppColors.greyText
                                      : AppColors.black.withOpacity(0.6)),
                              fontWeight: FontWeight.bold,
                              fontSize: 14.rT(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Inactive (Offline) Tab - Right
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (isOnline) {
                            globalCubit.driverOnlineToggle();
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: !isOnline
                                ? const Color(0xFF9E9E9E)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20.rW(context)),
                          ),
                          child: Text(
                            AppStrings.offline.tr(context),
                            style: Styles.medium16Primary(context).copyWith(
                              color: !isOnline
                                  ? AppColors.white
                                  : (globalCubit.isDarkMode
                                      ? AppColors.greyText
                                      : AppColors.black.withOpacity(0.6)),
                              fontWeight: FontWeight.bold,
                              fontSize: 14.rT(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        SizedBox(height: 20.rH(context)),

        SizedBox(
          width: double.infinity,
          height: 135.rH(context),
          child: ListView.separated(
            controller: _scrollController,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 10.rW(context)),
            itemCount: HomeServices.services.length + 1,
            separatorBuilder: (context, index) {
              return SizedBox(width: 12.rW(context));
            },
            itemBuilder: (context, index) {
              if (index == HomeServices.services.length) {
                return SizedBox(width: 200.rW(context));
              }
              return HomeServiceCard(
                model: HomeServices.services[index],
                onTap: () {
                  switch (index) {
                    case 0:
                      // navBarNavigate(
                      //   context: context,
                      //   widget: const StartTripView(isShareRide: true),
                      // );
                      break;
                    case 1:
                      // navBarNavigate(
                      //   context: context,
                      //   widget: const ScheduleTripView(),
                      // );
                      break;
                    case 2:
                    // navBarNavigate(
                    //   context: context,
                    //   widget: const StartTripView(),
                    // );
                    case 3:
                      // navBarNavigate(
                      //   context: context,
                      //   widget: const PackageDetailsView(),
                      // );
                      break;
                    case 4:
                      // navBarNavigate(
                      //   context: context,
                      //   widget: const RacingTripView(),
                      // );
                      break;
                    default:
                  }
                },
                selected: _currentIndex == index,
                index: index,
              );
            },
          ),
        ),
      ],
    );
  }
}
