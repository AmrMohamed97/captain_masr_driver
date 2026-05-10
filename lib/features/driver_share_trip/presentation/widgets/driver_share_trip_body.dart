import '../../../../core/imports/imports.dart';
import '../cubit/driver_share_trip_cubit.dart';
import 'driver_share_trip_avatars_list.dart';
import 'driver_share_trip_bottom_section.dart';
import 'driver_share_trip_map.dart';

class DriverShareTripBody extends StatefulWidget {
  final int tripId;
  const DriverShareTripBody({super.key, required this.tripId});

  @override
  State<DriverShareTripBody> createState() => _DriverShareTripBodyState();
}

class _DriverShareTripBodyState extends State<DriverShareTripBody> {
  Offset? _avatarsOffset;
  bool _isInitialized = false;

  bool _isVertical = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverShareTripCubit, DriverShareTripState>(
      builder: (context, state) {
        final cubit = context.read<DriverShareTripCubit>();

        // Initialize default position
        if (!_isInitialized && cubit.tripDetails != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                final screenWidth = MediaQuery.of(context).size.width;
                final screenHeight = MediaQuery.of(context).size.height;
                // Default to bottom right
                _avatarsOffset = Offset(
                  screenWidth - 86.rW(context), // 70 width + 16 padding
                  screenHeight - 500.rH(context), // Adjust based on bottom sheet
                );
                _isInitialized = true;
              });
            }
          });
        }

        return CustomModalProgressIndicator(
          inAsyncCall: state is DriverShareTripGetRouteLoadingState ||
              state is DriverShareTripLoadingState,
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: [
                //! Map
                const DriverShareTripMap(),

                //! Header
                Positioned(
                  top: 0,
                  left: 16.rW(context),
                  right: 16.rW(context),
                  child: const CustomAppBar(),
                ),

                //! Floating Draggable & Rotatable Avatars (Driver & Riders)
                if (cubit.tripDetails != null && _avatarsOffset != null)
                  Positioned(
                    left: _avatarsOffset!.dx,
                    top: _avatarsOffset!.dy,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          final screenWidth = MediaQuery.of(context).size.width;
                          final screenHeight = MediaQuery.of(context).size.height;

                          // Dimensions based on orientation
                          final avatarsWidth =
                              _isVertical ? 80.rW(context) : 300.rW(context);
                          final avatarsHeight =
                              _isVertical ? 350.rH(context) : 90.rH(context);

                          double newDx = _avatarsOffset!.dx + details.delta.dx;
                          double newDy = _avatarsOffset!.dy + details.delta.dy;

                          // Constraints
                          newDx = newDx.clamp(0.0, screenWidth - avatarsWidth);
                          newDy =
                              newDy.clamp(0.0, screenHeight - avatarsHeight);

                          _avatarsOffset = Offset(newDx, newDy);
                        });
                      },
                      child: DriverShareTripAvatarsList(
                        isVertical: _isVertical,
                        onRotate: () {
                          setState(() {
                            _isVertical = !_isVertical;
                          });
                        },
                      ),
                    ),
                  ),

                //! Bottom Section
                cubit.tripDetails == null
                    ? const SizedBox()
                    :   DriverShareTripBottomSection(tripId: widget.tripId,)
              ],
            ),
          ),
        );
      },
    );
  }
}
