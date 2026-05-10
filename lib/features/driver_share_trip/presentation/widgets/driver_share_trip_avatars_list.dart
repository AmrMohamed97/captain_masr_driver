import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_cached_network_image.dart';
import '../cubit/driver_share_trip_cubit.dart';

class DriverShareTripAvatarsList extends StatelessWidget {
  final bool isVertical;
  final VoidCallback onRotate;
  const DriverShareTripAvatarsList({
    super.key,
    this.isVertical = true,
    required this.onRotate,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverShareTripCubit, DriverShareTripState>(
      builder: (context, state) {
        final cubit = context.read<DriverShareTripCubit>();
        final riders = cubit.riders;

        return ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isVertical ? 80.rW(context) : 320.rW(context),
              height: isVertical ? 360.rH(context) : 90.rH(context),
              padding: EdgeInsets.symmetric(
                vertical: isVertical ? 10.rH(context) : 5.rH(context),
                horizontal: isVertical ? 5.rW(context) : 10.rW(context),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withOpacity(0.7),
                borderRadius: BorderRadius.circular(35),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  ListView(
                    scrollDirection:
                        isVertical ? Axis.vertical : Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: isVertical
                        ? EdgeInsets.only(bottom: 40.rH(context))
                        : EdgeInsets.only(right: 40.rW(context)),
                    children: [
                      // Driver Avatar
                      _buildAvatarItem(
                        context: context,
                        isSelected: cubit.isDriverSelected,
                        imageUrl: context
                                .read<GlobalCubit>()
                                .userModel
                                ?.profilePicture ??
                            "",
                        name: AppStrings.you.tr(context),
                        onTap: () => cubit.selectDriver(true),
                      ),
                      if (riders.isNotEmpty) ...[
                        isVertical
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.rH(context)),
                                child: Divider(
                                  color: AppColors.primary.withOpacity(0.2),
                                  indent: 10,
                                  endIndent: 10,
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.rW(context)),
                                child: VerticalDivider(
                                  color: AppColors.primary.withOpacity(0.2),
                                  indent: 10,
                                  endIndent: 10,
                                ),
                              ),
                        ...riders.map((rider) {
                          final String currentDay =
                              DateFormat('yyyy-MM-dd').format(DateTime.now());
                          if ((rider.days == null ||
                                  rider.days!.contains(currentDay)) &&
                              rider.status != 'completed') {
                            return Padding(
                              padding: isVertical
                                  ? EdgeInsets.only(bottom: 12.rH(context))
                                  : EdgeInsets.only(right: 12.rW(context)),
                              child: _buildAvatarItem(
                                context: context,
                                isSelected:
                                    cubit.selectedRider == rider.riderId,
                                imageUrl: rider.riderImage ?? "",
                                name: rider.riderName ?? "",
                                onTap: () => cubit.selectRider(rider.riderId!),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        }),
                      ],
                    ],
                  ),
                  // Rotation Button
                  Positioned(
                    bottom: isVertical ? 0 : null,
                    right: isVertical ? null : 0,
                    top: isVertical ? null : 0,
                    left: isVertical ? 0 : null,
                    child: Center(
                      child: GestureDetector(
                        onTap: onRotate,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.screen_rotation_rounded,
                            color: AppColors.primary,
                            size: 18.rH(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatarItem({
    required BuildContext context,
    required bool isSelected,
    required String imageUrl,
    required String name,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
              ),
              child: CircleAvatar(
                radius: 20.rH(context),
                backgroundColor: AppColors.grey.withOpacity(0.1),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CustomCachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    h: 40.rH(context),
                    w: 40.rH(context),
                    errorWidget: (context, url, error) => Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: SvgPicture.asset(
                        Assets.imagesPersonSvg,
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 2.rH(context)),
          SizedBox(
            width: 60.rW(context),
            child: Text(
              name.split(' ').first,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Styles.medium10white(context).copyWith(
                color: isSelected ? AppColors.primary : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
