import 'dart:async';

import 'package:flutter_svg/svg.dart';

import '../../../../core/imports/imports.dart';

class LookingForDriversCard extends StatefulWidget {
  const LookingForDriversCard({
    super.key,
    this.seconds,
  });

  final int? seconds;

  @override
  State<LookingForDriversCard> createState() => _LookingForDriversCardState();
}

class _LookingForDriversCardState extends State<LookingForDriversCard> {
  int dotsNum = 1;
  int seconds = 0;
  Timer? timer;

  startDotsTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      seconds++;
      if (dotsNum < 4) {
        dotsNum++;
      } else {
        dotsNum = 1;
      }
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    seconds = widget.seconds ?? 0;
    startDotsTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FindDriverCubit, FindDriverState>(
      builder: (context, state) {
        final cubit = context.read<FindDriverCubit>();
        return Container(
          width: double.infinity,
          height: 96.rH(context),
          margin: EdgeInsets.symmetric(horizontal: 16.rW(context)),
          padding: EdgeInsets.symmetric(
            vertical: 17.rH(context),
            horizontal: 20.rW(context),
          ),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              //! Title
              Text(
                AppStrings.lookingForDrivers.tr(context) + ("." * dotsNum),
                style: Styles.bold16(context).copyWith(
                  color: AppColors.white,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  CustomSvgPicture(
                    svg: Assets.imagesTime,
                    height: 18.rH(context),
                    color: AppColors.white,
                  ),
                  SizedBox(width: 6.rW(context)),
                  Text(
                    "${(seconds ~/ 60)}:${(seconds % 60).toString().padLeft(2, "0")} ${AppStrings.min.tr(context)}",
                    style: Styles.semibold14Primary(context).copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const Spacer(),
                  //! Seen By
                  SizedBox(
                    width: 46.rW(context),
                    child: Stack(
                      children: List.generate(
                        cubit.notifiedDrivers.length > 3
                            ? 3
                            : cubit.notifiedDrivers.length,
                        (index) {
                          return Align(
                            alignment: index == 0
                                ? AlignmentDirectional.centerEnd
                                : index == 1
                                    ? Alignment.center
                                    : AlignmentDirectional.centerStart,
                            child: Container(
                              width: 22.rH(context),
                              height: 22.rH(context),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.white,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  cubit.notifiedDrivers[index].image ?? "",
                                  width: 22.rH(context),
                                  height: 22.rH(context),
                                  errorBuilder: (context, error, stackTrace) =>
                                      SvgPicture.asset(
                                    Assets.imagesPersonSvg,
                                    color: AppColors.grey,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 6.rW(context)),
                  Text(
                    AppStrings.seenByNUM.tr(context).replaceAll(
                        "NUM", (cubit.notifiedDrivers.length).toString()),
                    style: Styles.semibold14Primary(context).copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
