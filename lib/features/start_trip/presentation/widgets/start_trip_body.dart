import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/imports/imports.dart';
import '../cubit/start_trip_cubit/start_trip_cubit.dart';
import 'start_trip_bottom_section.dart';

class StartTripBody extends StatelessWidget {
  const StartTripBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartTripCubit, StartTripState>(
      builder: (context, state) {
        final cubit = context.read<StartTripCubit>();
        final globalCubit = context.read<GlobalCubit>();
        return CustomModalProgressIndicator(
          inAsyncCall: state is GetCurrentLocationLoadingState,
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: [
                //! Map
                if (globalCubit.userLocation != null)
                  Positioned.fill(
                    child: GoogleMap(
                      onMapCreated: (controller) {
                        cubit.mapController = controller;
                      },
                      style: context.read<GlobalCubit>().isDarkMode
                          ? context.read<GlobalCubit>().mapDarkStyle
                          : null,
                      myLocationEnabled: true,
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          globalCubit.userLocation!.latitude,
                          globalCubit.userLocation!.longitude,
                        ),
                        zoom: 14,
                      ),
                      markers: cubit.markers ?? {},
                      polylines: cubit.polylines,
                    ),
                  ),

                //! Header
                Positioned(
                  top: 0,
                  left: 16.rW(context),
                  right: 16.rW(context),
                  child: const CustomAppBar(),
                ),

                //! Bottom Section
                const StartTripBottomSection(),
              ],
            ),
          ),
        );
      },
    );
  }
}
