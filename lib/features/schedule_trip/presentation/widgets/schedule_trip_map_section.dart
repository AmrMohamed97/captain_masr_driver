import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/imports/imports.dart';

class ScheduleTripMap extends StatelessWidget {
  const ScheduleTripMap({
    super.key,
    required this.latLng,
  });

  final LatLng? latLng;

  @override
  Widget build(BuildContext context) {
    if (latLng == null) {
      return const SizedBox.shrink();
    }
    return BlocBuilder<ScheduleTripCubit, ScheduleTripState>(
      builder: (context, state) {
        final cubit = context.read<ScheduleTripCubit>();
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: double.infinity,
                height: 156.rH(context),
                child: GoogleMap(
                  onMapCreated: (controller) {
                    cubit.mapController = controller;
                  },
                  style: context.read<GlobalCubit>().isDarkMode
                      ? context.read<GlobalCubit>().mapDarkStyle
                      : null,
                  // myLocationEnabled: true,
                  zoomGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: latLng!,
                    zoom: 14.151926040649414,
                  ),
                  markers: cubit.markers ?? {},
                  polylines: cubit.polylines,
                ),
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
                    bottom: (63.rH(context) / 2) - (27.rH(context) / 2),
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
        );
      },
    );
  }
}
