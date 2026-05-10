// import 'package:flutter_svg/svg.dart';
// import 'package:intl/intl.dart';

// import '../../../../core/imports/imports.dart';
// import '../../../../core/widgets/custom_cached_network_image.dart';
// import '../cubit/driver_share_trip_cubit.dart';

// class DriverShareTripRidersAndCostRow extends StatelessWidget {
//   const DriverShareTripRidersAndCostRow({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<DriverShareTripCubit, DriverShareTripState>(
//       builder: (context, state) {
//         final cubit = context.read<DriverShareTripCubit>();
//         final riders = cubit.riders;
//         final double overlap = 40.rW(context);
//         final double avatarSize = 60.rH(context);
//         return Padding(
//           padding: EdgeInsets.only(bottom: 16.rH(context)),
//           child: Row(
//             children: [
//               Align(
//                 alignment: AlignmentDirectional.centerStart,
//                 child: SizedBox(
//                   height: avatarSize,
//                   width: (riders.isNotEmpty)
//                       ? avatarSize + overlap * (riders.length - 1)
//                       : 0,
//                   child: Stack(
//                     clipBehavior: Clip.none,
//                     children: List.generate(
//                       riders.length,
//                       (index) => index, // just index list
//                     ).reversed.map(
//                       // reversed for index 0 on top
//                       (index) {
//                         final reversedIndex = riders.length - 1 - index;
//                         final String currentDay =
//                             DateFormat('yyyy-MM-dd').format(DateTime.now());
//                         if (riders[index].days!.contains(currentDay)) {
//                           return PositionedDirectional(
//                             top: 0,
//                             bottom: 0,
//                             end: 40.rW(context) * reversedIndex,
//                             child: GestureDetector(
//                               onTap: () {
//                                 cubit.selectRider(index);
//                               },
//                               child: Center(
//                                 child: CustomCachedNetworkImage(
//                                   imageUrl: riders[index].riderImage ?? "",
//                                   h: index == 0
//                                       ? 60.rH(context)
//                                       : 46.rH(context),
//                                   w: index == 0
//                                       ? 60.rH(context)
//                                       : 46.rH(context),
//                                   borderRadius: 100,
//                                   errorWidget: (p0, p1, p2) => SvgPicture.asset(
//                                     Assets.imagesPersonSvg,
//                                     height: index == 0
//                                         ? 60.rH(context)
//                                         : 46.rH(context),
//                                     color: AppColors.grey,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         } else {
//                           return const SizedBox();
//                         }
//                       },
//                     ).toList(),
//                   ),
//                 ),
//               ),
//               const Spacer(),
//               CustomSvgPicture(
//                 svg: Assets.imagesCashPaper,
//                 height: 27.rH(context),
//               ),
//               SizedBox(width: 15.rW(context)),
//               Text(
//                 "${cubit.tripDetails?.price ?? 0} ${AppStrings.egp.tr(context)}",
//                 style: Styles.semibold20Primary(context).copyWith(
//                   color: AppColors.red,
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
