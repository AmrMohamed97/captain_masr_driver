import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../splash/presentation/views/splash_view.dart';
import '../cubit/become_rider_or_driver_cubit.dart';
import '../widgets/become_rider_or_driver_body.dart';

class BecomeRiderOrDriverView extends StatelessWidget {
  const BecomeRiderOrDriverView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BecomeRiderOrDriverCubit(
        isConvertedBefore:
            context.read<GlobalCubit>().userModel?.isConvertedToDriverBefore ??
                false,
      ),
      child: BlocConsumer<BecomeRiderOrDriverCubit, BecomeRiderOrDriverState>(
        listener: (context, state) {
          //! Become Rider Success
          if (state is BecomeRiderSuccessState) {
            context.read<GlobalCubit>().navBarController.jumpToTab(0);
            context.read<GlobalCubit>().stopUpdatingDriverLocation();
            context.read<GlobalCubit>().driverOnline = false;
            showToast(
              context,
              message: state.message,
              state: ToastStates.success,
            );
            context.read<GlobalCubit>().selectRole(AppConstants.rider);
            context.read<GlobalCubit>().init();
            navigateAndRemoveUntil(
              context,
              const SplashView(),
            );
          }
          //! Become Driver Success
          if (state is BecomeDriverSuccessState) {
            showToast(
              context,
              message: state.message,
              state: ToastStates.success,
            );
            context.read<GlobalCubit>().navBarController.jumpToTab(0);
            //------------------------------------------------------------------
            if (context
                    .read<GlobalCubit>()
                    .userModel
                    ?.isConvertedToDriverBefore !=
                true) {
              context.read<GlobalCubit>().stopUpdatingDriverLocation();
              context.read<GlobalCubit>().driverOnline = false;
              // if (context.read<GlobalCubit>().isRider) {
              //   context.read<GlobalCubit>().navBarController.jumpToTab(0);
              // }
              sl<Cache>().removeKey(AppConstants.token);
              sl<Cache>().removeKey(AppConstants.role);
              sl<Cache>().removeKey(AppConstants.user);
              // context.read<GlobalCubit>().selectRole(AppConstants.driver);
              // context.read<GlobalCubit>().init();
              context.read<GlobalCubit>().getUserData();
              context.read<GlobalCubit>().selectRole(AppConstants.driver);
              navigate(context, const LoginView());
            } else {
              context.read<GlobalCubit>().selectRole(AppConstants.driver);
              context.read<GlobalCubit>().init();
              navigateAndRemoveUntil(
                context,
                const SplashView(),
              );
            }
            // navigateAndRemoveUntil(
            //   context,
            //   const ChooseRoleView(),
            // );
            //------------------------------------------------------------------
          }
          //! Become Rider Or Driver Error
          if (state is BecomeRiderOrDriverErrorState) {
            showToast(
              context,
              message: state.error,
              state: ToastStates.error,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: CustomModalProgressIndicator(
              inAsyncCall: state is BecomeRiderOrDriverLoadingState,
              child: const BecomeRiderOrDriverBody(),
            ),
          );
        },
      ),
    );
  }
}
