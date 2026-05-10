import '../../../../core/imports/imports.dart';
import '../cubit/driver_trip_cubit.dart';
import 'driver_trip_bottom_section.dart';
import 'driver_trip_map.dart';

class DriverTripBody extends StatelessWidget {
  const DriverTripBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverTripCubit, DriverTripState>(
      builder: (context, state) {
        final cubit = context.read<DriverTripCubit>();
        return CustomModalProgressIndicator(
          inAsyncCall: state is DriverTripGetRouteLoadingState ||
              state is DriverTripLoadingState,
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: [
                //! Map
                const DriverTripMap(),

                //! Header
                Positioned(
                  top: 0,
                  left: 16.rW(context),
                  right: 16.rW(context),
                  child: const CustomAppBar(),
                ),

                //ToDo //! Test Button To Update Driver Location (Remove It)
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      top: 40,
                      end: 20,
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        await context.read<GlobalCubit>().getCurrentLocation();
                        context.read<GlobalCubit>().updateDriverLocation();
                      },
                      child: const CircleAvatar(),
                    ),
                  ),
                ),

                //! Bottom Section
                cubit.tripDetails == null
                    ? const SizedBox()
                    : const DriverTripBottomSection()
              ],
            ),
          ),
        );
      },
    );
  }
}
