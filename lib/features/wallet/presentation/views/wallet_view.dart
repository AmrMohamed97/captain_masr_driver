import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../widgets/wallet_body.dart';

class WalletView extends StatelessWidget {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WalletCubit()
        ..isRider = context.read<GlobalCubit>().isRider
        ..getTransations(),
      child: BlocConsumer<WalletCubit, WalletState>(
        listener: (context, state) {
          if (state is WalletSuccessState) {
            state.message != null
                ? showToast(
                    context,
                    message: state.message!,
                    state: ToastStates.success,
                  )
                : null;
          }
          if (state is WalletErrorState) {
            showToast(
              context,
              message: state.error,
              state: ToastStates.error,
            );
          }
        },
        builder: (context, state) {
          return const Scaffold(
            body: WalletBody(),
          );
        },
      ),
    );
  }
}
