import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../widgets/saved_places_body.dart';

class SavedPlacesView extends StatelessWidget {
  const SavedPlacesView({
    super.key,
    this.canChoose = false,
  });

  final bool canChoose;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SavedPlacesCubit()
        ..canChoose = canChoose
        ..getSavedLocations(),
      child: Scaffold(
        body: BlocConsumer<SavedPlacesCubit, SavedPlacesState>(
          listener: (context, state) {
            if (state is DeleteLocationSuccessState) {
              showToast(
                context,
                message: state.message,
                state: ToastStates.success,
              );
            }
            if (state is GetSavedLocationErrorState) {
              showToast(
                context,
                message: state.error,
                state: ToastStates.error,
              );
            }
            if (state is DeleteLocationErrorState) {
              showToast(
                context,
                message: state.error,
                state: ToastStates.error,
              );
            }
          },
          builder: (context, state) {
            return CustomModalProgressIndicator(
              inAsyncCall: state is DeleteLocationLoadingState,
              child: const SavedPlacesBody(),
            );
          },
        ),
      ),
    );
  }
}
