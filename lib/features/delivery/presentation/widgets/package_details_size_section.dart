import '../../../../core/imports/imports.dart';
import 'package_details_check_box.dart';

class PackageDetailsSizeSection extends StatelessWidget {
  const PackageDetailsSizeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryCubit, DeliveryState>(
      builder: (context, state) {
        final cubit = context.read<DeliveryCubit>();
        return Column(
          children: [
            //! Title
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                AppStrings.howBigIsTheItem.tr(context),
                style: Styles.medium14(context).copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
            SizedBox(height: 10.rH(context)),
            //! Check Boxes
            AnimatedCrossFade(
              firstChild: SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  runAlignment: WrapAlignment.start,
                  spacing: 8.rW(context),
                  runSpacing: 8.rH(context),
                  direction: Axis.horizontal,
                  children: List.generate(
                    cubit.deliverySizes.length,
                    (index) {
                      return PackageDetailsCheckBox(
                        title: cubit.deliverySizes[index].name ?? "",
                        selected: cubit.selectedSizeId ==
                            cubit.deliverySizes[index].id,
                        onTap: () => cubit.chooseSize(index),
                        isExpanded: false,
                      );
                    },
                  ),
                ),
              ),
              secondChild: Container(),
              crossFadeState: cubit.deliverySizes.isNotEmpty
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 300),
            ),

            SizedBox(height: 26.rH(context)),
          ],
        );
      },
    );
  }
}
