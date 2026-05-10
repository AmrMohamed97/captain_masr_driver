import 'dart:async';

import '../../../../core/imports/imports.dart';

class FindDriverMyLocationPin extends StatefulWidget {
  const FindDriverMyLocationPin({
    super.key,
  });

  @override
  State<FindDriverMyLocationPin> createState() =>
      _FindDriverMyLocationPinState();
}

class _FindDriverMyLocationPinState extends State<FindDriverMyLocationPin> {
  double firstOpacity = 1.0;
  double firstRadius = 0;
  bool showFirstCircle = true;
  Timer? loopTimer;

  void startFadeLoop() {
    loopTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;

      showFirstCircle = true;
      firstRadius = 300;
      firstOpacity = 0.0;
      if (!mounted) return;
      setState(() {});

      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        showFirstCircle = false;
        firstRadius = 0;
        if (!mounted) return;
        setState(() {});
      });

      Future.delayed(const Duration(seconds: 3), () {
        if (!mounted) return;
        showFirstCircle = true;
        firstOpacity = 1.0;
        if (!mounted) return;
        setState(() {});
      });
    });
  }

  @override
  void initState() {
    super.initState();
    startFadeLoop();
  }

  @override
  void dispose() {
    loopTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (showFirstCircle)
          Center(
            child: AnimatedOpacity(
              duration: const Duration(seconds: 2),
              opacity: firstOpacity,
              child: AnimatedContainer(
                duration: const Duration(seconds: 2),
                width: firstRadius.rH(context),
                height: firstRadius.rH(context),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(.15),
                ),
              ),
            ),
          ),
        Center(
          child: CircleAvatar(
            radius: 57.rH(context),
            backgroundColor: AppColors.white,
            child: Center(
              child: CircleAvatar(
                radius: 50.rH(context),
                backgroundColor: AppColors.primary,
                child: const CustomSvgPicture(
                  svg: Assets.imagesSend,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
