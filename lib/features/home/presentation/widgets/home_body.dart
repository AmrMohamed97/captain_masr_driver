import 'package:captain_masr_driver/features/home/presentation/widgets/home_header.dart';
import 'package:captain_masr_driver/features/home/presentation/widgets/home_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/imports/imports.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return BlocListener<GlobalCubit, GlobalState>(
      listener: (context, state) {
        if (state is UpdateUserLocationState) {
          final userLocation = context.read<GlobalCubit>().userLocation;
          if (userLocation != null && mapController != null) {
            mapController!.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(target: userLocation, zoom: 15.0),
              ),
            );
          }
        }
      },
      child: BlocBuilder<GlobalCubit, GlobalState>(
        builder: (context, state) {
          final globalCubit = context.read<GlobalCubit>();
          return Stack(
            alignment: Alignment.topCenter,
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
                    globalCubit.userLocation?.latitude ?? 26.820553,
                    globalCubit.userLocation?.longitude ?? 30.802498,
                  ),
                  zoom: globalCubit.userLocation != null
                      ? 15.0
                      : 6.151926040649414,
                ),
              ),

              //! HomeHeader
              const HomeHeader(),

              if (globalCubit.userLocation != null)
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
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              radius: 5.rH(context),
                              backgroundColor: AppColors.white,
                            ),
                          ),
                          CustomSvgPicture(
                            svg: Assets.carMapImage,
                            height: 22.rH(context),
                            width: 27.rH(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              //----------------------------------------------------------------
              ///services
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      onPressed: () async {
                        await context.read<GlobalCubit>().getCurrentLocation();
                        final userLocation = context
                            .read<GlobalCubit>()
                            .userLocation;
                        if (userLocation != null && mapController != null) {
                          mapController!.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(target: userLocation, zoom: 15.0),
                            ),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(start: 14.0),
                        child: CircleAvatar(
                          radius: 30.rH(context),
                          backgroundColor: AppColors.white,
                          child: CustomSvgPicture(
                            svg: Assets.imagesPinLocation,
                            height: 26.rH(context),
                            width: 26.rH(context),
                            color: AppColors.primary,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(.08),
                            blurRadius: 15,
                            spreadRadius: 1,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.only(
                        top: 24.rH(context),
                        bottom: 35.rH(context),
                      ),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [HomeServices()],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
