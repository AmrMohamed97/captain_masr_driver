// import 'package:flutter_svg/flutter_svg.dart';

// import '../../../../core/imports/imports.dart';

// class ChooseRoleView extends StatelessWidget {
//   const ChooseRoleView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.primary,
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 166.rH(context)),

//             //! Logo
//             Center(
//               child: Image.asset(
//                 Assets.imagesLogo,
//                 height: 165.rH(context),
//               ),
//             ),

//             SizedBox(height: 102.rH(context)),

//             //! Title
//             Text(
//               AppStrings.chooseRoleTitle.tr(context),
//               style: Styles.bold28white(context),
//               overflow: TextOverflow.clip,
//             ),

//             SizedBox(height: 29.rH(context)),

//             //! Subtitle
//             Text(
//               AppStrings.chooseRoleSubtitle.tr(context),
//               style: Styles.medium16Primary(context).copyWith(
//                 color: AppColors.white,
//               ),
//               overflow: TextOverflow.clip,
//             ),

//             SizedBox(height: 60.rH(context)),

//             Row(
//               children: [
//                 //! Rider Button
//                 Expanded(
//                   child: CustomButton(
//                     onPressed: () {
//                       context
//                           .read<GlobalCubit>()
//                           .selectRole(AppConstants.rider);
//                       navigate(context, const LoginView());
//                     },
//                     title: AppStrings.rider.tr(context),
//                     icon: SvgPicture.asset(
//                       Assets.imagesPerson,
//                       height: 20.rH(context),
//                     ),
//                     color: AppColors.white,
//                     textColor: AppColors.primary,
//                   ),
//                 ),

//                 SizedBox(width: 22.rH(context)),

//                 //! Driver Button
//                 Expanded(
//                   child: CustomButton(
//                     onPressed: () {
//                       context
//                           .read<GlobalCubit>()
//                           .selectRole(AppConstants.driver);
//                       navigate(context, const LoginView());
//                     },
//                     title: AppStrings.driver.tr(context),
//                     icon: SvgPicture.asset(
//                       Assets.imagesWheel,
//                       height: 20.rH(context),
//                     ),
//                     color: AppColors.white,
//                     textColor: AppColors.primary,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
