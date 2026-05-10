import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../widgets/trip_details_body.dart';

class TripDetailsView extends StatelessWidget {
  const TripDetailsView({
    super.key,
    required this.tripId,
    this.isAccepted = false,
    this.isCompleted = false,
    this.isClassic = false,
    this.isGroup = false,
    this.isShare = false,
    this.isDelivery = false,
    this.isScheduled = false,
  });

  final int tripId;
  final bool isAccepted,
      isCompleted,
      isGroup,
      isClassic,
      isShare,
      isDelivery,
      isScheduled;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TripDetailsCubit()
        ..getDays()
        ..isAccepted = isAccepted
        ..isCompleted = isCompleted
        ..isClassic = isClassic
        ..isGroup = isGroup
        ..isShare = isShare
        ..isDelivery = isDelivery
        ..isScheduled = isScheduled
        ..promoCodeController.text = isAccepted ? "Maak59" : ""
        ..promoCodeApplied = isAccepted
        ..getTripDetails(
          tripId: tripId,
          isRider: context.read<GlobalCubit>().isRider,
        ),
      child: BlocConsumer<TripDetailsCubit, TripDetailsState>(
        listener: (context, state) {
          if (state is TripDetailsErrorState) {
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
              inAsyncCall: state is TripDetailsLoadingState,
              child: const TripDetailsBody(),
            ),
          );
        },
      ),
    );
  }
}
