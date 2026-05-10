import '../../../../core/imports/imports.dart';
import 'package_details_check_box.dart';

class PackageDetailsTypeSection extends StatelessWidget {
  const PackageDetailsTypeSection({super.key});

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
                AppStrings.whatDoYouWantToDeliver.tr(context),
                style: Styles.medium14(context).copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
            SizedBox(height: 10.rH(context)),
            //! Check Boxes
            AnimatedCrossFade(
              firstChild: GridView.builder(
                itemCount: cubit.deliveryItems.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 43.rH(context),
                  mainAxisSpacing: 16.rH(context),
                  crossAxisSpacing: 16.rW(context),
                ),
                itemBuilder: (context, index) {
                  return BlocBuilder<DeliveryCubit, DeliveryState>(
                    builder: (context, state) {
                      final cubit = context.read<DeliveryCubit>();
                      return PackageDetailsCheckBox(
                        title: cubit.deliveryItems[index].name ?? "",
                        svg: cubit.deliveryItems[index].logo,
                        selected: cubit.selectedItemId ==
                            cubit.deliveryItems[index].id,
                        onTap: () => cubit.chooseItemType(index),
                      );
                    },
                  );
                },
              ),
              secondChild: Container(),
              crossFadeState: cubit.deliveryItems.isNotEmpty
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
