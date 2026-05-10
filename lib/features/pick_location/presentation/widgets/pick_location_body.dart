import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/imports/imports.dart';

class PickLocationBody extends StatefulWidget {
  const PickLocationBody({super.key});

  @override
  State<PickLocationBody> createState() => _PickLocationBodyState();
}

class _PickLocationBodyState extends State<PickLocationBody> {
  CameraPosition? position;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChooseLocationCubit, ChooseLocationState>(
      listener: (context, state) {
        if (state is ChooseLocationGetCurrentLocationSuccessState) {
          position = CameraPosition(
              target: LatLng(
            context.read<ChooseLocationCubit>().latitude ?? 0,
            context.read<ChooseLocationCubit>().longitude ?? 0,
          ));
        }
      },
      builder: (context, state) {
        return CustomModalProgressIndicator(
          inAsyncCall: state is ChooseLocationGetCurrentLocationLoadingState,
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: [
                //! Map
                if (position != null)
                  Positioned.fill(
                    child: GoogleMap(
                      style: context.read<GlobalCubit>().isDarkMode
                          ? context.read<GlobalCubit>().mapDarkStyle
                          : null,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: position!.target,
                        zoom: 14.151926040649414,
                      ),
                      onCameraMove: (value) {
                        position = value;
                      },
                      onCameraIdle: () {
                        if (position != null) {
                          context.read<ChooseLocationCubit>().getCurrentAddress(
                                lat: position!.target.latitude,
                                long: position!.target.longitude,
                              );
                        }
                      },
                    ),
                  ),

                //! Header
                PositionedDirectional(
                  start: 16.rW(context),
                  end: 16.rW(context),
                  child: const CustomAppBar(),
                ),

                //! Pin
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      context.read<ChooseLocationCubit>().addressName != null ||
                              state is GetCurrentAddressLoadingState
                          ? Container(
                              constraints: BoxConstraints(
                                maxWidth: 300.rW(context),
                              ),
                              height: 30.rH(context),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.rW(context)),
                              margin: EdgeInsets.only(bottom: 10.rH(context)),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  state is GetCurrentAddressLoadingState
                                      ? SizedBox(
                                          height: 20.rH(context),
                                          child: const CustomLoadingIndicator(
                                            color: AppColors.white,
                                          ),
                                        )
                                      : Expanded(
                                          child: Text(
                                            context
                                                .read<ChooseLocationCubit>()
                                                .addressName!,
                                            style: Styles.medium14(context)
                                                .copyWith(
                                                    color: AppColors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                ],
                              ),
                            )
                          : SizedBox(height: 30.rH(context)),
                      Icon(
                        Icons.location_on,
                        color: AppColors.primary,
                        size: 48.rH(context),
                      ),
                      SizedBox(height: 86.rH(context)),
                    ],
                  ),
                ),

                //! Confirm Button
                Positioned(
                  bottom: 45.rH(context),
                  left: 16.rW(context),
                  right: 16.rW(context),
                  child: CustomButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        [
                          position,
                          context.read<ChooseLocationCubit>().addressName,
                        ],
                      );
                    },
                    title: AppStrings.confirm.tr(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
