import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../widgets/requests_body.dart';

class RequestsView extends StatelessWidget {
  const RequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FindRidersCubit, FindRidersState>(
      listener: (context, state) {
        if (state is AcceptRequestSuccessState) {
          showToast(
            context,
            message: state.message,
            state: ToastStates.success,
          );
        }
        if (state is AcceptRequestErrorState) {
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
            inAsyncCall: state is AcceptRequestLoadingState,
            child: const RequestsBody(),
          ),
        );
      },
    );
  }
}
