import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../widgets/earnings_body.dart';

class EarningsView extends StatelessWidget {
  const EarningsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EarningsCubit(),
      child: Scaffold(
        body: BlocConsumer<EarningsCubit, EarningsState>(
          listener: (context, state) {
            if (state is EarningsErrorState) {
              showToast(
                context,
                message: state.error,
                state: ToastStates.error,
              );
            }
          },
          builder: (context, state) {
            return CustomModalProgressIndicator(
              inAsyncCall: state is EarningsLoadingState,
              child: const EarningsBody(),
            );
          },
        ),
      ),
    );
  }
}
