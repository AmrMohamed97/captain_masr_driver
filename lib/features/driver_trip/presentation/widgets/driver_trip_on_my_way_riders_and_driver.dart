import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_cached_network_image.dart';
import '../cubit/driver_trip_cubit.dart';

class DriverTripOnMyWayRidersAndDriver extends StatelessWidget {
  const DriverTripOnMyWayRidersAndDriver({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverTripCubit, DriverTripState>(
      builder: (context, state) {
        final cubit = context.read<DriverTripCubit>();
        final riders = cubit.riders;
        final double overlap = 40.rW(context);
        final double avatarSize = 60.rH(context);
        return Padding(
          padding: EdgeInsetsDirectional.only(
            bottom: 16.rH(context),
            start: 16.rW(context),
          ),
          child: Row(
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: SizedBox(
                  height: avatarSize,
                  width: (riders.isNotEmpty)
                      ? avatarSize + overlap * (riders.length - 1)
                      : 0,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: List.generate(
                      riders.length,
                      (index) => index,
                    ).reversed.map(
                      (index) {
                        final reversedIndex = riders.length - 1 - index;
                        return PositionedDirectional(
                          top: 0,
                          bottom: 0,
                          end: 40.rW(context) * reversedIndex,
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                cubit.selectDriver(false);
                                cubit.selectRider(index);
                              },
                              child: CustomCachedNetworkImage(
                                imageUrl: riders[index].riderImage ?? "",
                                h: index == 0 && !cubit.isDriverSelected
                                    ? 60.rH(context)
                                    : 46.rH(context),
                                w: index == 0 && !cubit.isDriverSelected
                                    ? 60.rH(context)
                                    : 46.rH(context),
                                borderRadius: 100,
                                errorWidget: (p0, p1, p2) => SvgPicture.asset(
                                  Assets.imagesPersonSvg,
                                  height: index == 0 && !cubit.isDriverSelected
                                      ? 60.rH(context)
                                      : 46.rH(context),
                                  color: AppColors.grey,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  cubit.selectDriver(true);
                },
                child: CircleAvatar(
                  radius:
                      cubit.isDriverSelected ? 30.rH(context) : 23.rH(context),
                  backgroundColor: cubit.isDriverSelected
                      ? AppColors.primary
                      : AppColors.white,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CustomCachedNetworkImage(
                      imageUrl: context
                              .read<GlobalCubit>()
                              .userModel
                              ?.profilePicture ??
                          "",
                      h: 59.rH(context),
                      fit: BoxFit.cover,
                      errorWidget: (p0, p1, p2) => SvgPicture.asset(
                        Assets.imagesPersonSvg,
                        height: 59.rH(context),
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
