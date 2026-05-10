import 'package:flutter_svg/svg.dart';

import '../../../../core/imports/imports.dart';
import '../../data/models/payment_method_model.dart';

class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard({
    super.key,
    required this.model,
    required this.onTap,
    required this.selected,
  });

  final PaymentMethodModel model;
  final Function() onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: 79.rH(context),
        margin: EdgeInsets.only(
          bottom: model.subPayments.isNotEmpty ? 3.rH(context) : 15.rH(context),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.transparent,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 2.rH(context)),
              color: AppColors.black.withOpacity(.05),
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          children: [
            //! Icon
            Container(
              width: 51.rW(context),
              height: 37.rH(context),
              padding: EdgeInsets.symmetric(
                vertical: 5.5.rH(context),
                horizontal: 13.rW(context),
              ),
              decoration: BoxDecoration(
                color: AppColors.grey4,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Image.network(
                model.logo ?? "",
                height: 24.rH(context),
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.error,
                  color: AppColors.grey,
                ),
              ),
            ),

            SizedBox(width: 25.rW(context)),

            //! Title
            Expanded(
              child: Text(
                model.name ?? "",
                style: Styles.medium14(context).copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),

            //! Check Box
            CustomCheckBox(
              value: selected,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
