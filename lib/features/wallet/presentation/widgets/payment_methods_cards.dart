import '../../../../core/imports/imports.dart';
import 'payment_method_card.dart';

import 'sub_payment_method_card.dart';

class PaymentMethodsCards extends StatelessWidget {
  const PaymentMethodsCards({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, state) {
        final cubit = context.read<WalletCubit>();
        return Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: cubit.paymentMethods.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  //! Main Payment
                  PaymentMethodCard(
                    model: cubit.paymentMethods[index],
                    onTap: () =>
                        cubit.selectPayment(cubit.paymentMethods[index]),
                    selected: cubit.paymentMethods[index].id ==
                        cubit.selectedPaymentId,
                  ),
                  //! Sub Methods
                  AnimatedCrossFade(
                    firstChild: SubPaymentMethodCard(
                      mainPaymenModel: cubit.paymentMethods[index],
                    ),
                    secondChild: Container(),
                    crossFadeState:
                        cubit.paymentMethods[index].subPayments.isNotEmpty &&
                                cubit.paymentMethods[index].id ==
                                    cubit.selectedPaymentId
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 300),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
