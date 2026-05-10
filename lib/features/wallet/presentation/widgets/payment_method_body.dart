import '../../../../core/imports/imports.dart';
import 'payment_methods_cards.dart';

class PaymentMethodBody extends StatelessWidget {
  const PaymentMethodBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, state) {
        final cubit = context.read<WalletCubit>();
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
          child: Column(
            children: [
              //! Header
              CustomAppBar(title: AppStrings.paymentMethods.tr(context)),

              SizedBox(height: 26.rH(context)),

              //! Title
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  AppStrings.choosePaymentMethod.tr(context),
                  style: Styles.medium15(context).copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),

              SizedBox(height: 17.rH(context)),

              //! Payment Methods
              const PaymentMethodsCards(),

              SizedBox(height: 16.rH(context)),

              //! Save Button
              CustomButton(
                enabled: cubit.selectedPaymentId != null,
                onPressed: () {
                  if (cubit.returnPayment) {
                    Navigator.pop(
                      context,
                      [cubit.selectedPaymentId, cubit.selectedSubPaymentId],
                    );
                    return;
                  }
                  cubit.setDefaultPaymentMethod();
                },
                title: cubit.findDriver
                    ? AppStrings.findDriver.tr(context)
                    : AppStrings.save.tr(context),
              ),

              SizedBox(height: 24.rH(context)),
            ],
          ),
        );
      },
    );
  }
}
