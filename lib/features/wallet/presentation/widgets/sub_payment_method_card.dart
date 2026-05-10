import 'package:flutter_svg/svg.dart';

import '../../../../core/imports/imports.dart';
import '../../data/models/payment_method_model.dart';

class SubPaymentMethodCard extends StatelessWidget {
  const SubPaymentMethodCard({
    super.key,
    required this.mainPaymenModel,
  });

  final PaymentMethodModel mainPaymenModel;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, state) {
        final cubit = context.read<WalletCubit>();
        return Container(
          width: double.infinity,
          height: 58.rH(context),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 2.rH(context)),
                color: AppColors.black.withOpacity(.05),
                blurRadius: 20,
              ),
            ],
          ),
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(
              horizontal: 16.5.rW(context),
            ),
            scrollDirection: Axis.horizontal,
            children: List.generate(
              mainPaymenModel.subPayments.length,
              (subIndex) {
                final bool selected =
                    mainPaymenModel.subPayments[subIndex].id ==
                        cubit.selectedSubPaymentId;
                return GestureDetector(
                  onTap: () {
                    cubit.selectSubPayment(
                        mainPaymenModel.subPayments[subIndex].id);
                  },
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 37.rH(context),
                      width: 51.rW(context),
                      margin: EdgeInsetsDirectional.only(
                        end: 14.rW(context),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.grey.withOpacity(.25),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : AppColors.transparent,
                        ),
                      ),
                      child: mainPaymenModel.subPayments[subIndex].logo
                                  ?.contains(".svg") ??
                              false
                          ? SvgPicture.network(
                              mainPaymenModel.subPayments[subIndex].logo ?? "",
                              height: 24.rH(context),
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                Icons.error,
                                color: AppColors.grey,
                              ),
                            )
                          : Image.network(
                              mainPaymenModel.subPayments[subIndex].logo ?? "",
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                Icons.error,
                                color: AppColors.grey,
                              ),
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
