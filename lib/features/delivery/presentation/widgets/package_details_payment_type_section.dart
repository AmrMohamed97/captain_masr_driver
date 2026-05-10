import '../../../../core/imports/imports.dart';
import 'package_details_check_box.dart';

class PackageDetailsPaymentTypeSection extends StatelessWidget {
  const PackageDetailsPaymentTypeSection({super.key});

  static const List<String> items = [
    AppStrings.preorder,
    AppStrings.cashOnDelivery,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //! Title
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            "${AppStrings.choosePaymentTime.tr(context)}:",
            style: Styles.medium14(context).copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ),
        SizedBox(height: 10.rH(context)),
        //! Check Boxes
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            items.length,
            (index) {
              return BlocBuilder<DeliveryCubit, DeliveryState>(
                builder: (context, state) {
                  final cubit = context.read<DeliveryCubit>();
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(
                        end: index == items.length - 1 ? 0 : 16.rW(context),
                      ),
                      child: PackageDetailsCheckBox(
                        title: items[index].tr(context),
                        selected: cubit.selectedPaymentIndex == index,
                        onTap: () => cubit.choosePaymentType(index),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        SizedBox(height: 26.rH(context)),
      ],
    );
  }
}
