import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/imports/imports.dart';
import '../../../saved_places/data/models/saved_place_model.dart';
import '../../../saved_places/presentation/views/saved_places_view.dart';

class HomeCurrentLocation extends StatefulWidget {
  const HomeCurrentLocation({super.key});

  @override
  State<HomeCurrentLocation> createState() => _HomeCurrentLocationState();
}

class _HomeCurrentLocationState extends State<HomeCurrentLocation> {
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 344.rW(context),
      height: 266.rH(context),
      margin: EdgeInsets.symmetric(horizontal: 16.rW(context)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.grey.withOpacity(.5),
        ),
      ),
      child: BlocBuilder<GlobalCubit, GlobalState>(
        builder: (context, state) {
          final globalCubit = context.read<GlobalCubit>();
          return Column(
            children: [
              //! Title & Location
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.rW(context),
                  vertical: 12.rH(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //* Title
                    Text(
                      AppStrings.yourCurrentLocations.tr(context),
                      style: Styles.regular12(context).copyWith(
                        color: AppColors.greyText,
                      ),
                    ),
                    SizedBox(height: 6.rH(context)),
                    //* Current Location
                    Row(
                      children: [
                        const CustomSvgPicture(
                          svg: Assets.imagesPinLocation,
                        ),
                        SizedBox(width: 8.rW(context)),
                        Expanded(
                          child: Text(
                            globalCubit.userLocationName ?? "...",
                            style: Styles.semibold14Primary(context).copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              //! Map
              if (globalCubit.userLocation != null)
                Expanded(
                  child: Stack(
                    children: [
                      GoogleMap(
                        onMapCreated: (controller) {
                          mapController = controller;
                        },
                        style: context.read<GlobalCubit>().isDarkMode
                            ? context.read<GlobalCubit>().mapDarkStyle
                            : null,
                        zoomGesturesEnabled: false,
                        scrollGesturesEnabled: false,
                        zoomControlsEnabled: false,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            globalCubit.userLocation!.latitude,
                            globalCubit.userLocation!.longitude,
                          ),
                          zoom: 14.151926040649414,
                        ),
                      ),

                      //! Pin
                      Positioned.fill(
                        child: Center(
                          child: Container(
                            width: 63.rH(context),
                            height: 63.rH(context),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(.15),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: CircleAvatar(
                                    radius: 5.rH(context),
                                    backgroundColor: AppColors.white,
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  bottom: (63.rH(context) / 2) -
                                      (27.rH(context) / 2),
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: CustomSvgPicture(
                                      svg: Assets.imagesPinLocation,
                                      height: 27.rH(context),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 12.rH(context)),

              //! Choose Saved Place
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 11.rW(context)),
                child: InkWell(
                  overlayColor: const WidgetStatePropertyAll(
                    AppColors.transparent,
                  ),
                  onTap: () {
                    navBarNavigate(
                      context: context,
                      widget: const SavedPlacesView(
                        canChoose: true,
                      ),
                      then: (value) {
                        if (value != null && value is SavedPlaceModel) {
                          globalCubit.setRiderLoction(value).then((value) {
                            if (globalCubit.userLocation != null) {
                              mapController?.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: globalCubit.userLocation!,
                                    zoom: 14.151926040649414,
                                  ),
                                ),
                              );
                            }
                          });
                        }
                      },
                    );
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 10.rH(context),
                        backgroundColor: AppColors.grey3,
                        child: Icon(
                          Icons.star,
                          color: AppColors.primary,
                          size: 14.rH(context),
                        ),
                      ),
                      SizedBox(width: 10.rW(context)),
                      Text(
                        AppStrings.chooseSavedPlace.tr(context),
                        style: Styles.medium14(context).copyWith(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        size: 14.rH(context),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16.rH(context)),
            ],
          );
        },
      ),
    );
  }
}
