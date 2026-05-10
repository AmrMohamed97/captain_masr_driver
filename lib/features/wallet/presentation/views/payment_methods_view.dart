import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../widgets/payment_method_body.dart';

class PaymentMethodsView extends StatelessWidget {
  const PaymentMethodsView({
    super.key,
    this.returnPayment = false,
    this.findDriver = false,
  });

  final bool returnPayment, findDriver;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WalletCubit()
        ..selectedPaymentId =
            context.read<GlobalCubit>().userModel?.defaultPaymentMethodId
        ..selectedSubPaymentId =
            context.read<GlobalCubit>().userModel?.defaultSubPaymentMethodId
        ..getPaymentMethods()
        ..returnPayment = returnPayment
        ..findDriver = findDriver,
      child: BlocConsumer<WalletCubit, WalletState>(
        listener: (context, state) {
          if (state is SetDefaultPaymentSuccessState) {
            context.read<GlobalCubit>().updateUserData();
            showToast(
              context,
              message: state.message,
              state: ToastStates.success,
            );
            Navigator.pop(context);
          }
          if (state is WalletErrorState) {
            showToast(
              context,
              message: state.error,
              state: ToastStates.error,
            );
          }
        },
        builder: (context, state) => Scaffold(
          body: CustomModalProgressIndicator(
            inAsyncCall: state is SetDefaultPaymentLoadingState ||
                state is WalletLoadingState,
            child: const PaymentMethodBody(),
          ),
        ),
      ),
    );
  }
}
