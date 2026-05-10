import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../widgets/trips_body.dart';

class TripsView extends StatelessWidget {
  const TripsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TripsCubit(
        isRider: context.read<GlobalCubit>().isRider,
        userId: context.read<GlobalCubit>().userModel?.id ?? 0,
      ),
      child: BlocConsumer<TripsCubit, TripsState>(
        listener: (context, state) {
          if (state is TripsErrorState) {
            showToast(
              context,
              message: state.error,
              state: ToastStates.error,
            );
          }
          if (state is TripsSuccessState) {
            if (state.message != null) {
              showToast(
                context,
                message: state.message!,
                state: ToastStates.success,
              );
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: CustomModalProgressIndicator(
              inAsyncCall: state is TripsCancelTripLoadingState,
              child: const TripsBody(),
            ),
          );
        },
      ),
    );
  }
}
