import 'package:captain_masr_driver/features/home/presentation/views/home_view.dart';

import '../../../../core/imports/imports.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  double carPosititon = -400;
  double logoPosition = 145;

  bool showLogo = false;
  bool showTitle = false;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 400), () {
      // final bool onBoardingVisited =
      //     sl<Cache>().getBoolData(AppConstants.onBoardingVisited) ?? false;
      carPosititon = 0;
      setState(() {});
      Future.delayed(const Duration(seconds: 0), () {
        showLogo = true;
        setState(() {});
        Future.delayed(const Duration(seconds: 1), () {
          logoPosition = 176;
          setState(() {});
          Future.delayed(const Duration(milliseconds: 300), () {
            showTitle = true;
            setState(() {});
            Future.delayed(const Duration(milliseconds: 1300), () {
              context.read<GlobalCubit>().selectRole(AppConstants.driver);
              // navigate(context, const LoginView());
              navigateReplacement(
                // ignore: use_build_context_synchronously
                context,
                // onBoardingVisited
                //     ?
                sl<Cache>().getStringData(AppConstants.token) == null
                    ? const LoginView()
                    // : context.read<GlobalCubit>().isRider
                    //     ? const BaseView()
                    : const HomeView(),
                // : const OnboardingView(),
              );
            });
          });
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          //! Road Image
          Image.asset(
            Assets.splashBG,
            width: double.infinity,
            fit: BoxFit.fitWidth,
          ),
          //! Car Image
          // AnimatedPositioned(
          //   duration: const Duration(milliseconds: 1000),
          //   left: carPosititon,
          //   bottom: 88.rH(context),
          //   child: Image.asset(Assets.imagesSplashCar),
          // ),
          //! Logo
          RepaintBoundary(
            child: AnimatedScale(
              scale: showLogo ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 1600),
              curve: Curves.easeOutBack,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 1200),
                opacity: showLogo ? 1 : 0,
                child: Image.asset(Assets.imagesLogo),
              ),
            ),
          ),
          //! Title
          // Positioned(
          //   top: 141.rH(context),
          //   left: 0,
          //   right: 0,
          //   child: AnimatedOpacity(
          //     duration: const Duration(milliseconds: 300),
          //     opacity: showTitle ? 1 : 0,
          //     child: Center(
          //       child: Text(
          //         AppStrings.splashTitle.tr(context),
          //         style: Styles.bold22white(context),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
