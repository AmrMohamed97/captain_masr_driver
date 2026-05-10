
// import 'dart:async';

// import '../../../../core/imports/imports.dart';

// class CarMovementView extends StatefulWidget {
//   const CarMovementView({
//     super.key,
//     required this.startTimeMinutes,
//   });

//   final num startTimeMinutes;

//   @override
//   State<CarMovementView> createState() => _CarMovementViewState();
// }

// class _CarMovementViewState extends State<CarMovementView> {
//   late int totalSeconds;
//   late int remainingSeconds;
//   Timer? _timer;

//   @override
//   void initState() {
//     super.initState();
//     totalSeconds = (widget.startTimeMinutes * 60).toInt();
//     if (totalSeconds < 0) totalSeconds = 0;
//     remainingSeconds = totalSeconds;
//     _startTimer();
//   }

//   void _startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (remainingSeconds > 0) {
//         setState(() {
//           remainingSeconds--;
//         });
//       } else {
//         _timer?.cancel();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double progress = totalSeconds == 0
//         ? 1.0
//         : (totalSeconds - remainingSeconds) / totalSeconds;
//     progress = progress.clamp(0.0, 1.0);

//     double containerWidth = 295.rW(context);
//     double carWidth = 22.rH(context);

//     return SizedBox(
//       height: 50.rH(context),
//       width: containerWidth,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           LinearProgressIndicator(
//             value: progress,
//             minHeight: 8.rH(context),
//             valueColor: const AlwaysStoppedAnimation(AppColors.primary),
//             backgroundColor: AppColors.grey,
//             borderRadius: BorderRadius.circular(6),
//           ),
//           AnimatedPositionedDirectional(
//             duration: const Duration(seconds: 1),
//             start: progress * (containerWidth - carWidth),
//             child: Column(
//               children: [
//                 CircleAvatar(
//                   radius: 11.rH(context),
//                   backgroundColor: AppColors.grey,
//                   child: CircleAvatar(
//                     radius: 10.rH(context),
//                     backgroundColor: AppColors.primary,
//                     child: CircleAvatar(
//                       radius: 9.rH(context),
//                       backgroundColor: AppColors.primary,
//                       child: const CustomSvgPicture(
//                         svg: Assets.imagesSliderCar,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // if (cubit.remainingDistance != null)
//           //   AnimatedPositionedDirectional(
//           //     duration:
//           //         const Duration(milliseconds: 300),
//           //     start:
//           //         295.rW(context) - 22.rW(context),
//           //     bottom: 0,
//           //     child: Text(
//           //       cubit.remainingDistance!,
//           //       style: Styles.medium12(context)
//           //           .copyWith(
//           //         color: Theme.of(context)
//           //             .textTheme
//           //             .bodyLarge
//           //             ?.color,
//           //       ),
//           //     ),
//           //   ),
//         ],
//       ),
//     );
//   }
// }
