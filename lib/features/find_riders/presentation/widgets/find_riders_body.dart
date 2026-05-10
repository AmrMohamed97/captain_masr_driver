import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/imports/imports.dart';
import '../../../requests/presentation/views/requests_view.dart';

class FindRidersBody extends StatelessWidget {
  const FindRidersBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FindRidersCubit, FindRidersState>(
      builder: (context, state) {
        final cubit = context.read<FindRidersCubit>();
        return CustomModalProgressIndicator(
          inAsyncCall: state is FindRidersGetCurrentLocationLoadingState,
          child: Stack(
            children: [
              //! Map
              if (cubit.latitude != null && cubit.longitude != null)
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
                        cubit.latitude!,
                        cubit.longitude!,
                      ),
                      zoom: 20,
                    ),
                    // markers: cubit.markers ?? {},
                    // polylines: cubit.polylines,
                  ),
                ),

              //! Header
              Positioned(
                top: 0,
                left: 16.rW(context),
                right: 16.rW(context),
                child: CustomAppBar(
                  trailing: GestureDetector(
                    onTap: () => navigate(
                      context,
                      BlocProvider.value(
                        value: cubit,
                        child: const RequestsView(),
                      ),
                    ),
                    child: Badge(
                      isLabelVisible: cubit.rideRequests.isNotEmpty,
                      smallSize: 12.rH(context),
                      label: Text(
                        cubit.rideRequests.length.toString(),
                        style: Styles.medium10white(context),
                      ),
                      child: CircleAvatar(
                        radius: 19.rH(context),
                        backgroundColor: AppColors.primary,
                        child: const CustomSvgPicture(
                          svg: Assets.imagesRequestsFilled,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              //! Search Container
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  height: 134.rH(context),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.searchingForRider.tr(context),
                        style: Styles.medium16Primary(context).copyWith(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      SizedBox(height: 18.rH(context)),
                      Lottie.asset(
                        'assets/json/record_lottie.json',
                        height: 60.rH(context),
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
              ),

              //! Timer
              if (cubit.latitude != null && cubit.longitude != null)
                Positioned(
                  top: 48.rH(context),
                  left: 0,
                  right: 0,
                  child: const RidersSearchTimerContainer(),
                ),
            ],
          ),
        );
      },
    );
  }
}

class RidersSearchTimerContainer extends StatefulWidget {
  const RidersSearchTimerContainer({
    super.key,
  });

  @override
  State<RidersSearchTimerContainer> createState() =>
      _RidersSearchTimerContainerState();
}

class _RidersSearchTimerContainerState
    extends State<RidersSearchTimerContainer> {
  late Timer timer;
  int seconds = 0;
  @override
  void initState() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (value) {
        seconds++;
        setState(() {});
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 40.rH(context),
        width: 93.rW(context),
        padding: EdgeInsets.symmetric(horizontal: 24.rW(context)),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: FittedBox(
            child: Text(
              "${(seconds ~/ 60)}:${(seconds % 60).toString().padLeft(2, "0")}",
              style: Styles.medium20white(context),
            ),
          ),
        ),
      ),
    );
  }
}
