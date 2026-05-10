import '../../../../core/imports/imports.dart';
import '../../../delivery/presentation/views/package_details_view.dart';
import '../../../schedule_trip/presentation/views/schedule_trip_view.dart';
import '../../../start_trip/presentation/views/start_trip_view.dart';
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
      final double itemWidth = 187.rW(context) + 16.rW(context);
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
        //! Title
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
          child: Text(
            AppStrings.services.tr(context),
            style: Styles.semibold18Primary(context).copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ),

        SizedBox(height: 16.rH(context)),

        SizedBox(
          width: double.infinity,
          height: 163.rH(context),
          child: ListView.separated(
            controller: _scrollController,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
            itemCount: HomeServices.services.length + 1,
            separatorBuilder: (context, index) {
              return SizedBox(width: 12.rW(context));
            },
            itemBuilder: (context, index) {
              if (index == HomeServices.services.length) {
                return SizedBox(width: 80.rW(context));
              }
              return HomeServiceCard(
                model: HomeServices.services[index],
                onTap: () {
                  switch (index) {
                    case 0:
                      navBarNavigate(
                        context: context,
                        widget: const StartTripView(
                          isShareRide: true,
                        ),
                      );
                      break;
                    case 1:
                      navBarNavigate(
                        context: context,
                        widget: const ScheduleTripView(),
                      );
                      break;
                    case 2:
                      navBarNavigate(
                        context: context,
                        widget: const StartTripView(),
                      );
                    case 3:
                      navBarNavigate(
                        context: context,
                        widget: const PackageDetailsView(),
                      );
                      break;
                    default:
                  }
                },
                selected: _currentIndex == index,
                index: index,
              );
            },
          ),
        )
      ],
    );
  }
}
